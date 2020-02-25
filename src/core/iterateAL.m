function [ sol, timers ] = iterateAL( sProb, opts )
%ITERATEAL Summary of this function goes here
NsubSys = length(sProb.AA);
Ncons   = size(sProb.AA{1},1);
initializeVariables;

iterTimer = tic;
i                   = 1;
while ((i <= opts.maxiter) && ((~logical(opts.term_eps)) || ...
                                      (logg.consViol(i) >= opts.term_eps)))
                                  
    % solve local NLPs and evaluate sensitivities                              
    [ iter.loc, timers ] = parallelStep( sProb, iter, timers, opts );

    % set up the Hessian of the coordination QP
    if strcmp( opts.Hess, 'BFGS' )
        sens.HHi = BFGS( sProb, iterates );
    end
    
    sensEval.HHi = blkdiag( HHiEval{:} );
    
    % set up and solve the coordination QP
    tic
    iter.lamOld      = iter.lam;
    if strcmp(opts.slack,'nonl') && strcmp(opts.innerAlg, 'none')
        [ HQP, gQP, AQP, bQP] = createCoordQPnLsl( sProb, iter );
        [delxs2, lamges]      = solveQP(HQP,gQP,AQP,bQP,opts.solveQP);    
        iter.delx             = delxs2(1:(end-Ncons)); 
    elseif strcmp(opts.innerAlg, 'none')
        [ HQP, gQP, AQP, bQP] = createCoordQP( sProb, iter );
        [delxs2, lamges]      = solveQP(HQP,gQP,AQP,bQP,opts.solveQP);  
        iter.ddelx            = decomposeX(delxs2,iter);
     %   iter.delx             = delxs2(1:(end-Ncons)); 
        iter.lam              = lamges(1:Ncons);
    end
    
    % solve coordination QP decentrally
    if ~strcmp(opts.innerAlg, 'none')
        % condense sensistivities locally 
        iter.loc.cond          = condenseLocally(sProb, iter);
        % solve condensed QP by decentralized CG/ADMM
        [ iter.llam, iter.lam, iter.comm ] = ...
                              solveQPdecNew(iter.loc.cond, iter.lam, opts);
       [ iter.llam, iter.lam ] = solveQPdecOld(iter.loc.cond, iter.lam, opts, iter, sProb );
        % expand again locally based on computed \lamda
        iter.ddelx             = expandLocally(iter.llam, iter.loc.cond);
    end        
    timers.QPtotTime      = timers.QPtotTime + toc;   
   
    % do a line search on the QP step?
    linS = false;
    if linS == true
        stepSizes.alpha   = lineSearch(Mfun, x ,delx);
    end
  
    % compute the ALADIN step
    iter.yyOld            = iter.yy; 
    [ iter.yy, iter.lam ] = computeALstep( iter );
    
    % rho update
    if iter.stepSizes.rho < opts.rhoMax
        iter.stepSizes.rho = iter.stepSizes.rho * opts.rhoUpdate;
    end
    % mu update
    if iter.stepSizes.mu < opts.muMax
        iter.stepSizes.mu  = iter.stepSizes.mu * opts.muUpdate;
    end
    
    % logging of variables?
    loggFl = true;
    if loggFl == true
        logValues;
    end
   
    % plot iterates?
    if opts.plot == true
       tic
       plotIterates;
       timers.plotTimer = timers.plotTimer + toc;
    end
    iterationResponse(i, opts, iter);
    i = i+1;
end
timers.iterTime = toc(iterTimer);


sol.xxOpt  = iter.yy;
sol.lamOpt = iter.lam;
sol.iter   = iter;


end

