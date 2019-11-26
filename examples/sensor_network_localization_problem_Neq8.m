restoredefaultpath;
clear all;
clc;

addpath('../src');
addpath(genpath('../tools/'));
addpath('./solver');

import casadi.*
emptyfun        = @(x) [];

%% define sensor network localization problem for N = 8

% For details, see: 
% An augmented Lagrangian based algorithm for distributed nonconvex
% optimization

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

% number of agents
N = 8; 

% dimension of design variables
n = 4;

% variance
sigma =2;
sigma1 = 2; % for debugging!

% matrix to store initial positions
y1 = sym('y1', [n,1],'real');
y2 = sym('y2', [n,1],'real');
y3 = sym('y3', [n,1],'real');
y4 = sym('y4', [n,1],'real');
y5 = sym('y5', [n,1],'real');
y6 = sym('y6', [n,1],'real');
y7 = sym('y7', [n,1],'real');
y8 = sym('y8', [n,1],'real');



%% measurements with variance of 3 (max variance that leads to convergence for aladin)
% define initial vaules for eta_i and eta_i_bar:


eta_1 = [8 * cos(2 * 1 * pi / 8) + normrnd(0, sigma) ; ...
         8 * sin(2 * 1 * pi / 8) + normrnd(0, sigma)];
eta_2 = [8 * cos(2 * 2 * pi / 8) + normrnd(0, sigma) ; ...
         8 * sin(2 * 2 * pi / 8) + normrnd(0, sigma)];
eta_3 = [8 * cos(2 * 3 * pi / 8) + normrnd(0, sigma) ; ...
         8 * sin(2 * 3 * pi / 8) + normrnd(0, sigma)];
eta_4 = [8 * cos(2 * 4 * pi / 8) + normrnd(0, sigma) ; ...
         8 * sin(2 * 4 * pi / 8) + normrnd(0, sigma)];
eta_5 = [8 * cos(2 * 5 * pi / 8) + normrnd(0, sigma) ; ...
         8 * sin(2 * 5 * pi / 8) + normrnd(0, sigma)];
eta_6 = [8 * cos(2 * 6 * pi / 8) + normrnd(0, sigma) ; ...
         8 * sin(2 * 6 * pi / 8) + normrnd(0, sigma)];
eta_7 = [8 * cos(2 * 7 * pi / 8) + normrnd(0, sigma) ; ...
         8 * sin(2 * 7 * pi / 8) + normrnd(0, sigma)];
eta_8 = [8 * cos(2 * 8 * pi / 8) + normrnd(0, sigma) ; ...
         8 * sin(2 * 8 * pi / 8) + normrnd(0, sigma)];

eta_1_bar = 2 * 8 * sin(pi/8) + normrnd(0, sigma);
eta_2_bar = 2 * 8 * sin(pi/8) + normrnd(0, sigma);
eta_3_bar = 2 * 8 * sin(pi/8) + normrnd(0, sigma);
eta_4_bar = 2 * 8 * sin(pi/8) + normrnd(0, sigma);
eta_5_bar = 2 * 8 * sin(pi/8) + normrnd(0, sigma);
eta_6_bar = 2 * 8 * sin(pi/8) + normrnd(0, sigma);
eta_7_bar = 2 * 8 * sin(pi/8) + normrnd(0, sigma);
eta_8_bar = 2 * 8 * sin(pi/8) + normrnd(0, sigma);     


% coupled optimization objectives
f1 =  1 / (4 * sigma1^2) * ((y1(1) - eta_1(1))^2 + (y1(2) - eta_1(2))^2) ...
    + 1 / (4 * sigma1^2) * ((y1(3) - eta_2(1))^2 + (y1(4) - eta_2(2))^2) ...
    + 1 / (2 * sigma1^2) * (sqrt((y1(1) - y1(3))^2 + (y1(2) - y1(4))^2) - eta_1_bar)^2;

f2 =  1 / (4 * sigma1^2) * ((y2(1) - eta_2(1))^2 + (y2(2) - eta_2(2))^2) ...
    + 1 / (4 * sigma1^2) * ((y2(3) - eta_3(1))^2 + (y2(4) - eta_3(2))^2) ...
    + 1 / (2 * sigma1^2) * (sqrt((y2(1) - y2(3))^2 + (y2(2) - y2(4))^2) - eta_2_bar)^2;

f3 =  1 / (4 * sigma1^2) * ((y3(1) - eta_3(1))^2 + (y3(2) - eta_3(2))^2) ...
    + 1 / (4 * sigma1^2) * ((y3(3) - eta_4(1))^2 + (y3(4) - eta_4(2))^2) ...
    + 1 / (2 * sigma1^2) * (sqrt((y3(1) - y3(3))^2 + (y3(2) - y3(4))^2) - eta_3_bar)^2;

f4 =  1 / (4 * sigma1^2) * ((y4(1) - eta_4(1))^2 + (y4(2) - eta_4(2))^2) ...
    + 1 / (4 * sigma1^2) * ((y4(3) - eta_5(1))^2 + (y4(4) - eta_5(2))^2) ...
    + 1 / (2 * sigma1^2) * (sqrt((y4(1) - y4(3))^2 + (y4(2) - y4(4))^2) - eta_4_bar)^2;

f5 =  1 / (4 * sigma1^2) * ((y5(1) - eta_5(1))^2 + (y5(2) - eta_5(2))^2) ...
    + 1 / (4 * sigma1^2) * ((y5(3) - eta_6(1))^2 + (y5(4) - eta_6(2))^2) ...
    + 1 / (2 * sigma1^2) * (sqrt((y5(1) - y5(3))^2 + (y5(2) - y5(4))^2) - eta_5_bar)^2;

f6 =  1 / (4 * sigma1^2) * ((y6(1) - eta_6(1))^2 + (y6(2) - eta_6(2))^2) ...
    + 1 / (4 * sigma1^2) * ((y6(3) - eta_7(1))^2 + (y6(4) - eta_7(2))^2) ...
    + 1 / (2 * sigma1^2) * (sqrt((y6(1) - y6(3))^2 + (y6(2) - y6(4))^2) - eta_6_bar)^2;

f7 =  1 / (4 * sigma1^2) * ((y7(1) - eta_7(1))^2 + (y7(2) - eta_7(2))^2) ...
    + 1 / (4 * sigma1^2) * ((y7(3) - eta_8(1))^2 + (y7(4) - eta_8(2))^2) ...
    + 1 / (2 * sigma1^2) * (sqrt((y7(1) - y7(3))^2 + (y7(2) - y7(4))^2) - eta_7_bar)^2;

f8 =  1 / (4 * sigma1^2) * ((y8(1) - eta_8(1))^2 + (y8(2) - eta_8(2))^2) ...
    + 1 / (4 * sigma1^2) * ((y8(3) - eta_1(1))^2 + (y8(4) - eta_1(2))^2) ...
    + 1 / (2 * sigma1^2) * (sqrt((y8(1) - y8(3))^2 + (y8(2) - y8(4))^2) - eta_8_bar)^2;



% inequality constraints - later!!! TODO
h1 = (sqrt((y1(1) - y1(3))^2 + (y1(2) - y1(4))^2) - eta_1_bar)^2;
h2 = (sqrt((y2(1) - y2(3))^2 + (y2(2) - y2(4))^2) - eta_2_bar)^2;
h3 = (sqrt((y3(1) - y3(3))^2 + (y3(2) - y3(4))^2) - eta_3_bar)^2;
h4 = (sqrt((y4(1) - y4(3))^2 + (y4(2) - y4(4))^2) - eta_4_bar)^2;
h5 = (sqrt((y5(1) - y5(3))^2 + (y5(2) - y5(4))^2) - eta_5_bar)^2;
h6 = (sqrt((y6(1) - y6(3))^2 + (y6(2) - y6(4))^2) - eta_6_bar)^2;
h7 = (sqrt((y7(1) - y7(3))^2 + (y7(2) - y7(4))^2) - eta_7_bar)^2;
h8 = (sqrt((y8(1) - y8(3))^2 + (y8(2) - y8(4))^2) - eta_8_bar)^2;



% coupling matrices
A1 = [  0,  0, -1,  0; ...
        0,  0,  0, -1; ...
        1,  0,  0,  0; ...
        0,  1,  0,  0  ];
       
A2 = [  1,  0,  0,  0; ...
        0,  1,  0,  0; ...
        0,  0, -1,  0; ...
        0,  0,  0, -1  ];
    
A3 = [  0,  0, -1,  0; ...
        0,  0,  0, -1; ...
        1,  0,  0,  0; ...
        0,  1,  0,  0  ];
    
A4 = [  1,  0,  0,  0; ...
        0,  1,  0,  0; ...
        0,  0, -1,  0; ...
        0,  0,  0, -1  ];
    
A5 = [  0,  0, -1,  0; ...
        0,  0,  0, -1; ...
        1,  0,  0,  0; ...
        0,  1,  0,  0  ];
    
A6 = [  1,  0,  0,  0; ...
        0,  1,  0,  0; ...
        0,  0, -1,  0; ...
        0,  0,  0, -1  ];

A7 = [  0,  0, -1,  0; ...
        0,  0,  0, -1; ...
        1,  0,  0,  0; ...
        0,  1,  0,  0  ];

A8 = [  1,  0,  0,  0; ...
        0,  1,  0,  0; ...
        0,  0, -1,  0; ...
        0,  0,  0, -1  ];

b = 0;

lb1 = [-inf; -inf; -inf; -inf];
lb2 = [-inf; -inf; -inf; -inf];
lb3 = [-inf; -inf; -inf; -inf];
lb4 = [-inf; -inf; -inf; -inf];
lb5 = [-inf; -inf; -inf; -inf];
lb6 = [-inf; -inf; -inf; -inf];
lb7 = [-inf; -inf; -inf; -inf];
lb8 = [-inf; -inf; -inf; -inf];

ub1 = [inf; inf; inf; inf];
ub2 = [inf; inf; inf; inf];
ub3 = [inf; inf; inf; inf];
ub4 = [inf; inf; inf; inf];
ub5 = [inf; inf; inf; inf];
ub6 = [inf; inf; inf; inf];
ub7 = [inf; inf; inf; inf];
ub8 = [inf; inf; inf; inf];






%% convert symbolic variables to MATLAB functions

f1f = matlabFunction(f1, 'Vars', {y1});
f2f = matlabFunction(f2, 'Vars', {y2});
f3f = matlabFunction(f3, 'Vars', {y3});
f4f = matlabFunction(f4, 'Vars', {y4});
f5f = matlabFunction(f5, 'Vars', {y5});
f6f = matlabFunction(f6, 'Vars', {y6});
f7f = matlabFunction(f7, 'Vars', {y7});
f8f = matlabFunction(f8, 'Vars', {y8});

h1f = matlabFunction(h1, 'Vars', {y1});
h2f = matlabFunction(h2, 'Vars', {y2});
h3f = matlabFunction(h3, 'Vars', {y3});
h4f = matlabFunction(h4, 'Vars', {y4});
h5f = matlabFunction(h5, 'Vars', {y5});
h6f = matlabFunction(h6, 'Vars', {y6});
h7f = matlabFunction(h7, 'Vars', {y7});
h8f = matlabFunction(h8, 'Vars', {y8});

%% initialize
maxit       =   15;
lam0        =   10 * (rand(1) - 0.5)*ones(size(A1, 1), 1);
rho         =   10;
mu          =   100;
eps         =   1e-4;
Sig         =   {eye(n), eye(n), eye(n), eye(n), eye(n), eye(n), eye(n), eye(n)};
term_eps    = 0;

opts = initializeOpts(rho, mu, maxit, term_eps);


%% solve with aladin
AQP             = [A1, A2, A3, A4, A5, A6, A7, A8];
ffifun          = {f1f, f2f, f3f, f4f, f5f, f6f ,f7f, f8f};
hhifun          = {h1f, h2f, h3f, h4f, h5f, h6f, h7f, h8f};
[ggifun{1:N}]   = deal(emptyfun);

% initialize start value

eta_1_start = [8 * cos(2 * 1 * pi / 8) + normrnd(0, sigma) ; ...
               8 * sin(2 * 1 * pi / 8) + normrnd(0, sigma)];
eta_2_start = [8 * cos(2 * 2 * pi / 8) + normrnd(0, sigma) ; ...
               8 * sin(2 * 2 * pi / 8) + normrnd(0, sigma)];
eta_3_start = [8 * cos(2 * 3 * pi / 8) + normrnd(0, sigma) ; ...
               8 * sin(2 * 3 * pi / 8) + normrnd(0, sigma)];
eta_4_start = [8 * cos(2 * 4 * pi / 8) + normrnd(0, sigma) ; ...
               8 * sin(2 * 4 * pi / 8) + normrnd(0, sigma)];
eta_5_start = [8 * cos(2 * 5 * pi / 8) + normrnd(0, sigma) ; ...
               8 * sin(2 * 5 * pi / 8) + normrnd(0, sigma)];
eta_6_start = [8 * cos(2 * 6 * pi / 8) + normrnd(0, sigma) ; ...
               8 * sin(2 * 6 * pi / 8) + normrnd(0, sigma)];
eta_7_start = [8 * cos(2 * 7 * pi / 8) + normrnd(0, sigma) ; ...
               8 * sin(2 * 7 * pi / 8) + normrnd(0, sigma)];
eta_8_start = [8 * cos(2 * 8 * pi / 8) + normrnd(0, sigma) ; ...
               8 * sin(2 * 8 * pi / 8) + normrnd(0, sigma)];

 yy0 = {[ eta_1_start;  eta_2_start], ...
        [ eta_2_start;  eta_3_start], ...
        [ eta_3_start;  eta_4_start], ...
        [ eta_4_start;  eta_5_start], ...
        [ eta_5_start;  eta_6_start], ...
        [ eta_6_start;  eta_7_start], ...
        [ eta_7_start;  eta_8_start], ...
        [ eta_8_start;  eta_1_start]};


llbx = {lb1, lb2, lb3, lb4, lb5, lb6, lb7, lb8};
uubx = {ub1, ub2, ub3, ub4, ub5, ub6, ub7, ub8};
AA   = {A1, A2, A3, A4, A5, A6, A7, A8};

[xoptAL, loggAL] = run_ALADIN(ffifun,ggifun,hhifun,AA,yy0,...
                                      lam0,llbx,uubx,Sig,opts);


                                  
%% solve centralized problem with DasADi & IPOPT

addpath('../src');
import casadi.*

y1  =   sym('y1',[n,1],'real');
y2  =   sym('y2',[n,1],'real');
y3  =   sym('y3',[n,1],'real');
y4  =   sym('y4',[n,1],'real');
y5  =   sym('y5',[n,1],'real');
y6  =   sym('y6',[n,1],'real');
y7  =   sym('y7',[n,1],'real');
y8  =   sym('y8',[n,1],'real');


f1fun = matlabFunction(f1, 'Vars', {y1});
f2fun = matlabFunction(f2, 'Vars', {y2});
f3fun = matlabFunction(f3, 'Vars', {y3});
f4fun = matlabFunction(f4, 'Vars', {y4});
f5fun = matlabFunction(f5, 'Vars', {y5});
f6fun = matlabFunction(f6, 'Vars', {y6});
f7fun = matlabFunction(f7, 'Vars', {y7});
f8fun = matlabFunction(f8, 'Vars', {y8});

h1fun = matlabFunction(h1, 'Vars', {y1});
h2fun = matlabFunction(h2, 'Vars', {y2});
h3fun = matlabFunction(h3, 'Vars', {y3});
h4fun = matlabFunction(h4, 'Vars', {y4});
h5fun = matlabFunction(h5, 'Vars', {y5});
h6fun = matlabFunction(h6, 'Vars', {y6});
h7fun = matlabFunction(h7, 'Vars', {y7});
h8fun = matlabFunction(h8, 'Vars', {y8});


y   =   SX.sym('y',[N*n,1]);


% initialize inital start values
yy0 = [eta_1_start; eta_2_start; ...
       eta_2_start; eta_3_start; ...
       eta_3_start; eta_4_start; ...
       eta_4_start; eta_5_start; ...
       eta_5_start; eta_6_start; ...
       eta_6_start; eta_7_start; ...
       eta_7_start; eta_8_start; ...
       eta_8_start; eta_1_start];
     
     
F   =   f1fun(y(1:4))   + ...
        f2fun(y(5:8))   + ...
        f3fun(y(9:12))  + ...
        f4fun(y(13:16)) + ...
        f5fun(y(17:20)) + ...
        f6fun(y(21:24)) + ...
        f7fun(y(25:28)) + ...
        f8fun(y(29:32));
    
g   =   [h1fun(y(1:4));
         h2fun(y(5:8));
         h3fun(y(9:12));
         h4fun(y(13:16));
         h5fun(y(17:20));
         h6fun(y(21:24));
         h7fun(y(25:28));
         h8fun(y(29:32));
         [A1, A2, A3, A4, A5, A6, A7, A8]*y];
     
 nlp =   struct('x',y,'f',F,'g',g);


cas =   nlpsol('solver','ipopt',nlp);

 sol =   cas('x0' , yy0, ...
            'lbx', [lb1; lb2; lb3; lb4; lb5; lb6; lb7; lb8],...
            'ubx', [ub1; ub2; ub3; ub4; ub5; ub6; ub7; ub8],...
            'lbg', [-inf;-inf;-inf;-inf;-inf;-inf;-inf;-inf;-inf;-inf;-inf;b], ...
            'ubg', [0;0;0;0;0;0;0;0;0;0;0;b]);  

     
%addpath('../src');
%import casadi.*
        
% plotting
set(0,'defaulttextInterpreter','latex')
figure(2)
hold on
plot(loggAL.X')
hold on
plot(maxit,full(sol.x),'ob')
xlabel('$k$');
ylabel('$x^k$');        
