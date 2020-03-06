% reset envoronment variables for running the tests
clear all;
import casadi.*

%% test bi-level ALADIN 30 bus
load('./problem_data/IEEE30busPrbFrm.mat')


% bring into the correct format
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

% automatically update Delta scaling matrix for slacks
opts.innerAlg     = 'D-CG';
opts.innerIter    = 50;
opts.Hess         = 'standard';

% run ALADIN-M                       
res_ALADIN = run_ALADINnew(sProb, opts);

% centralized solution
res_IPOPT  = run_IPOPT(sProb);

% check whether primal solution is close enough to centralized one
assert(norm(vertcat(res_ALADIN.xxOpt{:}) - res_IPOPT.x,inf) < 1e-6, 'Out of tolerance for local minimizer!')
    

%% test with D-ADMM
load('./problem_data/IEEE30busPrbFrm.mat')


% bring into the correct format
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

% automatically update Delta scaling matrix for slacks
opts.innerAlg     = 'D-ADMM';
opts.innerIter    = 130;
opts.Hess         = 'standard';

% run ALADIN-M                       
res_ALADIN = run_ALADINnew(sProb, opts);

% centralized solution
res_IPOPT  = run_IPOPT(sProb);

% check whether primal solution is close enough to centralized one
assert(norm(vertcat(res_ALADIN.xxOpt{:}) - res_IPOPT.x,inf) < 1e-5, 'Out of tolerance for local minimizer!')
    
