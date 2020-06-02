
%% test ADMM     
% test BFGS for OPF 30 bus
load('./problem_data/IEEE30busPrbFrm.mat')


% bring into the correct foormat
sProb.locFuns.ffi = ffifun;
sProb.locFuns.ggi = ggifun;
sProb.locFuns.hhi = hhifun;
sProb.AA          = dOPF.AA;
sProb.zz0         = dOPF.xx0;
sProb.lam0        = 0.01*ones(Ncons,1); 
sProb.llbx        = dOPF.lbx;
sProb.uubx        = dOPF.ubx;

% solve with ADMM
optsADM    = struct('rho0',1e4,'scaling','false','rhoUpdate','false','maxiter',400,'plot','false');
sol_ADMM   = run_ADMM(sProb, optsADM);

% centralized solution
res_IPOPT  = run_IPOPT(sProb);

% check whether primal solution is close enough to centralized one
assert(norm(vertcat(sol_ADMM.xxOpt{:}) - res_IPOPT.x,inf) < 1e-2, 'Out of tolerance for local minimizer!')
    
% semilogy(vecnorm([sProb.AA{:}]*sol_ADMM.logg.X))
