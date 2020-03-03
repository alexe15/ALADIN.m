% reset envoronment variables for running the tests
clear all;
import casadi.*

% numerical tolerance for tests
testNumTol = 1e-6;

% number of variables/constraints
nx = 80;
nc = 20;

testedSolvers = {'ipopt','pinv','linsolve','sparseBs','MA57'};

% create random convex QP
H = rand(nx);
H = (H + H')^2;
h = rand(nx,1);

A = rand(nc,nx);
b = rand(nc,1);


%% test centralized QP solvers
for solver = testedSolvers
    [xOptQP, lamQP] = solveQP(H,h,A,b,solver);   
    xOpt.(solver{1}) = xOptQP;
end

% check results
for solver = {testedSolvers{2:end}}
    assert(norm(xOpt.ipopt-xOpt.(solver{1}),inf)<testNumTol,'Wrong QP solution in at least one centralized QP solver'); 
end