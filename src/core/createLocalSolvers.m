function [ nnlp, gBounds, rhoCas ] = createLocalSolvers( sProb, opts )
% set up solvers for local NLPs
import casadi.*
NsubSys = length(sProb.AA);
rhoCas  = opts.sym('rho',1,1);
lamCas  = opts.sym('lam',size(sProb.AA{1},1),1);
if isfield(sProb, 'p')
    par     = opts.sym('par',size(sProb.p,1),1);
    error('currently not supported.');
end

funs = sProb.locFuns;
z0 = sProb.zz0;
solver = sProb.solver;

for i=1:NsubSys     
    nnxi{i} = size(sProb.AA{i},2);
    nngi{i} = size(funs.ggi{i}(z0{i}), 1);
    nnhi{i} = size(funs.hhi{i}(z0{i}), 1);    
    
    % set up bounds for equalities/inequalities
    gBounds.llb{i}  = [zeros(nngi{i},1); -inf*ones(nnhi{i},1)];
    gBounds.uub{i}  = zeros(nngi{i}+nnhi{i},1);
    
    [solve_nlp, pars] = deal([]);

    pars = [];
    funs = sProb.locFuns;
    sens = sProb.sens;
    if strcmp(solver, 'fmincon')
        solve_nlp = @(x, z, rho, lambda, Sigma, pars)build_local_NLP_with_fmincon(funs.ffi{i}, funs.ggi{i}, funs.hhi{i}, sProb.AA{i}, lambda, rho, z, Sigma, x, sProb.llbx{i}, sProb.uubx{i}, sens.JJac{i}, sens.gg{i}, sens.HH{i});   
    elseif strcmp(solver, 'fminunc')
        solve_nlp = @(x, z, rho, lambda, Sigma, pars)build_local_NLP_with_fminunc(funs.ffi{i}, funs.ggi{i}, funs.hhi{i}, sProb.AA{i}, lambda, rho, z, Sigma, x, sProb.llbx{i}, sProb.uubx{i}, sens.JJac{i}, sens.gg{i}, sens.HH{i});   

    elseif strcmp(solver, 'Casadi+Ipopt')
        assert(isfield(sProb, 'locFunsCas'), 'locFunsCas field is missing')
        nlp_reference = build_nlp_reference(sProb.xxCas{i},...
                                            sProb.locFunsCas.ffi{i},...
                                            sProb.locFunsCas.ggi{i},...
                                            sProb.locFunsCas.hhi{i},...
                                            sProb.AA{i},...
                                            lamCas,...
                                            rhoCas,...
                                            opts);
        pars = struct('lam_g0', [], 'lam_x0', []);
        solve_nlp  = @(x, z, rho, lambda, Sigma, pars)build_nlp_with_casadi(x, z, rho, lambda, Sigma, pars, nlp_reference, sProb.llbx{i}, sProb.uubx{i}, gBounds.llb{i}, gBounds.uub{i});
    elseif strcmp(solver, 'worhp')
        solve_nlp = @(x, z, rho, lambda, Sigma, pars)build_local_NLP_with_worhp(funs.ffi{i}, funs.ggi{i}, funs.hhi{i}, sProb.AA{i}, lambda, rho, z, Sigma, x, sProb.llbx{i}, sProb.uubx{i}, sens.JJac{i}, sens.gg{i}, sens.HH{i});
    end
    
nnlp{i} = struct('solve_nlp', solve_nlp, 'pars', pars); 
end
end

function nlp_reference = build_nlp_reference(x, f, g, h, A, lambda, rho, opts)
    import casadi.*
    nx = length(x);
    Sigma = opts.sym('SSig',[nx nx]);
    z  = opts.sym('z',nx,1);
%     local_cost = feval(@f,x);
    cost = f + lambda'*A*x + rho/2*(x - z)'*Sigma*(x - z);

    [NLPopts, solver]  = loadNLPopts();

    nlp      = struct('x',x,'f',cost, ...
                      'g',[g; h], ...
                      'p',[rho; lambda; z; Sigma(:)]);
    nlp_reference = nlpsol('solver', solver, nlp, NLPopts);
end

function res = build_nlp_with_casadi(x, z, rho, lambda, Sigma, pars, nlp, lbx, ubx, lbg, ubg)
    sol  = nlp( 'x0', x,...
                'lam_g0', pars.lam_g0,...
                'lam_x0', pars.lam_x0,...
                'p',      [rho; lambda; z; Sigma(:)],...
                'lbx',    lbx,...
                'ubx',    ubx,...
                'lbg',    lbg, ...
                'ubg',    ubg); 
    res.x = sol.x;
    res.lam_g = sol.lam_g;
    res.lam_x = sol.lam_x;
    res.pars.lam_g0 = res.lam_g;
    res.pars.lam_x = res.lam_x;
end

function res = build_local_NLP_with_fmincon(f, g, h, A, lambda, rho, z, Sigma, x0, lbx, ubx, dgdx, dfdx, Hessian)
    opts = optimoptions('fmincon');
    opts.Algorithm = 'interior-point';
    opts.CheckGradients = false;
    opts.SpecifyConstraintGradient = true;
    opts.SpecifyObjectiveGradient = true;
    opts.Display = 'iter';
    Nx  =  numel(x0);
    % select Hessian approximation
    if isempty(g(x0)) && isempty(h(x0)) 
%        unconstrained problem and Hessian is computed by hand
        opts.HessFcn = @(x,kappa)build_hessian(Hessian(x,0,0), zeros(Nx,Nx), rho, Sigma);
    else
        %% three method to approach hessian: BFGS, limit-memory BFGS, infinite jacobian 
%       opts.HessianApproximation = 'bfgs';
      opts.HessianApproximation = 'lbfgs';
%         opts.HessFcn = @(x,kappa)build_hessian(zeros(Nx,Nx), Hessian(x,kappa.eqnonlin,0), rho, Sigma);
    end
    objective    = @(x)build_objective(x, f(x), dfdx(x), [], lambda, A, rho, z, Sigma);
    nonlcon = @(x)build_nonlcon(x, g, h, dgdx);
    [xopt, fval, flag, out, multiplier] = fmincon(objective, x0, [], [], [], [], lbx, ubx, nonlcon, opts);
    res.x = xopt;
    res.lam_g = [multiplier.eqnonlin; multiplier.ineqnonlin];
    res.lam_x = max(multiplier.lower, multiplier.upper);
    res.pars = [];
end

function res = build_local_NLP_with_fminunc(f, g, h, A, lambda, rho, z, Sigma, x0, lbx, ubx, dgdx, dfdx, Hessian)
    options = optimoptions('fminunc');
    options.Algorithm = 'trust-region';
    options.SpecifyObjectiveGradient= true;
    options.HessianFcn = 'objective';
    options.Display='iter';
    objective    = @(x)build_objective(x, f(x), dfdx(x) , Hessian(x), lambda, A, rho, z, Sigma);
    [xopt, fval, flag, ~, multiplier] = fminunc(objective, x0, options);
    res.x = xopt;
    res.lam_g = [];
    res.lam_x = [];
    res.pars = [];
end


function res = build_local_NLP_with_worhp(f, g, h, A, lambda, rho, z, Sigma, x0, lbx, ubx, dgdx, dfdx, Hessian)
    %% assumption: least-square problem, i.e. without constraints
    Nx            = numel(x0);    
    Ng            = numel(g(x0));
    cost          = @(x)build_cost(x, f(x), lambda, A, rho, z, Sigma);
    grad          = @(x)build_grad(x, dfdx(x), lambda, A, rho, z, Sigma);
    if isempty(g(x0)) && isempty(h(x0)) 
    % unconstrained problem and Hessian is computed by hand
        Hess.Func = @(x,kappa,scale)build_hessian(Hessian(x,0,0), zeros(Nx,Nx), rho, Sigma, scale);
        Jac.Func      = @(x)0;
        Jac.nonzero_pos.idx = 1;
        Jac.nonzero_pos.row = 1;
        Jac.nonzero_pos.col = 1;
    else
        Hess.Func = @(x,kappa,scale)build_hessian(zeros(Nx,Nx), Hessian(x,kappa) , rho, Sigma, scale);
        Jac.Func      = @(x)dgdx(x);
        Jac.nonzero_pos  = build_nonzero_vector_worhp(Jac.Func,Nx);
    end
    % transform hessian matrix into hessian vector for WORHP solver
    Hess.nonzero_pos     = build_nonzero_vector_worhp(Hess.Func,Nx,Ng);
    [xopt, lam_x, lam_g]           = worhp_interface(cost,grad, g, Jac, Hess,x0,lbx,ubx);
    res.x                        = xopt;
    res.lam_g                    = lam_g;
    res.lam_x                    = lam_x;
    res.pars                     = [];
end
% function res = build_local_NLP_with_worhp(f, g, h, A, lambda, rho, z, Sigma, x0, lbx, ubx, dgdx, dfdx, Hessian)
%     %% assumption: least-square problem, i.e. without constraints
%     Nx            = numel(x0);    
%     Ng            = numel(g(x0));
%     cost          = @(x)build_cost(x, f(x), lambda, A, rho, z, Sigma);
%     grad          = @(x)build_grad(x, dfdx(x), lambda, A, rho, z, Sigma);
%     if isempty(g(x0)) && isempty(h(x0)) 
%     % unconstrained problem and Hessian is computed by hand
%         Hess.Func = @(x,kappa,scale)build_hessian(Hessian(x,0,0), zeros(Nx,Nx), rho, Sigma, scale);
%     else
%         Hess.Func = @(x,kappa,scale)build_hessian(zeros(Nx,Nx), Hessian(x,kappa) , rho, Sigma, scale);
%     end
%     % transform hessian matrix into hessian vector for WORHP solver
%     Hess.nonzero_pos     = build_idx_HessVector_worhp(Hess.Func,Nx,Ng);
%     [xopt, lam_x, lam_g]           = worhp_interface(cost,grad, g, dgdx, Hess,x0,lbx,ubx);
%     res.x                        = xopt;
%     res.lam_g                    = lam_g;
%     res.lam_x                    = lam_x;
%     res.pars                     = [];
% end

function [fun, grad, Hessian] = build_objective(x, f, dfdx, H, lambda, A, rho, z, Sigma)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % the code assumes that Sigma is symmetric and positive definite!!!
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fun = double( build_cost(x, f, lambda, A, rho, z, Sigma));
    if nargout > 1
        grad = double(build_grad(x, dfdx, lambda, A, rho, z, Sigma));
        if nargout > 2
            % only called by fminunc
            Nx      = numel(x);
            Hessian = build_hessian(H,zeros(Nx,Nx), rho, Sigma);
        end
    end
end

function fun = build_cost(x, f, lambda, A, rho, z, Sigma)
    fun = f + lambda'*A*x + 0.5*rho*(x - z)'*Sigma*(x - z);
end

function grad = build_grad(x, dfdx, lambda, A, rho, z, Sigma)
    grad = dfdx + A'*lambda + rho*Sigma*(x - z);
end

function hm  = build_hessian(hessian_f, kappa_hessian_g, rho, Sigma, scale)
    if nargin > 4
        % worhp scale hessian_f
        hessian_f = hessian_f .* scale;
    end
    hm   = hessian_f + rho * Sigma + kappa_hessian_g;
end

function [ineq, eq, jac_ineq, jac_eq] = build_nonlcon(x, g, h, dgdx)
    ineq = h(x);
    eq = g(x);
    if nargout > 2
        jac_ineq = [];
        jac_eq = dgdx(x)';
    end
end

% function HessVec_nonzero_pos = build_idx_HessVector_worhp(H, Nx, Ng)
%     nr = 5;
%     S  = zeros(Nx,Nx);
%     for i=1:nr
%         S = S + full(H(rand(Nx,1)/100, ones(Ng,1),1) ~=0);
%     end
%     % get sparsity
%     S = S ~=0;
%     % convert everything to vectors for WORHP
%     [row, col] = find(S);
%     idx = find(S);
%     
%     diag = find(row == col);
%     low_triangle = find(row>col);
%     HessVec_nonzero_pos.triangle.row  = row(low_triangle);
%     HessVec_nonzero_pos.triangle.col  = col(low_triangle);
%     HessVec_nonzero_pos.triangle.idx  = idx(low_triangle);
%     HessVec_nonzero_pos.diag.idx      = idx(diag);
%     HessVec_nonzero_pos.diag.iith = col(diag);   
% end
function nonzero_pos = build_nonzero_vector_worhp(M, Nx, Ng)
    nr = 20;
    if nargin > 2
        % hessian_f
        S  = zeros(size(M(ones(Nx,1),ones(Ng,1),1)));
        for i=1:nr
            S = S + full(M(rand(Nx,1), rand(Ng,1),1) ~=0);
        end
    else
        % kappa*hessian_g
        S  = zeros(size(M(ones(Nx,1))));
        for i=1:nr
            S = S + full(M(rand(Nx,1)) ~=0);
        end        
    end
    % get sparsity
    S = S ~=0;
    % convert everything to vectors for WORHP
    [row, col] = find(S);
    idx = find(S);
    if nargin > 2    
        diag = find(row == col);
        low_triangle = find(row>col);
        nonzero_pos.triangle.row  = row(low_triangle);
        nonzero_pos.triangle.col  = col(low_triangle);
        nonzero_pos.triangle.idx  = idx(low_triangle);
        nonzero_pos.diag.idx      = idx(diag);
        nonzero_pos.diag.iith = col(diag);   
    else
        nonzero_pos.row = row;
        nonzero_pos.col = col;
        nonzero_pos.idx = idx;
    end
    
end