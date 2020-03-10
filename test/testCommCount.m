% test communication count for all ALADIN variants
clear all
clc
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


opts.commCount    = 'true';

%% standard ALADIN
opts.innerAlg     = 'none';
opts.slack        = 'standard'; 
opts.Hess         = 'standard';       
res_ALADINs       = run_ALADINnew(sProb, opts);

%% BFGS
opts.Hess         = 'DBFGS';   % damped BFGS       
opts.slack        = 'standard'; 
opts.BFGSinit     = 'exact';   % with exact Hessian initialization
res_ALADINbf      = run_ALADINnew(sProb, opts);

%% reduced-space method
opts.slack        = 'redSpace'; 
opts.Hess         = 'standard';    
res_ALADINred     = run_ALADINnew(sProb, opts);

%% bi-level ALADIN with D-CG
opts.innerAlg     = 'D-CG';
opts.innerIter    = 50;
opts.Hess         = 'standard';
opts.slack        = 'standard'; 
res_ALADINcg      = run_ALADINnew(sProb, opts);

%% bi-level ALADIN with D-ADMM
opts.innerAlg     = 'D-ADMM';
opts.innerIter    = 130;
opts.Hess         = 'standard';
opts.slack        = 'standard'; 
res_ALADINadm     = run_ALADINnew(sProb, opts);



    
