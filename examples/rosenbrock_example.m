addpath('./solver');
clear all;
clc;
import casadi.*
emptyfun      = @(x) [];

%% define Rosenbrock problem [Quelle: Hock-Schittkowski-Collection Problem 1]
N   =   2;
n   =   2;
y1  =   sym('y1',[1,1],'real');
y2  =   sym('y2',[n,1],'real');

f1  =   (1-y1(1))^2;
f2  =   100*(y2(2)-y2(1)^2)^2;

h2  =   -1.5-y2(1);

A1  =   [1];
A2  =   [-1, 0];
b   =   0;

lb1 =   [-inf];
lb2 =   [-inf; -inf];

ub1 =   [inf];
ub2 =   [inf; inf];

%% convert symbolic variables to MATLAB fuctions
f1f     =   matlabFunction(f1,'Vars',{y1});
f2f     =   matlabFunction(f2,'Vars',{y2});

h1f     =   emptyfun;
h2f     =   matlabFunction(h2,'Vars',{y2});

%% set solver options
maxit       =   30;
rho         =   10;
mu          =   100;
eps         =   1e-4;
term_eps    =   0;

%% solve with ALADIN
[ggifun{1:N}]    =   deal(emptyfun);
sProb.locFuns.ffi   =   {f1f,f2f};
sProb.locFuns.hhi   =   {h1f,h2f};
sProb.locFuns.ggi   =   ggifun;
sProb.AA            =   {A1,A2};
sProb.zz0           =   {[-2],[-2;1]};
sProb.lam0          =   10*(rand(1)-0.5);
sProb.llbx          =   {lb1,lb2};
sProb.uubx          =   {ub1,ub2};
Sig                 =   {eye(1),eye(2)};

opts = initializeOpts(rho, mu, maxit, Sig, term_eps);

sol_ALADIN =   run_ALADINnew(sProb,opts);
                                  
%% solve centralized problem with CasADi & IPOPT
y1  =   sym('y1',[1,1],'real');
y2  =   sym('y2',[2,1],'real');
f1fun   =   matlabFunction(f1,'Vars',{y1});
f2fun   =   matlabFunction(f2,'Vars',{y2});
h1fun   =   emptyfun;
h2fun   =   matlabFunction(h2,'Vars',{y2});


% y0  =   ones(N*n,1);
y   =   SX.sym('y',[3,1]);
F   =   f1fun(y(1))+f2fun(y(2:3));
g   =   [h1fun(y(1));
         h2fun(y(2:3));
         [A1, A2]*y];
nlp =   struct('x',y,'f',F,'g',g);
cas =   nlpsol('solver','ipopt',nlp);
sol =   cas('lbx', [lb1; lb2],...
            'ubx', [ub1; ub2],...
            'lbg', [-inf;b], ...
            'ubg', [0;b]);
        
        
% plotting
set(0,'defaulttextInterpreter','latex')
figure(2)
hold on
plot(sol_ALADIN.iter.logg.X')
hold on
plot(maxit,full(sol.x),'ob')
xlabel('$k$');
ylabel('$x^k$');