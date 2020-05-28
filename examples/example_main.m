%% Alex's non-convex example
%restoredefaultpath;
clear all;
clc;


%% centralized problem with casadi + ipopt

import casadi.*
x1 = SX.sym('x1');
x2 = SX.sym('x2');

nlp = struct('x', [x1;x2], 'f', 2*(x1 - 1)^2 + (x2 - 2)^2, 'g', x1 * x2);
S = nlpsol('S', 'ipopt', nlp);

sol = S('x0', [0, 0], 'lbg', -1, 'ubg', 1.5);
x_opt = sol.x;


%% ALADIN Solution 1 - using matlab Functions as input
% define symbolic variables
y1  =   sym('y1',[1,1],'real');
y2  =   sym('y2',[2,1],'real');

% define symbolic objectives
f1s =   2*(y1-1)^2;
f2s =   (y2(2)-2)^2;

% define symbolic ineq. constraints

h2s = [-1-y2(1)*y2(2);-1.5+y2(1)*y2(2)];

% convert symbolic variables to MATLAB fuctions
f1 = matlabFunction(f1s,'Vars',{y1});
f2 = matlabFunction(f2s,'Vars',{y2});

h1 = @(y1) [];
h2 = matlabFunction(h2s,'Vars',{y2});

% define coupling matrices
A1 = 1;
A2 = [-1, 0];

% collect problem data in sProb struct
sProb.locFuns.ffi = {f1, f2};
sProb.locFuns.hhi = {h1, h2};

% handing over of coupling matrices to problem
sProb.AA = {A1, A2};

% start solver with default options
sol_1 = run_ALADIN(sProb);



%% ALADIN Solution 2 - using CasADi variabes

% define symbolic variables
import casadi.*
y_1 = SX.sym('y_1', 1);
y_2 = SX.sym('y_2', 2);

% define symbolic objectives
f1s = 2 * (y_1 - 1)^2;
f2s = (y_2(2) - 2)^2;

% define symbolic ineq. constraints
h1s = [];
h2s = [  -1 - y_2(1)*y_2(2); ...
       -1.5 + y_2(1)*y_2(2)]; 

% convert symbolic variables to MATLAB fuctions
f1 = Function('f1', {y_1}, {f1s});
f2 = Function('f2', {y_2}, {f2s});

h1 = Function('h1', {y_1}, {h1s});
h2 = Function('h2', {y_2}, {h2s});

% define coupling matrices
A1 = 1;
A2 = [-1, 0];

% collect problem data in sProb struct
sProb.locFuns.ffi = {f1, f2};
sProb.locFuns.hhi = {h1, h2};

% handing over of coupling matrices to problem
sProb.AA = {A1, A2};

% start solver with default options
sol = run_ALADIN(sProb);



%% ALADIN Solution 3 -  using function handle
% define objectives
f1 = @(x) 2 * (x - 1)^2;
f2 = @(y) (y(2) - 2)^2;

% define inequality constraints
h1 = @(x) [];
h2 = @(y) [  -1 - y(1) * y(2); ...
           -1.5 + y(1) * y(2)];
% define coupling matrices
A1 =  1;
A2 = [-1, 0];

% collect problem data in sProb struct
sProb.locFuns.ffi = {f1, f2};
sProb.locFuns.hhi = {h1, h2};

% handing over of coupling matrices to problem
sProb.AA = {A1, A2};

% start solver with default options
sol = run_ALADIN(sProb);