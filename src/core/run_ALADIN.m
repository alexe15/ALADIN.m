% Solves a non-convex optimization problem via ALADIN and bi-level ALADIN 
% in a distributed/decentralized fashion.
%
% in:  sProb and opts struct containing a problem formulation in 
%      affinely-coupled separable form and solver options
% out: Struct containig optimal primal/dual solution and logging
%      information
%
% Checkout https://alexe15.github.io/ALADIN.m/ for detailed information.

function [ sol ] = run_ALADIN( sProb, opts )
import casadi.*
opts.sym   = @SX.sym;
opts.alg   = 'ALADIN';

% set constraints to empty functions/default initial guess
sProb      = setDefaultVals(sProb);

% set default options
opts       = setDefaultOpts(sProb, opts);

% check inputs
checkInput(sProb);

% timers
totTimer   = tic;
setupTimer = tic;

% check whether problem setup is present already
if ~isfield(sProb, 'nnlp') || ~isfield(sProb, 'sens') || ...
        ~isfield(sProb, 'locFunsCas') ||  ~isfield(sProb, 'gBounds')
    sProb            = createLocSolAndSens(sProb, opts);   
end
timers.setupT        = toc(setupTimer);

% give problem formulation back
if strcmp(opts.reuse, 'true')
    sProbback;
end

% run ALADIN iterations
[ sol, timers ] = iterateAL( sProb, opts, timers );

% total time
timers.totTime  = toc(totTimer);
sol.timers = timers;

% display solver output and timing
dispSummary(size(sol.iter.logg.X,2), opts, sol.iter);
displayTimers(timers, opts);

% display comunication
if strcmp(opts.commCount, 'true')
    displayComm(sol.iter.comm, opts.innerAlg);
end

if strcmp(opts.reuse, 'true')
    sol.problemForm = problemForm;
end

end