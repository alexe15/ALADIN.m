function [ loc, timers ] = parallelStep( sProb, iter, timers, opts )
%PARALLELSTEP Summary of this function goes here
NsubSys = length(sProb.AA);

% solve local problems
for j=1:NsubSys % parfor???
    nngi{j} = size(sProb.locFunsCas.ggi{j},1);
    nnhi{j} = size(sProb.locFunsCas.hhi{j},1);    
    
    % set up parameter vector for local NLP's
    pNum = [ iter.stepSizes.rho;
             iter.lam;
             iter.yy{j}];

    % dynamicaaly changing \Sigma?
    if strcmp(opts.Sig,'dyn')
        SSig = computeDynSig(sProb);
    end
    
    % solve local NLP's
    tic
    sol = sProb.nnlp{j}('x0' ,    iter.loc.xx{j},...
                        'lam_g0', iter.KKapp{j},...
                        'lam_x0', iter.LLam_x{j},...
                        'p',      [pNum; opts.SSig{j}(:)],...
                        'lbx',    sProb.llbx{j},...
                        'ubx',    sProb.uubx{j},...
                        'lbg',    sProb.gBounds.llb{j}, ...
                        'ubg',    sProb.gBounds.uub{j});     

    % collect variables 
    [ loc.xx{j}, loc.KKapp{j}, loc.LLam_x{j} ] = deal(full(sol.x), ...
                                         full(sol.lam_g), full(sol.lam_x));
    timers.NLPtotTime = timers.NLPtotTime + toc;                           

    % primal active set detection
    loc.inact{j}    = logical([false(nngi{j},1); ...
                      full(sProb.locFuns.hhi{j}(loc.xx{j}) < opts.actMargin)]);
    KKapp{j}(loc.inact{j}) = 0;

    % evaluate gradients and Hessians of the local problems
    tic
    loc.sensEval.HHiEval{j} = sProb.sens.HH{j}(loc.xx{j},loc.KKapp{j},iter.stepSizes.rho);
    loc.sensEval.ggiEval{j} = sProb.sens.gg{j}(loc.xx{j});

    % compute the Jacobian of nonlinear constraints/bounds
    JacCon           = full(sProb.sens.JJac{j}(loc.xx{j}));    
    JacBounds        = eye(size(loc.xx{j},1));

    % eliminate inactive entries  
    JJacCon{j}       = sparse(JacCon(~loc.inact{j},:));      
    JacBounds        = JacBounds((sProb.llbx{j} - loc.xx{j})  ...
           > opts.actMargin |(loc.xx{j}-sProb.uubx{j}) > opts.actMargin,:);
    loc.sensEval.JJacCon{j}      = [JJacCon{j}; JacBounds];     
    timers.sensEvalT = timers.sensEvalT + toc;
    
        
    if strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none')
        % compute reduced systems locally 
        loc.sensEval.ZZ{j}    = null(full(JJacCon{j}));
        loc.sensEval.HHred{j} = loc.sensEval.ZZ{j}'* ...
                          full(loc.sensEval.HHiEval{j})*loc.sensEval.ZZ{j};
        loc.sensEval.AAred{j} = sProb.AA{j}*loc.sensEval.ZZ{j};
        loc.sensEval.ggred{j} = loc.sensEval.ZZ{j}'*full(loc.sensEval.ggiEval{j});

        % regularize reduced Hessian
        tic
        if strcmp(opts.reg,'true')
            loc.HHred{j}  = regularizeH(loc.HHred{j}, opts);
        end
        timers.RegTotTime = timers.RegTotTime + toc;        
    else
        % regularization full Hessian
        tic
        if strcmp(opts.reg,'true')
            loc.sensEval.HHiEval{j} = ...
                                 regularizeH(loc.sensEval.HHiEval{j},opts);
        end
        timers.RegTotTime = timers.RegTotTime + toc;
    end
end 
    
end

