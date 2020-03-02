function [ optVariants ] = loadDefOpts( )

% define possible options and default values
% standard ALADIN parameters
optVariants.rho0         = {1e2};
optVariants.rhoUpdate    = {1.1};
optVariants.rhoMax       = {1e8};

optVariants.mu0          = {1e3};
optVariants.muUpdate     = {2};
optVariants.muMax        = {2*1e6};

optVariants.eps          = {0};
optVariants.maxiter      = {30};
optVariants.actMargin    = {-1e-6};
optVariants.solveQP      = {'MA57','ipopt','pinv','linsolve','sparseBs','MOSEK','quadprog'};
optVariants.reg          = {'true','false'};
optVariants.locSol       = {'ipopt','sqpmethod'};
optVariants.plot         = {'true', 'false'};
optVariants.Sig          = {'const','dyn'};
optVariants.lamInit      = {'false','true'};
optVariants.term_eps     = {0};
optVariants.regParam     = {1e-4};

% extensions
optVariants.slack        = {'redSpace','standard'};     % reduced space?
optVariants.hessian      = {'standard'};                % Hessian approx?
optVariants.Hess         = {'standard'};
optVariants.parfor       = {'false','true'};            % parallel computing?
optVariants.DelUp        = {'true','false'};            % autoscaling for slacks?
optVariants.reuse        = {'false','true'};            % return problem formulation for reuse

% bi-level options
optVariants.innerAlg     = {'none','D-CG','D-ADMM'};
optVariants.rhoADM       = {2e-2};
optVariants.warmStart    = {'true', 'false'};
optVariants.innerIter    = {2400};


end

