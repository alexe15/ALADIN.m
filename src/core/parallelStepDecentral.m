function [ timers, opts, iter ] = parallelStepDecentral( sProb, iter, timers, opts )
%PARALLELSTEP Summary of this function goes here
NsubSys = length(sProb.AA);


% untangle sProb into sProbScalars and sProbCasadiFunctions
[sProbCas, sProbValues, parforTmpVar] = getParforVars(sProb, iter, opts);


% solve local problems
parfor j=1:NsubSys % parfor???
<<<<<<< HEAD
=======
  gi = locFunsCas_temp(j).ggi; 
  nngi = size(gi, 1);
    % set up parameter vector for local NLP's
   if ~isfield(sProb_local, 'p')
       pNum = [ iter.stepSizes.rho;
                iter.lam;
                iter.yy{j}];
  else
       pNum = [ iter.stepSizes.rho;
                iter.lam;
                iter.yy{j};
                sProb_local.p{j}];
   end

    % solve local NLP's
    tic
    sol = loc_nnlp{j}('x0' ,   xxTmp {j},...
                        'lam_g0', iter.KKapp{j},...
                        'lam_x0', iter.LLam_x{j},...
                        'p',      [pNum; SSig{j}(:)],...
                        'lbx',    sProb_local.llbx{j},...
                        'ubx',    sProb_local.uubx{j},...
                        'lbg',    sProb_local.gBounds.llb{j}, ...
                        'ubg',    sProb_local.gBounds.uub{j});     
                
>>>>>>> origin/Ruchuan
    
    
    parforTmpVar(j) = parallelStepInnerLoop(j, ...
                                            sProbCas(j), ...
                                            sProbValues, ...
                                            iter, ...
                                            parforTmpVar(j), ... 
                                            opts);
                                        
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