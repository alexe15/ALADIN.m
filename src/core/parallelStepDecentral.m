function [ loc, timers, opts ] = parallelStepDecentral( sProb, iter, timers, opts )
%DECENTRALIZEDPARALLELSTEP Summary of this function goes here
NsubSys = length(sProb.AA);
loc     = iter.loc;

% initialize space and parfor compatilbe datatype
loc_temp = cell2struct(cell(5, NsubSys), {'xx', 'KKapp', 'LLam_x', 'inact', 'sensEval'}, 1);
timers_temp = cell2struct(cell(3, NsubSys), {'NLPtotTime', 'sensEvalT', 'RegToTTime'}, 1);
% copy sProb.nnlp to local cell to increase performance
loc_nnlp = sProb.nnlp;
xxTmp = iter.loc.xx;

% make local copies of functions s.th no casadi function or variables is 
% accessed from cell -> struct are ok

locFunsCas_temp = cell2struct(cell(1, NsubSys), {'ggi'}, 1);
locFuns_temp = cell2struct(cell(1, NsubSys), {'hhi'}, 1);
sens_temp = cell2struct(cell(4, NsubSys), {'gg', 'gL', 'HH', 'JJac'}, 1);
for j = 1 : NsubSys
    locFunsCas_temp(j).ggi = sProb.locFunsCas.ggi{j};
    locFuns_temp(j).hhi = sProb.locFuns.hhi{j};
    sens_temp(j).gg = sProb.sens.gg{j};
    sens_temp(j).HH = sProb.sens.HH{j};
    sens_temp(j).JJac = sProb.sens.JJac{j};
end

if strcmp(opts.Hess, 'BFGS') || strcmp(opts.Hess, 'DBFGS')
    for j = 1 : NsubSys
        sens_temp(j).gL = sProb.sens.gL{j}; 
    end
end
rho_temp = iter.stepSizes.rho;
             
sProb_local.llbx = sProb.llbx;
sProb_local.uubx = sProb.uubx;
sProb_local.gBounds.llb = sProb.gBounds.llb;
sProb_local.gBounds.uub = sProb.gBounds.uub;
sProb_local.zz0 = sProb.zz0;
sProb_local.AA = sProb.AA;

if isfield(sProb, 'p')
    sProb_local.p = sProb.p;
end

SSig = cell(1, NsubSys);
SSig = opts.SSig;


time_parfor = tic;

% solve local problems
parfor j=1:NsubSys % parfor???
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
                
    
                    
    % collect variables  
    [ loc_temp(j).xx, KKapp_j, loc_temp(j).LLam_x ] = deal(full(sol.x), ...
                                         full(sol.lam_g), full(sol.lam_x));
    
    loc_temp(j).KKapp = KKapp_j;                                 

    timers_temp(j).NLPtotTime = toc;
    
    hi = locFuns_temp(j).hhi; 

     % primal active set detection
     loc_temp(j).inact    = logical([false(nngi,1); ...
                       full(hi(loc_temp(j).xx) < opts.actMargin)]);
     KKapp{j}(loc_temp(j).inact) = 0;


    % dynamically changing \Sigma?
     if strcmp(opts.Sig,'dyn')
          % after second iteration 
          if size(iter.logg.X,2) > 2 
              [SSig(j), loc_temp(j).locStep] = computeDynSig(opts.SSig{j},...
                                 iter.yy{j}, loc_temp(j).xx,iter.loc.locStep{j}, 'Sig');
          else
              loc_temp(j).locStep = iter.yy{j} - loc_temp(j).xx;
          end
     end


  
    % evaluate gradients and Hessians of the local problems
    gg = sens_temp(j).gg;
    tic

    loc_temp(j).sensEval.ggiEval = gg(loc_temp(j).xx);
     
    if strcmp(opts.Hess, 'BFGS') || strcmp(opts.Hess, 'DBFGS')
        gL = sens_temp(j).gL;
        loc_temp(j).sensEval.gLiEval   = gL(loc_temp(j).xx,loc_temp(j).KKapp);
          if ~isfield(iter.loc, 'sensEval')
             if strcmp(opts.BFGSinit, 'ident')
                  % initialize BFGS with identity matrix
                 loc_temp(j).sensEval.HHiEval   = eye(length(sProb_local.zz0{j}));
             elseif strcmp(opts.BFGSinit, 'exact')
                 % initialize BFGS with exact Hessian
                 HH = sens_temp(j).HH;
                 loc_temp(j).sensEval.HHiEval   =  ...
                     HH(loc.xx{j},loc.KKapp{j},iter.stepSizes.rho);
             end
          else
              loc_temp(j).sensEval.HHiEval   = BFGS(iter.loc.sensEval.HHiEval{j},...
                                               loc_temp(j).sensEval.gLiEval,...
                                               iter.loc.sensEval.gLiEvalOld{j},...
                                               loc_temp(j).xx,...
                                               iter.loc.xxOld{j},...
                                               opts.Hess);
          end
      else
          HH = sens_temp(j).HH;
          xx = loc_temp(j).xx;
         loc_temp(j).sensEval.HHiEval   = HH(xx,loc_temp(j).KKapp,rho_temp);
     end

    % Jacobians of active nonlinear constraints/bounds
    JacCon           = full(sens_temp(j).JJac(loc_temp(j).xx));    
    JacBounds        = eye(size(loc_temp(j).xx,1));
 
%     % eliminate inactive entries  
     JJacCon{j}       = sparse(JacCon(~loc_temp(j).inact,:));      
     JacBounds        = JacBounds((sProb_local.llbx{j} - loc_temp(j).xx)  ...
            > opts.actMargin |(loc_temp(j).xx-sProb_local.uubx{j}) > opts.actMargin,:);
     loc_temp(j).sensEval.JJacCon      = [JJacCon{j}; JacBounds];     
     
     timers_temp(j).sensEvalT = toc;
     
   
     % for reduced-space method, compute reduced QP
     if strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none')

         loc_temp(j).sensEval.ZZ    = null(full(JJacCon{j}));
         loc_temp(j).sensEval.HHred = loc_temp(j).sensEval.ZZ'* ...
                           full(loc_temp(j).sensEval.HHiEval)*loc_temp(j).sensEval.ZZ;
         loc_temp(j).sensEval.AAred = sProb_local.AA{j}*loc_temp(j).sensEval.ZZ;
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
toc(time_parfor)

% copy local parfor data into global data
parforVars2globalVars;


% save information for next BFGS iteration
if strcmp(opts.Hess, 'BFGS') || strcmp(opts.Hess, 'DBFGS')
    loc.sensEval.gLiEvalOld = loc.sensEval.gLiEval;
    loc.xxOld               = loc.xx;
end

end