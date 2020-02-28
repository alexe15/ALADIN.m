function [ loc, timers ] = parallelStepDecentral( sProb, iter, timers, opts )
%DECENTRALIZEDPARALLELSTEP Summary of this function goes here
NsubSys = length(sProb.AA);

% initialize space and parfor compatilbe datatype
loc_temp = cell2struct(cell(5, NsubSys), {'xx', 'KKapp', 'LLam_x', 'inact', 'sensEval'}, 1);
timers_temp = cell2struct(cell(3, NsubSys), {'NLPtotTime', 'sensEvalT', 'RegToTTime'}, 1);
% copy sProb.nnlp to local cell to increase performance
loc_nnlp = sProb.nnlp;
xxTmp = iter.loc.xx;
SSig = cell(1, NsubSys);
SSig = opts.SSig;

 % solve local problems
parfor j=1:NsubSys % parfor???
    nngi = size(sProb.locFunsCas.ggi{j},1);
        
    % set up parameter vector for local NLP's
    pNum = [ iter.stepSizes.rho;
             iter.lam;
             iter.yy{j}];

    % solve local NLP's
    tic
    sol = loc_nnlp{j}('x0' ,   xxTmp {j},...
                        'lam_g0', iter.KKapp{j},...
                        'lam_x0', iter.LLam_x{j},...
                        'p',      [pNum; opts.SSig{j}(:)],...
                        'lbx',    sProb.llbx{j},...
                        'ubx',    sProb.uubx{j},...
                        'lbg',    sProb.gBounds.llb{j}, ...
                        'ubg',    sProb.gBounds.uub{j});     

    % collect variables 
    [ loc_temp(j).xx, loc_temp(j).KKapp, loc_temp(j).LLam_x ] = deal(full(sol.x), ...
                                         full(sol.lam_g), full(sol.lam_x));
                                     
    % timers.NLPtotTime = timers.NLPtotTime + toc;
    timers_temp(j).NLPtotTime = toc;

    % primal active set detection
    loc_temp(j).inact    = logical([false(nngi,1); ...
                      full(sProb.locFuns.hhi{j}(loc_temp(j).xx) < opts.actMargin)]);
    KKapp{j}(loc_temp(j).inact) = 0;

   % dynamically changing \Sigma?
    if strcmp(opts.Sig,'dyn')
         % after second iteration 
         if size(iter.logg.X,2) > 2 
             [SSig(j), loc_temp(j).locStep] = computeDynSig(opts.SSig{j},...
                                 iter.yy{j}, loc_temp(j).xx,iter.loc.locStep{j});
         else
             loc_temp(j).locStep = iter.yy{j} - loc_temp(j).xx;
         end
    end
    
    % evaluate gradients and Hessians of the local problems
    tic
    loc_temp(j).sensEval.ggiEval = sProb.sens.gg{j}(loc_temp(j).xx);
     
    if strcmp(opts.Hess, 'BFGS') || strcmp(opts.Hess, 'DBFGS')
         loc_temp(j).sensEval.gLiEval   = sProb.sens.gL{j}(loc_temp(j).xx,loc_temp(j).KKapp);
         if ~isfield(iter.loc, 'sensEval')
             loc_temp(j).sensEval.HHiEval   = eye(length(sProb.zz0{j}));
         else
             loc_temp(j).sensEval.HHiEval   = BFGS(iter.loc.sensEval.HHiEval{j},...
                                              loc_temp(j).sensEval.gLiEval,...
                                              iter.loc.sensEval.gLiEvalOld{j},...
                                              loc_temp(j).xx,...
                                              iter.loc.xxOld{j},...
                                              opts.Hess);
         end
     else
         loc_temp(j).sensEval.HHiEval   = sProb.sens.HH{j}(loc_temp(j).xx,loc_temp(j).KKapp,iter.stepSizes.rho);
     end

    % Jacobians of active nonlinear constraints/bounds
    JacCon           = full(sProb.sens.JJac{j}(loc_temp(j).xx));    
    JacBounds        = eye(size(loc_temp(j).xx,1));

    % eliminate inactive entries  
    JJacCon{j}       = sparse(JacCon(~loc_temp(j).inact,:));      
    JacBounds        = JacBounds((sProb.llbx{j} - loc_temp(j).xx)  ...
           > opts.actMargin |(loc_temp(j).xx-sProb.uubx{j}) > opts.actMargin,:);
    loc_temp(j).sensEval.JJacCon      = [JJacCon{j}; JacBounds];     
    
    % timers.sensEvalT = timers.sensEvalT + toc;
    timers_temp(j).sensEvalT = toc;
    
    
    % for reduced-space method, compute reduced QP
    if strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none')

        loc_temp(j).sensEval.ZZ    = null(full(JJacCon{j}));
        loc_temp(j).sensEval.HHred = loc_temp(j).sensEval.ZZ'* ...
                          full(loc_temp(j).sensEval.HHiEval)*loc_temp(j).sensEval.ZZ;
        loc_temp(j).sensEval.AAred = sProb.AA{j}*loc_temp(j).sensEval.ZZ;
        loc_temp(j).sensEval.ggred = loc_temp(j).sensEval.ZZ'*full(loc_temp(j).sensEval.ggiEval);

        % regularize reduced Hessian
        tic
        if strcmp(opts.reg,'true')
            loc_temp(j).sensEval.HHred  = regularizeH(loc_temp(j).sensEval.HHred, opts);
        end

        timers_temp(j).RegToTTime = toc;
    else
        % regularization full Hessian
        tic
        if strcmp(opts.reg,'true')
            loc_temp(j).sensEval.HHiEval = ...
                                 regularizeH(loc_temp(j).sensEval.HHiEval,opts);
        end

        timers_temp(j).RegToTTime = toc;
    end
end 
% copy local parfor data into global data
parforVars2globalVars;

% save information for next BFGS iteration
if strcmp(opts.Hess, 'BFGS') || strcmp(opts.Hess, 'DBFGS')
    loc.sensEval.gLiEvalOld = loc.sensEval.gLiEval;
    loc.xxOld               = loc.xx;
end

end