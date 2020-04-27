% Solves a non-convex optimization problem in consensus form via the ALADIN
% algorithm
%
% in:  ffi:    Cell with local objective functions fi
%      hhi:    Cell with local inequality constraints hi
%      ggi:    Cell with local equality constraints gi
%      AA:     Cell with consensus matrices Ai
%
% out: xopt:   Optimal x vector
%      logg:   Struct, logging several values during the iteration process
%%------------------------------------------------------------------------
function [ sol ] = run_ALADINnew( sProb, opts )
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