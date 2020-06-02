close all
clear all
clc

%% test whether Ax=b is working as consensus constraint
A1  =   [1, 0;
         0, 1];
A2  =   [-1,0;
         0, -1];
b   =   [0; .1];

% define the problem using function handle
f1 = @(x) 2 * ( x(1) - 1)^2;
f2 = @(y) (y(2) - 2)^2;

h1 = @(x) (1 - x(1) * x(2));
h2 = @(y) (-1.5 + y(1) * y(2));

sProb.locFuns.ffi  = {f1, f2};
sProb.locFuns.hhi  = {h1, h2};
sProb.b    = b;
sProb.AA   = {A1,A2};

% solve centralized for reference solution
solC = run_IPOPT(sProb);



%% standard ALADIN
A1  =   [1, 0;
         0, 1];
A2  =   [-1,0;
         0, -1];
b   =   [0; .1];

% define the problem using function handle
f1 = @(x) 2 * ( x(1) - 1)^2;
f2 = @(y) (y(2) - 2)^2;

h1 = @(x) (1 - x(1) * x(2));
h2 = @(y) (-1.5 + y(1) * y(2));

sProb.locFuns.ffi  = {f1, f2};
sProb.locFuns.hhi  = {h1, h2};
sProb.b    = b;
sProb.AA   = {A1,A2};

sol_ALADIN = run_ALADIN( sProb, struct() ); 

% solve centralized for reference solution
solC = run_IPOPT(sProb);

% check result                                  
assert(full(norm(solC.x - vertcat(sol_ALADIN.xxOpt{:}),inf)) < 1e-6, 'Out of tolerance for local minizer!')


%% nullspace ALADIN      
A1  =   [1, 0;
         0, 1];
A2  =   [-1,0;
         0, -1];
b   =   [0; .1];

% define the problem using function handle
f1 = @(x) 2 * ( x(1) - 1)^2;
f2 = @(y) (y(2) - 2)^2;

h1 = @(x) (1 - x(1) * x(2));
h2 = @(y) (-1.5 + y(1) * y(2));

sProb.locFuns.ffi  = {f1, f2};
sProb.locFuns.hhi  = {h1, h2};
sProb.b    = b;
sProb.AA   = {A1,A2};

opts.slack    = 'redSpace';
sol_ALADIN = run_ALADIN( sProb, opts ); 

% solve centralized for reference solution
solC = run_IPOPT(sProb);

% check result                                  
assert(full(norm(solC.x - vertcat(sol_ALADIN.xxOpt{:}),inf)) < 1e-6, 'Out of tolerance for local minizer!')


%% bi-level ALADIN      
A1  =   [1, 0;
         0, 1];
A2  =   [-1,0;
         0, -1];
b   =   [0; .1];

% define the problem using function handle
f1 = @(x) 2 * ( x(1) - 1)^2;
f2 = @(y) (y(2) - 2)^2;

h1 = @(x) (1 - x(1) * x(2));
h2 = @(y) (-1.5 + y(1) * y(2));

sProb.locFuns.ffi  = {f1, f2};
sProb.locFuns.hhi  = {h1, h2};
sProb.b    = b;
sProb.AA   = {A1,A2};

opts.innerAlg     = 'D-CG';
opts.innerIter    = 10;

% run ALADIN-M                       
res_ALADIN = run_ALADIN(sProb, opts);

% solve centralized for reference solution
solC = run_IPOPT(sProb);

% check result                                  
assert(full(norm(solC.x - vertcat(res_ALADIN.xxOpt{:}),inf)) < 1e-6, 'Out of tolerance for local minizer!')



