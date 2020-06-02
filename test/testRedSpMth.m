% reset envoronment variables for running the tests
clear all;
import casadi.*

%% test reduced-space method for OPF 118 bus
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



% run ALADIN-M with full space             
opts.slack = 'standard';
res_ALADIN = run_ALADIN(sProb, opts);

% run ALADIN-M with reduced space             
opts.slack    = 'redSpace';
res_ALADINred = run_ALADIN(sProb, opts);

% compare solutions
assert(norm(vertcat(res_ALADIN.xxOpt{:}) - vertcat(res_ALADINred.xxOpt{:}),inf) ...
                           < 1e-6, 'Out of tolerance for local minimizer!')
    
% centralized solution
res_IPOPT  = run_IPOPT(sProb);

% check whether primal solution is close enough to centralized one
assert(norm(full(res_IPOPT.x)-vertcat(res_ALADINred.xxOpt{:}),inf) ...
                           < 1e-6, 'Out of tolerance for local minimizer!')
    

% %% test reduced-space method  with chemical reactor
% load('./problem_data/chemReact.mat')
% opts.Hess = 'standard';
% 
% % run ALADIN-M with reduced space             
% chem.lam0 = 0.1*ones(length(chem.lam0),1);
% opts.slack    = 'redSpace';
% 
% res_ALADINred = run_ALADIN(chem, opts);
% 
% % run ALADIN-M with full space             
% opts.slack = 'standard';
% res_ALADIN = run_ALADIN(chem, opts);
% 
% % compare solutions
% assert(norm(vertcat(res_ALADIN.xxOpt{:}) - vertcat(res_ALADINred.xxOpt{:}),inf) ...
%                            < 1e-6, 'Out of tolerance for local minimizer!')
%     
% % centralized solution
% res_IPOPT  = run_IPOPT(chem);
% 
% % check whether primal solution is close enough to centralized one
% assert(norm(full(res_IPOPT.x)-vertcat(res_ALADINred.xxOpt{:}),inf) ...
%                            < 1e-6, 'Out of tolerance for local minimizer!')
%     
