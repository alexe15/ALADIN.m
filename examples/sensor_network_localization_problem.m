%% Sensor Network Problem
% Sample sheet for the usage of the ALADIN solver
% For detailed desciption of the sensor network problem, see:
%   An Augmented Lagrangian Based Algorithm For Distributed Nonconvex
%   Optimization
%
% In the beginnig, choose a Number N of sensors (line 53 )!
% Initial values (that we tested and that should do what we want):
% N = 8
% sigma_i = 3

addpath('../src');
addpath(genpath('../tools/'));
addpath('./solver');
clear all;
clc;
import casadi.*
emptyfun      = @(x) [];

%% define sensor network localization problem for N sensors

% Declaration of variables: 

% Xi_i          unknown position of sensor i in R^2
% eta_i         measurement of Xi_i

% eta_i - Xi_i  measurement error. 
%               It is assumed to be Gaussian distributed
%               with variance sigma_i

% eta_i_bar     measurement of distance between sensor i and sensor i+1
% d_i           measurement error of eta_i_bar with variance sigma_i_bar
% zeta_i        ith's sensor's estimation of the position Xi_{i+1}

% optimization variable:     x_i = (Xi_i, zeta_i) \in R^4
% constraints for coupling:  zeta_i = Xi_{i+1}

% objetives:
% f_i(x_i) = {1/(4 sigma_i^2)} * norm^2(Xi_i - eta_i)
%          + {1/(4 sigma_{i+1}^2)} * norm^2(zeta_i - \eta_{i+t})
%          + {1/(2 d_i)} * (norm(Xi_i - eta_i) - eta_i_bar)^2

% inequality constraints:
% h_i(x_i) = (norm(Xi_i - eta_i) - eta_i_bar)^2 - eta_i_bar^2 - sigma_i_bar

% Inititalization
% eta_i = (N * cos (2*i*pi/N), N * sin(2*i*pi/N)) + e_i
% eta_i_bar = 2 * N * sin(pi/N) + d_i
% e_i, d_i measurement errors in 2d, 1d respectively
% They are Gaussian distributed with variances sigma_i = sigma_i_bar = 10

%Initialization:
N_       = 100; % number of agents
sigma_   = 10;  % variance of measurement error
n_       = 4;   % dimension of design variables          
d_       = 2;         % dimension of coordinate system (!!! hard coded for d = 2 !!!)

%matrix to store initial positions

y_ = cell(1, N_);

y_sym_ = sym('y%d%d', [N_ n_], 'real');
y_sym_ = y_sym_';

for i = 1 : N_
    y_(i) = {y_sym_(:, 1)};
end


 eta     = zeros(d_, N_);
 eta_bar = zeros(1, N_);
 
 for i = 1 : N_
     eta( :, i ) = [N_ * cos(2 * i * pi / 8) + normrnd(0, sigma_) ; ...
                    N_ * sin(2 * i * pi / 8) + normrnd(0, sigma_)];
     
     eta_bar(i)  = 2 * N_ * sin( pi / N_) + normrnd(0, sigma_);
 end

% coupled optimization objectives

F_ = zeros(N_, 1);
F_ = sym(F_);


for i = 1 : N_ - 1
    F_(i) = 1 / (4 * sigma_^2) * ((y_sym_(1, i) - eta(1, i))^2 + (y_sym_(2, i) - eta(2, i))^2) ...
          + 1 / (4 * sigma_^2) * ((y_sym_(3, i) - eta(1, i + 1))^2 + (y_sym_(4, i) - eta(2, i + 1))^2) ...
          + 1 / (2 * sigma_^2) * (sqrt((y_sym_(1, i) - y_sym_(3, i))^2 + (y_sym_(2, i) - y_sym_(4, i))^2) - eta_bar(i))^2;

end

for i = N_ : N_
F_(i) = 1 / (4 * sigma_^2) * ((y_sym_(1, i) - eta(1, i))^2 + (y_sym_(2, i) - eta(2, i))^2) ...
    + 1 / (4 * sigma_^2) * ((y_sym_(3, i) - eta(1, 1))^2 + (y_sym_(4, i) - eta(2, 1))^2) ...
    + 1 / (2 * sigma_^2) * (sqrt((y_sym_(1, i) - y_sym_(3, i))^2 + (y_sym_(2, i) - y_sym_(4, i))^2) - eta_bar(i))^2;
end


% inequality constraints

H_ = zeros(N_, 1);
H_ = sym(H_);
 
for i = 1 : N_
    H_(i) = (sqrt((y_sym_(1, i) - y_sym_(3, i))^2 + (y_sym_(2, i) - y_sym_(4, i))^2) - eta_bar(i))^2;
end

% coupling matrices 
A_ = zeros(n_, n_*N_);

A1_ = [ 0,  0, -1,  0;...
       0,  0,  0, -1; ...
       1,  0,  0,  0; ...
       0,  1,  0,  0];
   
A2_ = [ 1,  0,  0,  0;...
       0,  1,  0,  0; ...
       0,  0, -1,  0; ...
       0,  0,  0, -1];
   
b = 0;



%% initialize

maxit_ = 15;
lam0_  = (rand(1) - 0.5)*ones(size(A1_, 1), 1);
rho_   = 10;
mu_    = 100;
eps_   = 1e-4;

Sig_ = cell(1, N_);

for i = 1 : N_
    Sig_(i) = mat2cell(eye(n_), n_, n_);
end

opts  =   struct('rho0',rho_,'rhoUpdate',1,'rhoMax',5e3,'mu0',...
                 mu_,'muUpdate',1,'muMax',1e5,'eps',eps_,...
                 'maxiter',maxit_,'actMargin',-1e-6,'hessian',...
                 'full','solveQP','MA57','reg','true',...
                 'locSol','ipopt','innerIter',2400,'innerAlg',...
                 'full','plot',true,'Hess','standard','slpGlob',...
                 true,'trGamma', 1e6,'Sig','const');

%% solve with aladin
ffifun_          = cell(1, N_);
hhifun_          = cell(1, N_);
[ggifun_{1:N_}]   = deal(emptyfun);

for i = 1 : N_
    ffifun_(i) = {matlabFunction(F_(i), 'Vars', {y_sym_(:, i)})} ;
    hhifun_(i) = {matlabFunction(H_(i), 'Vars', {y_sym_(:, i)})} ;
end

% initialize start value
eta_start_value = zeros(2, N_);
for i = 1  : N_
    eta_start_value(1, i) = N_ * cos( 2 * i * pi / N_ ) + normrnd(0, sigma_);
    eta_start_value(2, i) = N_ * sin( 2 * i * pi / N_ ) + normrnd(0, sigma_);
end

yy0_ = cell(1, N_);

for i = 1 : N_-1
    yy0_(i) = {[eta_start_value(:, i); eta_start_value(:, i + 1)]};
end

yy0_(N_) = {[eta_start_value(:, N_); eta_start_value(:, 1)]};

% initialize boundary
llbx_ = cell(1, N_);
uubx_ = cell(1, N_);
AA_ = cell(1, N_);

for i = 1 : N_
    llbx_(i) = mat2cell([-inf; -inf; -inf; -inf], 4, 1);
    uubx_(i) = mat2cell([ inf;  inf;  inf;  inf], 4, 1);
end

for i = 1 : 2 : N_
    AA_(i) = mat2cell(A1_, n_, n_);
end

for i = 2 : 2 : N_
    AA_(i) = mat2cell(A2_, n_, n_);
end


[xoptAL_, loggAL_] = run_ALADIN(ffifun_,ggifun_,hhifun_,AA_,yy0_,...
                                      lam0_,llbx_,uubx_,Sig_,opts);
                                  
%% solve centralized problem with DasADi & IPOPT

y   =   SX.sym('y',[N_*n_,1]);


yy0_vec = double.empty(n_ * N_, 0);
 
for i = 1 : N_-1
    yy0_vec(4*i - 4 + 1: 4*i) = [eta_start_value(:, i); eta_start_value(:, i + 1)];
end

yy0_vec = yy0_vec';
yy0_vec = vertcat(yy0_vec, [eta_start_value(:, N_); eta_start_value(:, 1)]);

ffifun_f = zeros(N_, 1);
ffifun_f = SX(ffifun_f);

ffifun_f(1) = ffifun_{1}(y(4*(1) - 4 + 1 : 4 * 1));

Hfun = zeros(N_, 1);
Hfun = SX(Hfun);


for i = 2 : N_
    var_1 = y_sym_(4*(1) - 4 + 1 : 4 * 1);
    ffifun_f(i) = ffifun_{i}(y(4*(i) - 4 + 1 : 4 * i)) + ffifun_f(i - 1);    
end

for i = 1 : N_
    var = y_sym_(4*(1) - 4 + 1 : 4 * 1);
    Hfun(i) = hhifun_{i}(y(4*(i) - 4 + 1 : 4 * i));
end


AA_vec = zeros(n_, n_ * N_);

for i = 1 : 2 : N_
    AA_vec(1 : 4, 4*i - 4 + 1 : 4 * i) = A1_;
end

for i = 2 : 2 : N_
    AA_vec(1 : 4, 4*i - 4 + 1 : 4 * i) = A2_;
end
    
last_entry = AA_vec * y(1 : n_ * N_);
Hfun = vertcat(Hfun, last_entry);

nlp =   struct('x',y,'f',ffifun_f(N_),'g',Hfun);

cas =   nlpsol('solver','ipopt',nlp);

% lbx, ubx, lbg, ubg
lbx_vec = zeros(n_* N_, 1);
ubx_vec = zeros(n_ * N_, 1);
lbg_vec = zeros(N_ + n_, 1);
ubg_vec = zeros(N_ + n_, 1);


for i = 1 : n_ * N_
    lbx_vec(i) = -inf;
    ubx_vec(i) = inf;
end

for i = 1 : N_ + n_ -1
    lbg_vec(i) = -inf;
    ubg_vec(i) = inf; 
end

lbg_vec(N_ + n_) = b;
ubg_vec(N_ + n_) = b;


 sol =   cas('x0' , yy0_vec, ...
            'lbx', lbx_vec,...
            'ubx', ubx_vec,...
            'lbg', lbg_vec, ...
            'ubg', ubg_vec);  
        
 % plotting
set(0,'defaulttextInterpreter','latex')
figure(2)
hold on
plot(loggAL_.X')
hold on
plot(maxit_,full(sol.x),'ob')
xlabel('$k$');
ylabel('$x^k$');          
