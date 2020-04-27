function [parforTmpVar_j] = parallelStepInnerLoop(iteration_index, sProbCas_j,sProbValues, iter, parforTmpVar_j, opts)
%parallelStepInnerLoop outsourcing of inner loop

j = iteration_index;

gi = sProbCas_j.locFunsCas_ggi;
nngi = size(gi,1);


% 
% <<<<<<< HEAD
% =======
% % solve local problems
% for j=1:NsubSys % parfor???
% 
%     
%     % solve local NLP's
%     tic
%     %sol = sProb.nnlp{j}('x0' ,    iter.yy{j},... this should be correct
%     %but is not working for BFGS example
%     sol = sProb.nnlp{j}('x0' ,    iter.yy{j},...
%                         'lam_g0', iter.KKapp{j},...
%                         'lam_x0', iter.LLam_x{j},...
%                         'p',      [pNum; opts.SSig{j}(:)],...
%                         'lbx',    sProb.llbx{j},...
%                         'ubx',    sProb.uubx{j},...
%                         'lbg',    sProb.gBounds.llb{j}, ...
%                         'ubg',    sProb.gBounds.uub{j});     
% 
%     % collect variables 
%     [ loc.xx{j}, loc.KKapp{j}, loc.LLam_x{j} ] = deal(full(sol.x), ...
%                                          full(sol.lam_g), full(sol.lam_x));
%     timers.NLPtotTime = timers.NLPtotTime + toc;                           
% 
%     % primal active set detection
%     loc.inact{j}    = logical([false(nngi{j},1); ...
%                       full(sProb.locFuns.hhi{j}(loc.xx{j}) < opts.actMargin)]);
%     KKapp{j}(loc.inact{j}) = 0;
% >>>>>>> origin/Ruchuan
% 
% 


%nngi{j} = size(sProb.locFunsCas.ggi{j},1);

    



%-------------------------------------------------------------------------
% set up parameter vector for local NLP's
if ~isfield(sProbValues, 'p')
    pNum = [ iter.stepSizes.rho;
             iter.lam;
             iter.yy{j}];
else
    pNum = [ iter.stepSizes.rho;
             iter.lam;
             iter.yy{j};
             sProbValues.p{j}];
end


% solve local NLP's
tic
%sol = sProb.nnlp{j}('x0' ,    iter.yy{j},... this should be correct
%but is not working for BFGS example
sol = sProbCas_j.nnlp('x0' ,    iter.loc.xx{j},...
    'lam_g0', iter.KKapp{j},...
    'lam_x0', iter.LLam_x{j},...
    'p',      [pNum; opts.SSig{j}(:)],...
    'lbx',    sProbValues.llbx{j},...
    'ubx',    sProbValues.uubx{j},...
    'lbg',    sProbValues.gBounds.llb{j}, ...
    'ubg',    sProbValues.gBounds.uub{j});


% collect variables
[ parforTmpVar_j.loc.xx, parforTmpVar_j.loc.KKapp, parforTmpVar_j.loc.LLam_x ] = deal(full(sol.x), ...
    full(sol.lam_g), full(sol.lam_x));
%    timers.NLPtotTime = timers.NLPtotTime + toc;
parforTmpVar_j.timers.NLPtotTime = toc;

%-----------------------------------------------------------------------
% primal active set detection
parforTmpVar_j.loc.inact    = logical([false(nngi,1); ...
    full(sProbCas_j.locFuns_hhi(parforTmpVar_j.loc.xx) < opts.actMargin)]);
parforTmpVar_j.loc.KKapp(parforTmpVar_j.loc.inact) = 0;


%------------------------------------------------------------------------
% dynamically changing \Sigma?
if strcmp(opts.Sig,'dyn')
    % after second iteration
    if iter.i > 1
        [parforTmpVar_j.opts_SSig, parforTmpVar_j.loc.locStep] = computeDynSig(opts.SSig{j},...
            iter.yy{j} - parforTmpVar_j.loc.xx, iter.loc.locStep{j}, 'Sig');
    else
        parforTmpVar_j.loc.locStep = iter.yy{j} - parforTmpVar_j.loc.xx;
    end
end



% 
% 
% =======
%     % evaluate sensitivities locally
%     tic
%     % gradient of the objective
%     loc.sensEval.ggiEval{j} = sProb.sens.gg{j}(loc.xx{j});
%     
%     % Hessian approximations
%     if strcmp(opts.Hess, 'BFGS') || strcmp(opts.Hess, 'DBFGS')
%         loc.sensEval.gLiEval{j}   = sProb.sens.gL{j}(loc.xx{j},loc.KKapp{j});
%         if ~isfield(iter.loc, 'sensEval')
%             if strcmp(opts.BFGSinit, 'ident')
%                 % initialize BFGS with identity matrix
%                 loc.sensEval.HHiEval{j}   = eye(length(sProb.zz0{j}));
%             elseif strcmp(opts.BFGSinit, 'exact')
%                 % initialize BFGS with exact Hessian
%                 loc.sensEval.HHiEval{j}   =  ...
%                     sProb.sens.HH{j}(loc.xx{j},loc.KKapp{j},iter.stepSizes.rho);
%             end
%         else
%             loc.sensEval.HHiEval{j}   = BFGS(iter.loc.sensEval.HHiEval{j},...
%                                              loc.sensEval.gLiEval{j},...
%                                              iter.loc.sensEval.gLiEvalOld{j},...
%                                              loc.xx{j},...
%                                              iter.loc.xxOld{j},...
%                                              opts.Hess);
%         end
%         if strcmp(opts.commCount, 'true') && ~strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none')
%             % communication for xx and the gradient of the Lagrangian and
%             % the objective
%             iter.comm.globF.Hess{j}    = [ iter.comm.globF.Hess{j} length(iter.loc.xx{j}) ];
%             iter.comm.globF.grad{j}    = [ iter.comm.globF.grad{j} length(iter.loc.xx{j}) ];
%             iter.comm.globF.primVal{j} = [ iter.comm.globF.primVal{j} length(iter.loc.xx{j}) ];
%         end
%     else
%         loc.sensEval.HHiEval{j}   = sProb.sens.HH{j}(loc.xx{j},loc.KKapp{j},iter.stepSizes.rho);
%         if strcmp(opts.commCount, 'true') && ~strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none')
%             % communication for xx and the gradient of the Lagrangian and
%             % the objective
%             iter.comm.globF.Hess{j}    = [ iter.comm.globF.Hess{j} length(iter.loc.xx{j})*(length(iter.loc.xx{j}) + 1)/2 ];
%             iter.comm.globF.grad{j}    = [ iter.comm.globF.grad{j} length(iter.loc.xx{j}) ];
%             iter.comm.globF.primVal{j} = [ iter.comm.globF.primVal{j} length(iter.loc.xx{j}) ];
%         end
%     end 
% 
%     % Jacobians of active nonlinear constraints/bounds
%     JacCon           = full(sProb.sens.JJac{j}(loc.xx{j}));    
%     JacBounds        = eye(size(loc.xx{j},1));
% 
%     % eliminate inactive entries  
%     JJacCon{j}       = sparse(JacCon(~loc.inact{j},:));      
%     JacBounds        = JacBounds((sProb.llbx{j} - loc.xx{j})  ...
%            > opts.actMargin |(loc.xx{j}-sProb.uubx{j}) > opts.actMargin,:);
%     loc.sensEval.JJacCon{j} = [JJacCon{j}; JacBounds];     
%     timers.sensEvalT        = timers.sensEvalT + toc;
%     
%     % for reduced-space method, compute reduced QP
%     if strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none')
% 
%         loc.sensEval.ZZ{j}    = null(full(JJacCon{j}));
%         loc.sensEval.HHred{j} = loc.sensEval.ZZ{j}'* ...
%                           full(loc.sensEval.HHiEval{j})*loc.sensEval.ZZ{j};
% >>>>>>> origin/Ruchuan
% 


% evaluate sensitivities locally
% -----------------------------------------------------------------------
tic
% gradient of the objective
parforTmpVar_j.loc.sensEval.ggiEval = sProbCas_j.sens_gg(parforTmpVar_j.loc.xx);

% Hessian approximations
if strcmp(opts.Hess, 'BFGS') || strcmp(opts.Hess, 'DBFGS')
    parforTmpVar_j.loc.sensEval.gLiEval   = sProbCas_j.sens_gL(parforTmpVar_j.loc.xx, parforTmpVar_j.loc.KKapp);
    if ~isfield(iter.loc, 'sensEval')
        if strcmp(opts.BFGSinit, 'ident')
            % initialize BFGS with identity matrix
            parforTmpVar_j.loc.sensEval.HHiEval = eye(length(sProbValues.zz0{j}));
        elseif strcmp(opts.BFGSinit, 'exact')
            % initialize BFGS with exact Hessian
            parforTmpVar_j.loc.sensEval.HHiEval    =  ...
                sProbCas_j.sens_HH(parforTmpVar_j.loc.xx, parforTmpVar_j.loc.KKapp, iter.stepSizes.rho);
        end
    else
        parforTmpVar_j.loc.sensEval.HHiEval   = BFGS(iter.loc.sensEval.HHiEval{j},...
            parforTmpVar_j.loc.sensEval.gLiEval,...
            iter.loc.sensEval.gLiEvalOld{j},...
            parforTmpVar_j.loc.xx,...
            iter.loc.xxOld{j},...
            opts.Hess);
    end
    if strcmp(opts.commCount, 'true') && ~strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none')
        % communication for xx and the gradient of the Lagrangian and
        % the objective
        parforTmpVar_j.comm.globF.Hess    = [ parforTmpVar_j.comm.globF.Hess length(iter.loc.xx{j}) ];
        parforTmpVar_j.comm.globF.grad    = [ parforTmpVar_j.comm.globF.grad length(iter.loc.xx{j}) ];
        parforTmpVar_j.comm.globF.primVal = [ parforTmpVar_j.comm.globF.primVal length(iter.loc.xx{j}) ];
    end
else
    parforTmpVar_j.loc.sensEval.HHiEval   = sProbCas_j.sens_HH(parforTmpVar_j.loc.xx, parforTmpVar_j.loc.KKapp,iter.stepSizes.rho);
    
    if strcmp(opts.commCount, 'true') && ~strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none')
        % communication for xx and the gradient of the Lagrangian and
        % the objective
        parforTmpVar_j.comm.globF.Hess    = [ parforTmpVar_j.comm.globF.Hess length(iter.loc.xx{j})*(length(iter.loc.xx{j}) + 1)/2 ];
        parforTmpVar_j.comm.globF.grad    = [ parforTmpVar_j.comm.globF.grad length(iter.loc.xx{j}) ];
        parforTmpVar_j.comm.globF.primVal = [ parforTmpVar_j.comm.globF.primVal length(iter.loc.xx{j}) ];
    end
end

% Jacobians of active nonlinear constraints/bounds
JacCon           = full(sProbCas_j.sens_JJac(parforTmpVar_j.loc.xx));
JacBounds        = eye(size(parforTmpVar_j.loc.xx,1));

% eliminate inactive entries
JJacCon       = sparse(JacCon(~parforTmpVar_j.loc.inact,:));
JacBounds        = JacBounds((sProbValues.llbx{j} - parforTmpVar_j.loc.xx)  ...
    > opts.actMargin |(parforTmpVar_j.loc.xx-sProbValues.uubx{j}) > opts.actMargin,:);
parforTmpVar_j.loc.sensEval.JJacCon = [JJacCon; JacBounds];
parforTmpVar_j.timers.sensEvalT = toc;

% for reduced-space method, compute reduced QP
if strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none')
    
    parforTmpVar_j.loc.sensEval.ZZ    = null(full(JJacCon));
    parforTmpVar_j.loc.sensEval.HHred = parforTmpVar_j.loc.sensEval.ZZ'* ...
        full(parforTmpVar_j.loc.sensEval.HHiEval)* ...
        parforTmpVar_j.loc.sensEval.ZZ;
    
    parforTmpVar_j.loc.sensEval.AAred = sProbValues.AA{j}*parforTmpVar_j.loc.sensEval.ZZ;
    parforTmpVar_j.loc.sensEval.ggred = parforTmpVar_j.loc.sensEval.ZZ'*full(parforTmpVar_j.loc.sensEval.ggiEval);
    
    % regularize reduced Hessian
    tic
    if strcmp(opts.reg,'true')
        parforTmpVar_j.loc.sensEval.HHred  = regularizeH(parforTmpVar_j.loc.sensEval.HHred, opts);
    end
    parforTmpVar_j.timers.RegTotTime = toc;
    
    if strcmp(opts.commCount, 'true') && strcmp(opts.innerAlg, 'none')
        % number of floats for the reduce-space method (no sparsity ex.)
        sH = size(parforTmpVar_j.loc.sensEval.HHred);
        sA = size(parforTmpVar_j.loc.sensEval.AAred);
        parforTmpVar_j.comm.globF.AAred   = [ iter.comm.globF.AAred{j} sA(1)*sA(2) ];
        parforTmpVar_j.comm.globF.Hess    = [ iter.comm.globF.Hess{j} sH(1)*(sH(1) + 1)/2 ];
        parforTmpVar_j.comm.globF.grad    = [ iter.comm.globF.grad{j} sH(1) ];
        parforTmpVar_j.comm.globF.Jac     = [ iter.comm.globF.Jac{j} 0 ];
        % reduced primal values
        parforTmpVar_j.comm.globF.primVal = [ iter.comm.globF.primVal{j} sH(1) ];
    end
else
    % regularization full Hessian
    tic
    if strcmp(opts.reg,'true')
        parforTmpVar_j.loc.sensEval.HHiEval = ...
            regularizeH(parforTmpVar_j.loc.sensEval.HHiEval,opts);
    end
    parforTmpVar_j.timers.RegTotTime =  toc;
    
    if strcmp(opts.commCount, 'true') && strcmp(opts.innerAlg, 'none')
        % number of floats in the Jacobian of the active constraints
        sJ = size(parforTmpVar_j.loc.sensEval.JJacCon);
        parforTmpVar_j.comm.globF.Jac = [ iter.comm.globF.Jac{j} sJ(1)*sJ(2) ];
    end
end
end


