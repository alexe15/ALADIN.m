
%% run with ADMM        


semilogy(vecnorm([sProb.AA{:}]*sol_ADMM.logg.X))

% use a few ADMM iteration as "heuristic globalization"
optsADM    = struct('rho',1e5,'scaling',false,'rhoUpdate',false,'maxIter',50);
sol_ADMM   = run_ADMMnew(sProb, optsADM);

sProb.zz0  = sol_ADMM.xxOpt;
% use everage of assigned Lagrange multipliers for initialization
sProb.lam0 = (sol_ADMM.lamOpt{1} + sol_ADMM.lamOpt{2} + sol_ADMM.lamOpt{3} + sol_ADMM.lamOpt{4})/2;
