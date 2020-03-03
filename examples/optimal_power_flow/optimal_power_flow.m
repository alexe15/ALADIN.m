% An Optimal Power Flow problem for the IEEE118-bus test system. The 
% problem formulation is from 
%
% Engelmann, A., Jiang, Y., Mühlpfordt, T., Houska, B., & Faulwasser, T. 
% (2018). Toward distributed OPF using ALADIN. IEEE Transactions on Power
% Systems, 34(1), 584-594.
% 
% The problem data is from the MATPOWER test set. Note that we did some
% minor modification mainly affecting line limits, shunts and the number of
% generators at buses. 

import casadi.*
load('IEEE118busPrbFrm.mat')

% bring into the correct foormat
sProb.locFuns.ffi = ffifun;
sProb.locFuns.ggi = ggifun;
sProb.locFuns.hhi = hhifun;
sProb.AA          = dOPF.AA;
sProb.zz0         = dOPF.xx0;
sProb.lam0        = 0.01*ones(Ncons,1); 
sProb.llbx        = dOPF.lbx;
sProb.uubx        = dOPF.ubx;

opts.SSig         = dOPF.Sig;
opts.plot         = 'true';
opts.innerAlg     = 'none';
opts.maxiter      = 30;

                                
% run ALADIN-M                           
res_ALADIN = run_ALADINnew(sProb, opts);

%% compare to centralized solution
res_IPOPT  = run_IPOPT(sProb);

fprintf(['\n\nError in primal variables (inf-norm):' ...
        num2str(norm(vertcat(res_ALADIN.xxOpt{:}) - res_IPOPT.x,inf)) '\n'])



