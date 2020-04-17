function [ timers, opts, iter ] = parallelStepCentral( sProb, iter, timers, opts )
    global use_fmincon
    NsubSys = length(sProb.AA);

    loc = [];
    % solve local problems
    for j=1:NsubSys % parfor???
        [Neq, Nineq] = get_constraint_dimensions(sProb, j);
        pNum = setup_parameters(sProb, iter, j);

        tic
        fprintf('\n\nSolving NLP in region %i\n', j);
        [x0, z, rho, lambda, Sigma, problem] = unpack(sProb, iter, opts, j);
        sol = problem.solve_nlp(x0, z, rho, lambda, Sigma, problem.pars);
        loc = assign_solution(loc, sol, j);
        timers.NLPtotTime = timers.NLPtotTime + toc;                           
        loc = detect_active_set(sProb, loc, opts, j);
        [loc, opts] = update_sigma(loc, iter, opts, j);

        tic
        fprintf('\nEvaluating sensitivities in region %i\n', j);
        [loc, iter, Jac] = evaluate_sensitivities(sProb, loc, iter, opts, j);
        timers.sensEvalT        = timers.sensEvalT + toc;

        fprintf('\nComputing reduced QP in region %i\n', j);
        [loc, iter, timers] = compute_reduced_qp(sProb, loc, iter, opts, timers, Jac, j);
    end 

    loc = save_for_bfgs(loc, opts);
    iter.loc = loc;
end

function [Neq, Nineq] = get_constraint_dimensions(prob, j)
    x = prob.zz0{j};
    eq = prob.locFuns.ggi{j};
    ineq = prob.locFuns.hhi{j};

    Neq = length(eq(x));
    Nineq = length(ineq(x));
end

function p = setup_parameters(prob, iter, j)
    % set up parameter vector for local NLPs
    p = [ iter.stepSizes.rho; iter.lam; iter.yy{j}];
    
    if isfield(prob, 'p')
        p = [p; prob.p];
    end
end

function [x0, z, rho, lambda, Sigma, problem] = unpack(prob, iter, opts, j)
    x0 = iter.yy{j};
    z = iter.yy{j};
    rho = iter.stepSizes.rho;
    lambda = iter.lam;
    Sigma = sparse(opts.SSig{j});
    problem = prob.nnlp{j};
end

function loc = assign_solution(loc, sol, j)
    [ loc.xx{j}, loc.KKapp{j}, loc.LLam_x{j} ] = deal(full(sol.x), full(sol.lam_g), full(sol.lam_x));
end

function loc = detect_active_set(prob, loc, opts, j)
    x = loc.xx{j};
    ineq_eval = prob.locFuns.hhi{j}(x);
    eq_eval = prob.locFuns.ggi{j}(x);
    
    loc.inact{j}    = logical([false(size(eq_eval)); full(ineq_eval < opts.actMargin)]);
end

function [loc, opts] = update_sigma(loc, iter, opts, j)
    % dynamically changing \Sigma?
    if strcmp(opts.Sig, 'dyn')
        % after second iteration 
        if iter.i > 1 
            [opts.SSig{j}, loc.locStep{j}] = computeDynSig(opts.SSig{j}, iter.yy{j} - loc.xx{j},iter.loc.locStep{j}, 'Sig');
        else
            loc.locStep{j} = iter.yy{j} - loc.xx{j};
        end
    end
end

function loc = evaluate_gradient(prob, loc, j)
    loc.sensEval.ggiEval{j} = prob.sens.gg{j}(loc.xx{j});
end

function [loc, iter] = evaluate_hessian(prob, loc, opts, iter, j)
    % Hessian approximations
    if strcmp(opts.Hess, 'BFGS') || strcmp(opts.Hess, 'DBFGS')
        loc.sensEval.gLiEval{j}   = prob.sens.gL{j}(loc.xx{j},loc.KKapp{j});
        if ~isfield(iter.loc, 'sensEval')
            if strcmp(opts.BFGSinit, 'ident')
                % initialize BFGS with identity matrix
                loc.sensEval.HHiEval{j}   = eye(length(prob.zz0{j}));
            elseif strcmp(opts.BFGSinit, 'exact')
                % initialize BFGS with exact Hessian
                loc.sensEval.HHiEval{j}   =  ...
                    prob.sens.HH{j}(loc.xx{j},loc.KKapp{j},iter.stepSizes.rho);
            end
        else
            loc.sensEval.HHiEval{j}   = BFGS(iter.loc.sensEval.HHiEval{j},...
                                             loc.sensEval.gLiEval{j},...
                                             iter.loc.sensEval.gLiEvalOld{j},...
                                             loc.xx{j},...
                                             iter.loc.xxOld{j},...
                                             opts.Hess);
        end
        if strcmp(opts.commCount, 'true') && ~strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none')
            % communication for xx and the gradient of the Lagrangian and
            % the objective
            iter.comm.globF.Hess{j}    = [ iter.comm.globF.Hess{j} length(iter.loc.xx{j}) ];
            iter.comm.globF.grad{j}    = [ iter.comm.globF.grad{j} length(iter.loc.xx{j}) ];
            iter.comm.globF.primVal{j} = [ iter.comm.globF.primVal{j} length(iter.loc.xx{j}) ];
        end
    else
        loc.sensEval.HHiEval{j}   = prob.sens.HH{j}(loc.xx{j},loc.KKapp{j},iter.stepSizes.rho);
        
        if strcmp(opts.commCount, 'true') && ~strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none')
            % communication for xx and the gradient of the Lagrangian and
            % the objective
            iter.comm.globF.Hess{j}    = [ iter.comm.globF.Hess{j} length(iter.loc.xx{j})*(length(iter.loc.xx{j}) + 1)/2 ];
            iter.comm.globF.grad{j}    = [ iter.comm.globF.grad{j} length(iter.loc.xx{j}) ];
            iter.comm.globF.primVal{j} = [ iter.comm.globF.primVal{j} length(iter.loc.xx{j}) ];
        end
    end 
end

function [loc, JacCon] = evaluate_jacobian(prob, loc, opts, j)
    % Jacobians of active nonlinear constraints/bounds
    JacCon           = full(prob.sens.JJac{j}(loc.xx{j}));    
    JacBounds        = eye(size(loc.xx{j},1));

    % eliminate inactive entries  
    JJacCon{j}       = sparse(JacCon(~loc.inact{j},:));      
    JacBounds        = JacBounds((prob.llbx{j} - loc.xx{j}) > opts.actMargin |(loc.xx{j}-prob.uubx{j}) > opts.actMargin,:);
    loc.sensEval.JJacCon{j} = [JJacCon{j}; JacBounds];   
end

function [loc, iter, Jac] = evaluate_sensitivities(prob, loc, iter, opts, j)
    loc = evaluate_gradient(prob, loc, j);
    [loc, iter] = evaluate_hessian(prob, loc, opts, iter, j);
    [loc, Jac] = evaluate_jacobian(prob, loc, opts, j);
end

function [loc, iter, timers] = compute_reduced_qp(prob, loc, iter, opts, timers, Jac, j)
    % for reduced-space method, compute reduced QP
    if strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none')

        loc.sensEval.ZZ{j}    = null(full(Jac));
        loc.sensEval.HHred{j} = loc.sensEval.ZZ{j}'* ...
                          full(loc.sensEval.HHiEval{j})*loc.sensEval.ZZ{j};
        
        loc.sensEval.AAred{j} = prob.AA{j}*loc.sensEval.ZZ{j};
        loc.sensEval.ggred{j} = loc.sensEval.ZZ{j}'*full(loc.sensEval.ggiEval{j});

        % regularize reduced Hessian
        tic
        if strcmp(opts.reg,'true')
            loc.sensEval.HHred{j}  = regularizeH(loc.sensEval.HHred{j}, opts);
        end
        timers.RegTotTime = timers.RegTotTime + toc;    
        
        if strcmp(opts.commCount, 'true') && strcmp(opts.innerAlg, 'none')
           % number of floats for the reduce-space method (no sparsity ex.)
           sH = size(loc.sensEval.HHred{j});
           sA = size(loc.sensEval.AAred{j});
           iter.comm.globF.AAred{j}   = [ iter.comm.globF.AAred{j} sA(1)*sA(2) ];
           iter.comm.globF.Hess{j}    = [ iter.comm.globF.Hess{j} sH(1)*(sH(1) + 1)/2 ];
           iter.comm.globF.grad{j}    = [ iter.comm.globF.grad{j} sH(1) ];
           iter.comm.globF.Jac{j}     = [ iter.comm.globF.Jac{j} 0 ];
           % reduced primal values
           iter.comm.globF.primVal{j} = [ iter.comm.globF.primVal{j} sH(1) ];
        end
    else
        % regularization full Hessian
        tic
        if strcmp(opts.reg,'true')
            loc.sensEval.HHiEval{j} = ...
                                 regularizeH(loc.sensEval.HHiEval{j},opts);
        end
        timers.RegTotTime = timers.RegTotTime + toc;
        
        if strcmp(opts.commCount, 'true') && strcmp(opts.innerAlg, 'none')
           % number of floats in the Jacobian of the active constraints
           sJ = size(loc.sensEval.JJacCon{j});
           iter.comm.globF.Jac{j} = [ iter.comm.globF.Jac{j} sJ(1)*sJ(2) ];
        end
    end
end

function loc = save_for_bfgs(loc, opts)
    % save information for next BFGS iteration
    if strcmp(opts.Hess, 'BFGS') || strcmp(opts.Hess, 'DBFGS')
        loc.sensEval.gLiEvalOld = loc.sensEval.gLiEval;
        loc.xxOld               = loc.xx;
    end
end