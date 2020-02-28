function [time] =run_sensor_network(N, sigma,mu, rho)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

emptyfun      = @(x) [];

N_       = N; % number of agents
sigma_   = sigma;  % variance of measurement error
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

maxit_      = 5;
lam0_       = (rand(1) - 0.5)*ones(size(A1_, 1), 1);
rho_        = rho;
mu_         = mu;
eps_        = 1e-4;
term_eps_    = 0;

Sig_ = cell(1, N_);

for i = 1 : N_
    Sig_(i) = mat2cell(eye(n_), n_, n_);
end

% opts = initializeOpts(rho_, mu_, maxit_, Sig_, term_eps_);


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

parallel = 'true';
opts = initializeOpts(rho_, mu_, maxit_, Sig_, term_eps_, parallel);
time_parallel = tic;
[xoptAL_, loggAL_] = run_ALADIN(ffifun_,ggifun_,hhifun_,AA_,yy0_,...
                                      lam0_,llbx_,uubx_,Sig_,opts);
time_parfor = toc(time_parallel);
parallel = 'false';
opts = initializeOpts(rho_, mu_, maxit_, Sig_, term_eps_, parallel);
time_central = tic;
[xoptAL_, loggAL_] = run_ALADIN(ffifun_,ggifun_,hhifun_,AA_,yy0_,...
                                      lam0_,llbx_,uubx_,Sig_,opts);
time_for = toc(time_central);
time = [time_parfor; time_for];
end

