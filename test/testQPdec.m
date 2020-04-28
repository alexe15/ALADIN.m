% reset envoronment variables for running the tests
clear all;
import casadi.*

load('./problem_data/QPdec.mat')

testNumTol = 1e-8;

% test D-CG
opts.innerAlg = 'D-CG';
opts.innerIter = 100;
[lamCG LamCG] = solveQPdec( cond, lamOld, opts );


% test D_ADMM
opts.innerAlg = 'D-ADMM';
opts.innerIter = 500;
[lamADM LamADM] = solveQPdec( cond, lamOld, opts );


% check results
assert(norm(LamADM - LamCG,inf)<testNumTol,'Wrong QP solution in at least one centralized QP solver'); 


%% old version
% numerical tolerance for tests
% testNumTol = 1e-6;
% 
% % number of variables/constraints
% nxi      = 80;
% nci      = 20;
% NsubSys  = 5;
% nCons    = nxi/5;
% 
% testedSolvers = {'ADMM','CG'};
% 
% % create random convex QP
% % create random coupling
% A        = zeros(nCons,nxi*NsubSys);
% for i=1:nCons
%     coupSys = [0 0];
%     while coupSys(1) == coupSys(2)
%         coupSys = round(NsubSys*rand(1,2)+0.5);
%     end
%     coupInd  = round(rand(2,1)*nxi);
%     A(i,(coupSys-1)*nxi + coupInd') = 1;
% end
% 
% 
% for i=1:NsubSys
%    AA{i} = A(:,(i-1)*nxi+1:i*nxi);
%     
%    H     = rand(nxi);
%    H     = (H + H')^2;
%    HH{i} = H;
%    hh{i} = rand(nxi,1);
%    
%    CC{i} = rand(nci,nxi);
%    bb{i} = rand(nci,1);
%    
%    xx{i} = 0.01*rand(nxi,1);
% end
% 
% mu   = 1e8;
% lam  = 0.01*rand(nCons,1);
% iter = 100;
% 
% %% test for decentralized QP solver
% for alg = testedSolvers
%     [xOptQP, lamQP]  = solveQPdecOld( HH, CC, hh, AA, xx, lam, mu, iter, alg );
%     xOpt.(alg{1}) = xOptQP;
% end
% 
% % check results
% for solver = {testedSolvers{2:end}}
%     assert(norm(xOpt.ADMM-xOpt.CG,inf)<testNumTol,'Wrong QP solution in at least one centralized QP solver'); 
% end
% 
% 



