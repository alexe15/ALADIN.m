function [ timers, opts, iter ] = parallelStepDecentral( sProb, iter, timers, opts )
%PARALLELSTEP Summary of this function goes here
NsubSys = length(sProb.AA);


% untangle sProb into sProbScalars and sProbCasadiFunctions
[sProbCas, sProbValues, parforTmpVar] = getParforVars(sProb, iter, opts);


% solve local problems
for j=1:NsubSys % parfor???
  %  nparngi{j} = size(sProb.locFunsCas.ggi{j},1);
  %  nnhi{j} = size(sProb.locFunsCas.hhi{j},1);
  
  gi = sProbCas(j).locFunsCas_ggi;
  nngi = size(gi,1);
  
    % set up parameter vector for local NLP's
    if ~isfield(sProbValues, 'p')
        pNum = [ iter.stepSizes.rho;
                 iter.lam;
                 iter.yy{j}];
    else
        pNum = [ iter.stepSizes.rho;
                 iter.lam;
                 iter.yy{j};
                 sProbValues.p];
    end

    
    % solve local NLP's
   tic
   %sol = sProb.nnlp{j}('x0' ,    iter.yy{j},... this should be correct
   %but is not working for BFGS example
   sol = sProbCas(j).nnlp('x0' ,    iter.yy{j},...
                       'lam_g0', iter.KKapp{j},...
                       'lam_x0', iter.LLam_x{j},...
                       'p',      [pNum; opts.SSig{j}(:)],...
                       'lbx',    sProbValues.llbx{j},...
                       'ubx',    sProbValues.uubx{j},...
                       'lbg',    sProbValues.gBounds.llb{j}, ...
                       'ubg',    sProbValues.gBounds.uub{j});     


   % collect variables 
   [ parforTmpVar(j).loc.xx, parforTmpVar(j).loc.KKapp, parforTmpVar(j).loc.LLam_x ] = deal(full(sol.x), ...
                                         full(sol.lam_g), full(sol.lam_x));
%    timers.NLPtotTime = timers.NLPtotTime + toc;
   parforTmpVar(j).timers.NLPtotTime = toc;

 
   % primal active set detection
   parforTmpVar(j).loc.inact    = logical([false(nngi,1); ...
                      full(sProbCas(j).locFuns_hhi(parforTmpVar(j).loc.xx) < opts.actMargin)]);
   parforTmpVar(j).loc.KKapp(parforTmpVar(j).loc.inact) = 0;

    
  
    % dynamically changing \Sigma?
     if strcmp(opts.Sig,'dyn')
        % after second iteration 
        if iter.i > 1 
            [parforTmpVar(j).opts_SSig, parforTmpVar(j).loc.locStep] = computeDynSig(opts.SSig{j},...
                               iter.yy{j} - parforTmpVar(j).loc.xx, iter.loc.locStep{j}, 'Sig');
        else
            parforTmpVar(j).loc.locStep = iter.yy{j} - parforTmpVar(j).loc.xx;
        end
    end

    % evaluate sensitivities locally
    tic
    % gradient of the objective
     parforTmpVar(j).loc.sensEval.ggiEval = sProbCas(j).sens_gg(parforTmpVar(j).loc.xx);
    
    % Hessian approximations
    if strcmp(opts.Hess, 'BFGS') || strcmp(opts.Hess, 'DBFGS')
        parforTmpVar(j).loc.sensEval.gLiEval   = sProbCas(j).sens_gL(parforTmpVar(j).loc.xx, parforTmpVar(j).loc.KKapp);
        if ~isfield(iter.loc, 'sensEval')
            if strcmp(opts.BFGSinit, 'ident')
                % initialize BFGS with identity matrix
                parforTmpVar(j).loc.sensEval.HHiEval = eye(length(sProbValues.zz0{j}));
            elseif strcmp(opts.BFGSinit, 'exact')
                % initialize BFGS with exact Hessian
                parforTmpVar(j).loc.sensEval.HHiEval    =  ...
                sProbCas(j).sens_HH(parforTmpVar(j).loc.xx, parforTmpVar(j).loc.KKapp, iter.stepSizes.rho);
            end
        else
            % test these lines for second iteration
            parforTmpVar(j).loc.sensEval.HHiEval   = BFGS(iter.loc.sensEval.HHiEval{j},...
                                                    parforTmpVar(j).loc.sensEval.gLiEval,...
                                                    iter.loc.sensEval.gLiEvalOld{j},...
                                                    parforTmpVar(j).loc.xx,...
                                                    iter.loc.xxOld{j},...
                                                    opts.Hess);
        end
        if strcmp(opts.commCount, 'true') && ~strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none')
            % communication for xx and the gradient of the Lagrangian and
            % the objective
            parforTmpVar(j).comm.globF.Hess    = [ parforTmpVar(j).comm.globF.Hess length(iter.loc.xx{j}) ];
            parforTmpVar(j).comm.globF.grad    = [ parforTmpVar(j).comm.globF.grad length(iter.loc.xx{j}) ];
            parforTmpVar(j).comm.globF.primVal = [ parforTmpVar(j).comm.globF.primVal length(iter.loc.xx{j}) ];
        end
    else
        parforTmpVar(j).loc.sensEval.HHiEval   = sProbCas(j).sens_HH(parforTmpVar(j).loc.xx, parforTmpVar(j).loc.KKapp,iter.stepSizes.rho);
        
        if strcmp(opts.commCount, 'true') && ~strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none')
            % communication for xx and the gradient of the Lagrangian and
            % the objective
            parforTmpVar(j).comm.globF.Hess    = [ parforTmpVar(j).comm.globF.Hess length(iter.loc.xx{j})*(length(iter.loc.xx{j}) + 1)/2 ];
            parforTmpVar(j).comm.globF.grad    = [ parforTmpVar(j).comm.globF.grad length(iter.loc.xx{j}) ];
            parforTmpVar(j).comm.globF.primVal = [ parforTmpVar(j).comm.globF.primVal length(iter.loc.xx{j}) ];
        end
    end 

    % Jacobians of active nonlinear constraints/bounds
    JacCon           = full(sProbCas(j).sens_JJac(parforTmpVar(j).loc.xx));    
    JacBounds        = eye(size(parforTmpVar(j).loc.xx,1));

    % eliminate inactive entries 
    JJacCon       = sparse(JacCon(~parforTmpVar(j).loc.inact,:));      
    JacBounds        = JacBounds((sProbValues.llbx{j} - parforTmpVar(j).loc.xx)  ...
           > opts.actMargin |(parforTmpVar(j).loc.xx-sProbValues.uubx{j}) > opts.actMargin,:);
    parforTmpVar(j).loc.sensEval.JJacCon = [JJacCon; JacBounds];
    parforTmpVar(j).timers.sensEvalT = toc;

    % for reduced-space method, compute reduced QP
    if strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none')

        parforTmpVar(j).loc.sensEval.ZZ    = null(full(JJacCon));
        parforTmpVar(j).loc.sensEval.HHred = parforTmpVar(j).loc.sensEval.ZZ'* ...
                          full(parforTmpVar(j).loc.sensEval.HHiEval)* ...
                            parforTmpVar(j).loc.sensEval.ZZ;
        
        parforTmpVar(j).loc.sensEval.AAred = sProbValues.AA{j}*parforTmpVar(j).loc.sensEval.ZZ;
        parforTmpVar(j).loc.sensEval.ggred = parforTmpVar(j).loc.sensEval.ZZ'*full(parforTmpVar(j).loc.sensEval.ggiEval);

        % regularize reduced Hessian
        tic
        if strcmp(opts.reg,'true')
            parforTmpVar(j).loc.sensEval.HHred  = regularizeH(parforTmpVar(j).loc.sensEval.HHred, opts);
        end
        parforTmpVar(j).timers.RegTotTime = toc;    
        
        if strcmp(opts.commCount, 'true') && strcmp(opts.innerAlg, 'none')
           % number of floats for the reduce-space method (no sparsity ex.)
           sH = size(parforTmpVar(j).loc.sensEval.HHred);
           sA = size(parforTmpVar(j).loc.sensEval.AAred);
           parforTmpVar(j).comm.globF.AAred   = [ iter.comm.globF.AAred{j} sA(1)*sA(2) ];
           parforTmpVar(j).comm.globF.Hess    = [ iter.comm.globF.Hess{j} sH(1)*(sH(1) + 1)/2 ];
           parforTmpVar(j).comm.globF.grad    = [ iter.comm.globF.grad{j} sH(1) ];
           parforTmpVar(j).comm.globF.Jac     = [ iter.comm.globF.Jac{j} 0 ];
           % reduced primal values
           parforTmpVar(j).comm.globF.primVal = [ iter.comm.globF.primVal{j} sH(1) ];
        end
    else
        % regularization full Hessian
        tic
        if strcmp(opts.reg,'true')
            parforTmpVar(j).loc.sensEval.HHiEval = ...
                                 regularizeH(parforTmpVar(j).loc.sensEval.HHiEval,opts);
        end
        parforTmpVar(j).timers.RegTotTime =  toc;
        
        if strcmp(opts.commCount, 'true') && strcmp(opts.innerAlg, 'none')
           % number of floats in the Jacobian of the active constraints
            sJ = size(parforTmpVar(j).loc.sensEval.JJacCon);
           parforTmpVar(j).comm.globF.Jac = [ iter.comm.globF.Jac{j} sJ(1)*sJ(2) ];
        end
    end
end 


% hand over parfor variables
loc = iter.loc;
[loc, timers, opts ] = parforVars2globalVars(parforTmpVar, loc, iter, opts, NsubSys, timers);

% save information for next BFGS iteration
if strcmp(opts.Hess, 'BFGS') || strcmp(opts.Hess, 'DBFGS')
    loc.sensEval.gLiEvalOld = loc.sensEval.gLiEval;
    loc.xxOld               = loc.xx;
end

iter.loc = loc;
 
end