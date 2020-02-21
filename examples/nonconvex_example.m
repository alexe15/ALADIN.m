%% nonconvex example to compare run_ADMM with run_ALADIN

% restoredefaultpath;
clear all;
clc;

% addpath('../src');
% addpath(genpath('../tools/'));
import casadi.*

%% define nonconvex problem
N  = 2;
n  = 2;
m  = 1;
y1 = sym('y1', [n, 1], 'real');
y2 = sym('y2', [n, 1], 'real');

f1 = 2*(y1(1) - 1)^2;
f2 = (y2(2) - 2)^2;

h1 = -20 + (1 - y1(1))^2;
h2 = 1.5*y2(1)^2*y2(2)^2;

A1  =   [1, 0;
         0, 1];
A2  =   [-1,0;
         0, -1];
b   =   [0; 0];

lb1 = [-10, -10];
lb2 = [-10, -10];

ub1 = [10, 10];
ub2 = [10, 10];

%% convert symbolic variables to MATLAB functions
f1f     =  matlabFunction(f1,'Vars',{y1});
f2f     =  matlabFunction(f2,'Vars',{y2});

h1f     =   matlabFunction(h1,'Vars',{y1});
h2f     =   matlabFunction(h2,'Vars',{y2});

%% initilize
maxit   =   30;
y0      =   ones(n*N,1);
lam0    =   10*(rand(1)-0.5)*ones(size(A1,1),1);
rho     =   100;
mu      =   100;
eps     =   1e-4;
Sig     =   {eye(n),eye(n)};

% no termination criterion, stop after maxit
term_eps = 0;

%% solve with ALADIN
emptyfun           = @(x) [];
[ggifun{1:N}]      = deal(emptyfun);
AQP                = [A1,A2];
sProb.locFuns.ffi  = {f1f,f2f};
sProb.locFuns.hhi  = {h1f,h2f};
sProb.locFuns.ggi  = ggifun;

sProb.llbx  = {lb1,lb2};
sProb.uubx  = {ub1,ub2};
sProb.AA    = {A1,A2};

sProb.zz0   = {y0(1:2), y0(3:4)};

sProb.lam0  = lam0;

opts = initializeOpts(rho, mu, maxit, Sig, term_eps);

sol_ALADIN  = run_ALADINnew(sProb,opts);
           
%% solve cantralized problem wih CasADi & IPOPT
y1  =   sym('y1',[n,1],'real');
y2  =   sym('y2',[n,1],'real');
f1fun   =   matlabFunction(f1,'Vars',{y1});
f2fun   =   matlabFunction(f2,'Vars',{y2});
h1fun   =   matlabFunction(h1,'Vars',{y1});
h2fun   =   matlabFunction(h2,'Vars',{y2});


% y0  =   ones(N*n,1);
y   =   SX.sym('y',[N*n,1]);
F   =   f1fun(y(1:2))+f2fun(y(3:4));
g   =   [h1fun(y(1:2));
         h2fun(y(3:4));
         [A1, A2]*y];
nlp =   struct('x',y,'f',F,'g',g);
cas =   nlpsol('solver','ipopt',nlp);
sol =   cas('x0', y0,...
            'lbx', [lb1, lb2],...
            'ubx', [ub1, ub2],...
            'lbg', [-inf;-inf;b], ...
            'ubg', [0;0;b]);  
        
        
% plotting
set(0,'defaulttextInterpreter','latex')
figure(2)
hold on
plot(sol_ALADIN.iter.logg.X')
hold on
plot(maxit,full(sol.x),'ob')
xlabel('$k$');
ylabel('$x^k$');

%% solve with ADMM
 rhoADMM = 1000;
 for i=1:length(sProb.locFuns.ffi) 
     lam0ADMM{i}  = zeros(size(sProb.AA{i},1),1);
 end   
 
 xx0 = {[0 0]', [0 0]'};
 ADMMopts = struct('scaling',false,'rhoUpdate',false,'maxIter',100);
 [xoptADM, loggADM]         = run_ADMM(sProb.locFuns.ffi,...
                                       sProb.locFuns.ggi,...
                                       sProb.locFuns.hhi,...
                                       sProb.AA,...
                                       xx0,...
                                       lam0ADMM,...
                                       sProb.llbx,...
                                       sProb.uubx,...
                                       rhoADMM,...
                                       Sig,...
                                       ADMMopts);             
                                 
% [xoptSQP, loggSQP] = run_SQP(ffifun,ggifun,hhifun,AA,xxgi0,...
%                                       lam0,llbx,uubx,Sig,opts);