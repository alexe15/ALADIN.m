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

% check inputs
checkInput(sProb);

% set default options
opts       = setDefaultOpts(opts);

% timers
totTimer   = tic;
setupTimer = tic;

% set up local NLPs and sensitivities
sProb                = createLocSolAndSens(sProb, opts);
timers.setupT        = toc(setupTimer);

% run ALADIN iterations
[ sol, timers.iter ] = iterateAL( sProb, opts );

% total time
timers.totTime   = toc(totTimer);

% display timing
displayTimers(timers);
end