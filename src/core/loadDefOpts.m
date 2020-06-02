
function [ optVariants ] = loadDefOpts( opts )

if strcmp(opts.alg, 'ALADIN')
    % define possible options and default values (first entry of cells)
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
    optVariants.stepSize     = {1};
    

    % extensions
    optVariants.slack        = {'standard','redSpace'};   % reduced space?
    optVariants.hessian      = {'standard'};             % Hessian approx?
    optVariants.Hess         = {'standard','DBFGS','BFGS'};
    optVariants.BFGSinit     = {'ident','exact'};
    optVariants.parfor       = {'false','true'};         % parallel computing?
    optVariants.DelUp        = {'false','true'};         % autoscaling for slacks?
    optVariants.reuse        = {'false','true'};         % return problem formulation for reuse
    optVariants.commCount    = {'false','true'};         % forward communication count

    % bi-level options
    optVariants.innerAlg     = {'none','D-CG','D-ADMM'};
    optVariants.rhoADM       = {2e-2};
    optVariants.warmStart    = {'true', 'false'};
    optVariants.innerIter    = {200};

    optVariants.Alg          = {'ALADIN'};
    
elseif strcmp(opts.alg, 'ADMM')
    
    optVariants.rho0         = {1e2};
    optVariants.scaling      = {'false','true'};   
    optVariants.maxiter      = {30};
    optVariants.rhoUpdate    = {'false','true'};   
    optVariants.plot         = {'true', 'false'};
    optVariants.commCount    = {'false','true'};   
    optVariants.solveQP      = {'MA57','ipopt','pinv','linsolve','sparseBs','MOSEK','quadprog'};
    optVariants.locSol       = {'ipopt','sqpmethod'};
    optVariants.innerAlg     = {'none'};
    optVariants.term_eps     = {0};
    
    optVariants.Alg          = {'ADMM'};
end
end

