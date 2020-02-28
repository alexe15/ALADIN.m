clear all
clc

%% define problem in partially separable form
% objective functions
f1 = @(x) 2 * ( x(1) - 1)^2;
f2 = @(y) (y(2) - 2)^2;

% local nonlinear inequality constraints
h1 = @(x) (1 - x(1) * x(2));
h2 = @(y) (-1.5 + y(1) * y(2));

% coupling matrices
A1  =   [ 1,  0;
          0,  1];
A2  =   [-1   0;
          0, -1];
     
% collect variables in sProb struct
sProb.locFuns.ffi  = {f1, f2};
sProb.locFuns.hhi  = {h1, h2};
sProb.AA           = {A1, A2};

% solve with ALADIN-M
sol_ALADIN = run_ALADINnew( sProb ); 