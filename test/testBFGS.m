% reset envoronment variables for running the tests
clear all;
import casadi.*

%% test BFGS for OPF 30bus
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

opts.SSig         = dOPF.Sig;
opts.plot         = 'true';
opts.innerAlg     = 'none';
opts.maxiter      = 30;

opts.Hess         = 'DBFGS';   % damped BFGS
opts.BFGSinit     = 'exact';   % with exact Hessian initialization

% run ALADIN-M                       
res_ALADIN = run_ALADIN(sProb, opts);

% centralized solution
res_IPOPT  = run_IPOPT(sProb);

% check whether primal solution is close enough to centralized one
assert(norm(vertcat(res_ALADIN.xxOpt{:}) - res_IPOPT.x,inf) < 1e-6, 'Out of tolerance for local minimizer!')
    

%% test BFGS with chemical reactor
load('./problem_data/chemReact.mat')
opts.Hess = 'DBFGS';

% solve with ALADIN
sol_ALADIN = run_ALADIN(chem, opts);

% centralized solution
res_IPOPT  = run_IPOPT(chem);

% check whether primal solution is close enough to centralized one
assert(norm(full(res_IPOPT.x)-vertcat(sol_ALADIN.xxOpt{:}),inf) < 1e-6, 'Out of tolerance for local minimizer!')
    
