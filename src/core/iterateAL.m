function [ sol, timers ] = iterateAL( sProb, opts, timers )
%ITERATEAL Summary of this function goes here
NsubSys = length(sProb.AA);
Ncons   = size(sProb.AA{1},1);
initializeVariables;

iterTimer = tic;
i         = 1;
iter.i    = 1;
while (i <= opts.maxiter) && ( (strcmp(opts.term_eps,'false')) || (iter.logg.consViol(i) >= opts.term_eps))            
    % solve local NLPs and evaluate sensitivities
   if (strcmp(opts.parfor, 'true' ))
        [ iter.loc, timers, opts ] = parallelStepDecentral( sProb, iter, timers, opts );
   else
        [ timers, opts, iter ] = parallelStepCentral( sProb, iter, timers, opts );
   end
    % set up and solve the coordination QP
    tic
    iter = setup_and_solve_QP(sProb, iter, opts, i);
    timers.QPtotTime      = timers.QPtotTime + toc;   
   
    % do a line search on the QP step?
    linS = false;
    if linS == true
        stepSizes.alpha   = lineSearch(Mfun, x ,delx);
    end
  
    % compute the ALADIN step
    iter.yyOld  = iter.yy; 
    [ iter.yy, iter.lam ] = computeALstep( iter );
    
    % rho update
    if iter.stepSizes.rho < opts.rhoMax
        iter.stepSizes.rho = iter.stepSizes.rho * opts.rhoUpdate;
    end
    % mu update
    if iter.stepSizes.mu < opts.muMax && strcmp(opts.DelUp, 'false')
        opts.Del  = opts.Del * 1/opts.muUpdate;
    end
    
    % logging of variables?
    loggFl = true;
    if loggFl
        logValues;
    end
   
    % plot iterates?
%     if opts.plot
%        tic
%        plotIterates;
%        timers.plotTimer = timers.plotTimer + toc;
%     end
    
    i = i+1;
    iter.i = i;
end
timers.iterTime = toc(iterTimer);

sol.xxOpt  = iter.yy;
sol.lamOpt = iter.lam;
sol.iter   = iter;

end

function iter = setup_and_solve_QP(prob, iter, opts, i)
    iter.lamOld = iter.lam;
    if strcmp(opts.innerAlg, 'none')
        % update scaling matrix for consensus violation slack
        if strcmp(opts.DelUp,'true') 
            if i > 2                            
                [opts.Del, iter.consViol] = computeDynSig(opts.Del,...
                         [prob.AA{:}]*vertcat(iter.yy{:}),iter.consViol, 'Del');
            else
                iter.consViol = [prob.AA{:}]*vertcat(iter.yy{:});
            end
        end
        % set up and solve coordination QP
        [ HQP, gQP, AQP, bQP]   = createCoordQP( prob, iter, opts );
        [ xs, lamTot]           = solveQP(HQP, gQP, AQP, bQP, opts.solveQP);    
        [ iter.ddelx, iter.lam ] = decomposeX(xs, lamTot, iter, opts);
    else 
        % solve coordination QP decentrally
        iter.loc.cond           = condenseLocally(prob, iter);
        % solve condensed QP by decentralized CG/ADMM
        [ iter.llam, iter.lam, iter.comm ] = solveQPdecNew(iter.loc.cond, iter.lam, opts);
        % expand again locally based on computed \lamda
        iter.ddelx = expandLocally(iter.llam, iter.loc.cond);
    end        
end

