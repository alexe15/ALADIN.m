% reset envoronment variables for running the tests
clear all;
import casadi.*

%% test autoscaling for slack penalization 118 bus
load('./problem_data/IEEE118busPrbFrm.mat')


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

% automatically update Delta scaling matrix for slacks
opts.DelUp        = 'true';
opts.Hess         = 'standard';

% run ALADIN-M                       
res_ALADIN = run_ALADIN(sProb, opts);

% centralized solution
res_IPOPT  = run_IPOPT(sProb);

% check whether primal solution is close enough to centralized one
assert(norm(vertcat(res_ALADIN.xxOpt{:}) - res_IPOPT.x,inf) < 1e-6, 'Out of tolerance for local minimizer!')
    
%% test autoscaling for slack penalization chemical reactor
load('./problem_data/chemReact.mat')

% automatically update Delta scaling matrix for slacks
opts.DelUp        = 'true';
opts.Hess         = 'standard';
opts.maxiter      = 20;

% solve with ALADIN
sol_ALADIN = run_ALADIN(chem, opts);

% centralized solution
res_IPOPT  = run_IPOPT(chem);

% check whether primal solution is close enough to centralized one
assert(norm(full(res_IPOPT.x)-vertcat(sol_ALADIN.xxOpt{:}),inf) < 1e-6, 'Out of tolerance for local minimizer!')


%% test autoscaling for \Sigma penalization 118 bus
load('./problem_data/IEEE118busPrbFrm.mat')


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

% automatically update Delta scaling matrix for slacks
opts.DelUp        = 'false';
opts.Sig          = 'dyn';
opts.Hess         = 'standard';

% run ALADIN-M                       
res_ALADIN = run_ALADIN(sProb, opts);

% centralized solution
res_IPOPT  = run_IPOPT(sProb);

% check whether primal solution is close enough to centralized one
assert(norm(vertcat(res_ALADIN.xxOpt{:}) - res_IPOPT.x,inf) < 1e-6, 'Out of tolerance for local minimizer!')
    

%% test autoscaling for \Sigma penalization chemical reactor
load('./problem_data/chemReact.mat')

% automatically update Delta scaling matrix for slacks
opts.DelUp        = 'false';
opts.Sig          = 'const';
opts.Hess         = 'standard';
opts.maxiter      = 50;

% solve with ALADIN
sol_ALADIN = run_ALADIN(chem, opts);

% centralized solution
res_IPOPT  = run_IPOPT(chem);

% check whether primal solution is close enough to centralized one
assert(norm(full(res_IPOPT.x)-vertcat(sol_ALADIN.xxOpt{:}),inf) < 1e-6, 'Out of tolerance for local minimizer!')















    
