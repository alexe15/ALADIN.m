addpath('./solver');
clear all;
clc;
import casadi.*

%% define Alex's non-convex problem
N   =   2;
n   =   2;
m   =   1;
y1  =   sym('y1',[n,1],'real');
y2  =   sym('y2',[n,1],'real');

f1  =   2*(y1(1)-1)^2;
f2  =   (y2(2)-2)^2;


h1  =   1-y1(1)*y1(2);
% h1  =   [1-y1(1)*y1(2);
%          -1+y1(1)*y1(2)];
h2  =   -1.5+y2(1)*y2(2);

A1  =   [0, 1];
A2  =   [-1,0];
b   =   0;

lb1 =   [0;0];
lb2 =   [0;0];

ub1 =   [10;10];
ub2 =   [10;10];

%% convert symbolic variables to MATLAB fuctions
f1f     =  matlabFunction(f1,'Vars',{y1});
f2f     =  matlabFunction(f2,'Vars',{y2});

h1f     =   matlabFunction(h1,'Vars',{y1});
h2f     =   matlabFunction(h2,'Vars',{y2});

%% initalize
maxit   =   15;
y0      =   3*rand(N*n,1);
lam0    =   10*(rand(1)-0.5);
rho     =   10;
mu      =   10;
eps     =   1e-4;
Sig     =   {eye(n),eye(n)};

%% solve with ALADIN
emptyfun      = @(x) [];
AQP           = [A1,A2];
ffifun        = {f1f,f2f};
hhifun        = {h1f,h2f};
[ggifun{1:N}] = deal(emptyfun);

yy0         = {y0(1:2),y0(3:4)};
%xx0        = {[1 1]',[1 1]'};

llbx        = {lb1,lb2};
uubx        = {ub1,ub2};
AA          = {A1,A2};

opts = struct('rho0',rho,'rhoUpdate',1,'rhoMax',5e3,'mu0',mu,'muUpdate',1,...
    'muMax',1e5,'eps',eps,'maxiter',maxit,'actMargin',-1e-6,'hessian','full',...
     'solveQP','MA57','reg','true','locSol','ipopt','innerIter',2400,'innerAlg', ...
     'full','plot',true);

[xoptAL, loggAL]   = run_ALADIN(ffifun,ggifun,hhifun,AA,yy0,...
                                      lam0,llbx,uubx,Sig,opts);
           
                                 
%% solve centralized problem with CasADi & IPOPT
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
sol =   cas('lbx', [lb1; lb2],...
            'ubx', [ub1; ub2],...
            'lbg', [-inf;-inf;b], ...
            'ubg', [0;0;b]);  
        
        
% plotting
set(0,'defaulttextInterpreter','latex')
figure(2)
hold on
plot(loggAL.X')
hold on
plot(maxit,full(sol.x),'ob')
xlabel('$k$');
ylabel('$x^k$');

%% solve with ADMM
% rhoADMM = 1000;
% for i=1:length(ffifun) 
%     lam0ADM{i}  = zeros(size(AA{i},1),1);
% end   
% 
% ADMMopts = struct('scaling',false,'rhoUpdate',false,'maxIter',100);
% [xoptADM, loggADM]         = run_ADMM(ffifun,ggifun,hhifun,AA,xx0,...
%                              lam0ADM,llbx,uubx,rhoADMM,Sig,ADMMopts);             
                                  
% [xoptSQP, loggSQP] = run_SQP(ffifun,ggifun,hhifun,AA,xxgi0,...
%                                       lam0,llbx,uubx,Sig,opts);
% 

