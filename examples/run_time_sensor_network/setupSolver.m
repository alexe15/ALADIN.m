function [sProb ] = setupSolver(N, sigma)

% general setup

n       = 4;   % dimension of design variables          
d       = 2;   % dimension of coordinate system 

% initialization of variables

 y = sym('y%d%d', [N n], 'real');
 y = y';

% get estimated initial positions
 [eta, eta_bar] = getEta(N, d, sigma);

% definition of objective functions
 F = getObjective(N, y, eta, eta_bar, sigma);

% definition of inequality constraint
 H = getInequalityConstr(N, y, eta_bar);
 
% definition of counpling matrices
 AA = getCouplingMatrix(N, n);

% start value for optimization
 zz0 = getStartValue(N, sigma); 



%% setting up solver

% set search area
sProb.llbx = cell(1, N);
sProb.uubx = cell(1, N);
for i = 1 : N
    sProb.llbx(i) = mat2cell([-inf; -inf; -inf; -inf], 4, 1);
    sProb.uubx(i) = mat2cell([ inf;  inf;  inf;  inf], 4, 1);
end

% handover of functions
sProb.locFuns.ffi          = cell(1, N);
sProb.locFuns.hhi          = cell(1, N);


for i = 1 : N
    sProb.locFuns.ffi(i) = {matlabFunction(F(i), 'Vars', {y(:, i)})} ;
    sProb.locFuns.hhi(i) = {matlabFunction(H(i), 'Vars', {y(:, i)})} ;
end


sProb.AA = AA;
sProb.zz0 = zz0;

