addpath('../src');
clear all;
clc;
import casadi.*
emptyfun      = @(x) [];

%% define Mishra's Bird problem (constrained) [Quelle: https://en.wikipedia.org/wiki/Test_functions_for_optimization]
N   =   3;
n   =   2;
y1  =   sym('y1',[n,1],'real');
y2  =   sym('y2',[n,1],'real');
y3  =   sym('y3',[n,1],'real');

f1  =   sin(y1(1)).*exp((1-cos(y1(2))).^2);
f2  =   cos(y2(2)).*exp((1-sin(y2(1))).^2);
f3  =   (y3(1)-y3(2)).^2;

h3  =   (y3(1)+5)^2+(y3(2)+5)^2-25;

A1  =   [ 1,  0;...
          1,  0;...
          0,  1;...
          0,  1];
A2  =   [-1,  0;...
          0,  0;...
          0, -1;...
          0,  0];
A3  =   [ 0,  0;...
         -1,  0;...
          0,  0;...
          0, -1];
b   =   [0;0;0;0];

lb1 =   [-10;-6.5];
lb2 =   [-10;-6.5];
lb3 =   [-10;-6.5];

ub1 =   [0;0];
ub2 =   [0;0];
ub3 =   [0;0];

%% convert symbolic variables to MATLAB fuctions
f1f     =   matlabFunction(f1,'Vars',{y1});
f2f     =   matlabFunction(f2,'Vars',{y2});
f3f     =   matlabFunction(f3,'Vars',{y3});

h1f     =   emptyfun;
h2f     =   emptyfun;
h3f     =   matlabFunction(h3,'Vars',{y3});

%% initalize
maxit       =   20;
y0          =   3*rand(N*n,1);
lam0        =   10*(rand(1)-0.5)*ones(size(A1,1),1);
rho         =   100;
mu          =   1000;
eps         =   1e-4;
term_eps    =   0;
Sig         =   {eye(n),eye(n),eye(n)};

%% solve with ALADIN
AQP           = [A1,A2,A3];
[ggifun{1:N}] = deal(emptyfun);

sProb.locFuns.ffi = {f1f,f2f,f3f};
sProb.locFuns.hhi = {h1f,h2f,h3f};
sProb.locFuns.ggi = ggifun;


sProb.zz0   = {[-1;-1],[-1;-1],[-1;-1]};
sProb.lam0  = lam0;
%xx0        = {[1 1]',[1 1]'};

sProb.llbx  = {lb1,lb2,lb3};
sProb.uubx  = {ub1,ub2,ub3};
sProb.AA    = {A1,A2,A3};

opts = initializeOpts(rho, mu, maxit, Sig, term_eps);

sol_ALADIN  = run_ALADIN(sProb,opts);
                                  
%% solve centralized problem with CasADi & IPOPT
y1  =   sym('y1',[n,1],'real');
y2  =   sym('y2',[n,1],'real');
y3  =   sym('y3',[n,1],'real');
f1fun   =   matlabFunction(f1,'Vars',{y1});
f2fun   =   matlabFunction(f2,'Vars',{y2});
f3fun   =   matlabFunction(f3,'Vars',{y3});
h1fun   =   emptyfun;
h2fun   =   emptyfun;
h3fun   =   matlabFunction(h3,'Vars',{y3});


% y0  =   ones(N*n,1);
y   =   SX.sym('y',[N*n,1]);
F   =   f1fun(y(1:2))+f2fun(y(3:4))+f3fun(y(5:6));
g   =   [h3fun(y(5:6));
         [A1, A2, A3]*y];
nlp =   struct('x',y,'f',F,'g',g);
cas =   nlpsol('solver','ipopt',nlp);
sol =   cas('lbx', [lb1; lb2; lb3],...
            'ubx', [ub1; ub2; ub3],...
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