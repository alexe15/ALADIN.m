addpath('./solver');
clear all;
clc;
import casadi.*
emptyfun      = @(x) [];

%% define Rastrigin problem (unconstrained) [Quelle: https://en.wikipedia.org/wiki/Test_functions_for_optimization]
N   =   2;
n   =   4;
y1  =   sym('y1',[n,1],'real');
y2  =   sym('y2',[n,1],'real');

f1  =   10*N-10*cos(2*pi*y1(1))-10*cos(2*pi*y1(2))-10*cos(2*pi*y1(3))-10*cos(2*pi*y1(4));
f2  =   y2(1)^2+y2(2)^2+y2(3)^2+y2(4)^2;

A1  =   [ 1,  0,  0,  0;...
          0,  1,  0,  0;...
          0,  0,  1,  0;...
          0,  0,  0,  1];
A2  =   [-1,  0,  0,  0;...
          0, -1,  0,  0;...
          0,  0, -1,  0;...
          0,  0,  0, -1];
b   =   0;

lb1 =   [-5.12; -5.12; -5.12; -5.12];
lb2 =   [-5.12; -5.12; -5.12; -5.12];

ub1 =   [5.12; 5.12; 5.12; 5.12];
ub2 =   [5.12; 5.12; 5.12; 5.12];

%% convert symbolic variables to MATLAB fuctions
f1f     =   matlabFunction(f1,'Vars',{y1});
f2f     =   matlabFunction(f2,'Vars',{y2});

h1f     =   emptyfun;
h2f     =   emptyfun;


%% initalize
maxit   =   15;
y0      =   3*rand(N*n,1);
lam0    =   10*(rand(1)-0.5)*ones(size(A1,1),1);;
rho     =   10;
mu      =   100;
eps     =   1e-4;
Sig     =   {eye(4),eye(4)};

%% solve with ALADIN
AQP           = [A1,A2];
ffifun        = {f1f,f2f};
hhifun        = {h1f,h2f};
[ggifun{1:N}] = deal(emptyfun);

yy0         = {y0(1:4),y0(5:8)};
%xx0        = {[1 1]',[1 1]'};

llbx        = {lb1,lb2};
uubx        = {ub1,ub2};
AA          = {A1,A2};

opts = struct('rho0',rho,'rhoUpdate',1,'rhoMax',5e3,'mu0',mu,'muUpdate',1,...
    'muMax',1e5,'eps',eps,'maxiter',maxit,'actMargin',-1e-6,'hessian','full',...
     'solveQP','MA57','reg','true','locSol','ipopt','innerIter',2400,'innerAlg', ...
     'full','plot',false,'Hess','standard');
 
[xoptAL, loggAL]   = run_ALADIN(ffifun,ggifun,hhifun,AA,yy0,...
                                      lam0,llbx,uubx,Sig,opts);
                                  
%% solve centralized problem with CasADi & IPOPT
y1  =   sym('y1',[n,1],'real');
y2  =   sym('y2',[n,1],'real');
f1fun   =   matlabFunction(f1,'Vars',{y1});
f2fun   =   matlabFunction(f2,'Vars',{y2});
h1fun   =   emptyfun;
h2fun   =   emptyfun;


% y0  =   ones(N*n,1);
y   =   SX.sym('y',[N*n,1]);
F   =   f1fun(y(1:4))+f2fun(y(5:8));
g   =   [h1fun(y(1:4));
         h2fun(y(5:8));
         [A1, A2]*y];
nlp =   struct('x',y,'f',F,'g',g);
cas =   nlpsol('solver','ipopt',nlp);
sol =   cas('lbx', [lb1; lb2],...
            'ubx', [ub1; ub2],...
            'lbg', [-inf;-inf;-inf;b], ...
            'ubg', [0;0;0;b]);  
        
        
% plotting
set(0,'defaulttextInterpreter','latex')
figure(2)
hold on
plot(loggAL.X')
hold on
plot(maxit,full(sol.x),'ob')
xlabel('$k$');
ylabel('$x^k$');