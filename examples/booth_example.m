clear all;
close all;

N   = 2;
n   = 2;

%% first set up the problem with parameter
%   define booth function
np  = 3; % number of parameters
y1  = sym('y1', [n 1], 'real');
y2  = sym('y2', [n 1], 'real');
par = sym('par', [np 1], 'real');

% define objective function with parameter
f1 = (y1(1) + par(1)*y1(2) - 7)^2;
f2 = (par(2)*y2(1) + y2(2) - 5)^2;

% define inequality function with parameter
h1 = y1(1) + y1(2) - par(3);

A1 = eye(n);
A2 = -eye(n);

lb1 = [-inf; -inf];
lb2 = [-inf; -inf];

ub1 = [inf; inf];
ub2 = [inf; inf];

%% convert symbolic variables to MATLAB fuctions
emptyfun = @(x,y) [];
f1f      = matlabFunction(f1,'Vars',{y1,[par(1);par(3)]});
f2f      = matlabFunction(f2,'Vars',{y2,par(2)});
h1f      = matlabFunction(h1,'Vars',{y1,[par(1);par(3)]});
h2f      = emptyfun;
g1f      = emptyfun;
g2f      = emptyfun;

%% solve with ALADIN
sProb.locFuns.ffi = {f1f, f2f};
sProb.locFuns.hhi = {h1f, h2f};
sProb.locFuns.ggi = {g1f, g2f};
sProb.llbx = {lb1, lb2};
sProb.uubx = {ub1, ub2};
sProb.AA = {A1, A2};
sProb.zz0 = {zeros(n,1), zeros(n,1)};
sProb.lam0 = 10*(rand(1)-0.5)*ones(size(A1,1),1);
sProb.p = {[2;3],2};


%% initialie
opts.maxiter = 30;

sol_par = run_ALADIN(sProb, opts);

%% then set up same problem without parameter
f1 = (y1(1) + 2*y1(2) - 7)^2;
f2 = (2*y2(1) + y2(2) - 5)^2;
h1 = y1(1) + y1(2) - 3;

emptyfun = @(x) [];
f1f      = matlabFunction(f1,'Vars',{y1});
f2f      = matlabFunction(f2,'Vars',{y2});
h1f      = matlabFunction(h1,'Vars',{y1});
h2f      = emptyfun;

sProb.locFuns.ffi = {f1f, f2f};
sProb.locFuns.hhi = {h1f, h2f};
sProb = rmfield(sProb, 'p');

sol_normal = run_ALADIN(sProb, opts);