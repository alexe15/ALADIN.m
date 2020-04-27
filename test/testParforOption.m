clear all;
clc;

% load problem (sensor network localization problem)
load('./problem_data/SensorNetworkLocalizationProblemN10.mat');


% set up parpool
p = gcp;
delete(p)
parpool;

% pre_test
opts.maxiter = 1;
opts.parfor = 'true';
time = tic;
sol_parfor = run_ALADINnew(sProb_test, opts);
time_parfor = toc(time);


%% default settings

opts.maxiter = 30;
opts.parfor = 'true';
time = tic;
sol_parfor = run_ALADINnew(sProb_test, opts);
time_parfor = toc(time);

opts.parfor = 'false';
time = tic;
sol_for = run_ALADINnew(sProb_test, opts);
time_for = toc(time);

% check, in how far the parallel option is faster than the central option
assert(time_parfor < time_for, 'time needed for parallel evaluation of local problems is larger than time needed for central evaluation of local problems - default')

% check, if obtained results are the same
assert(norm(vertcat(sol_parfor.xxOpt{:}) - vertcat(sol_for.xxOpt{:}), inf) < 1e-6, 'solutions obtained by parfor loop and for loop do not agree - default')
 



%% dynamically changing sigma
opts.Sig = 'dyn';

opts.parfor = 'true';
time = tic;
sol_parfor = run_ALADINnew(sProb_test, opts);
time_parfor = toc(time);

opts.parfor = 'false';
time = tic;
sol_for = run_ALADINnew(sProb_test, opts);
time_for = toc(time);

% check, in how far the parallel option is faster than the central option
assert(time_parfor < time_for, 'time needed for parallel evaluation of local problems is larger than time needed for central evaluation of local problems - dyn sigma')

% check, if obtained results are the same
assert(norm(vertcat(sol_parfor.xxOpt{:}) - vertcat(sol_for.xxOpt{:}), inf) < 1e-6, 'solutions obtained by parfor loop and for loop do not agree - dyn sigma')
 



%% BFGS

clear opts
opts.Hess = 'BFGS';
opts.BFGSinit = 'ident'

opts.parfor = 'true';
time = tic;
sol_parfor = run_ALADINnew(sProb_test, opts);
time_parfor = toc(time);

opts.parfor = 'false';
time = tic;
sol_for = run_ALADINnew(sProb_test, opts);
time_for = toc(time);

% check, in how far the parallel option is faster than the central option
assert(time_parfor < time_for, 'time needed for parallel evaluation of local problems is larger than time needed for central evaluation of local problems - BFGS - ident')

% check, if obtained results are the same
assert(norm(vertcat(sol_parfor.xxOpt{:}) - vertcat(sol_for.xxOpt{:}), inf) < 1e-6, 'solutions obtained by parfor loop and for loop do not agree - BFGS ident')
 

clear opts
opts.Hess = 'BFGS';
opts.BFGSinit = 'exact';

opts.parfor = 'true';
time = tic;
sol_parfor = run_ALADINnew(sProb_test, opts);
time_parfor = toc(time);

opts.parfor = 'false';
time = tic;
sol_for = run_ALADINnew(sProb_test, opts);
time_for = toc(time);

% check, in how far the parallel option is faster than the central option
assert(time_parfor < time_for, 'time needed for parallel evaluation of local problems is larger than time needed for central evaluation of local problems - BFGS - exact')

% check, if obtained results are the same
assert(norm(vertcat(sol_parfor.xxOpt{:}) - vertcat(sol_for.xxOpt{:}), inf) < 1e-6, 'solutions obtained by parfor loop and for loop do not agree - BFGS exact')
 



%% DBFGS

clear opts
opts.Hess = 'DBFGS';
opts.BFGSinit = 'ident';

opts.parfor = 'true';
time = tic;
sol_parfor = run_ALADINnew(sProb_test, opts);
time_parfor = toc(time);

opts.parfor = 'false';
time = tic;
sol_for = run_ALADINnew(sProb_test, opts);
time_for = toc(time);

% check, in how far the parallel option is faster than the central option
assert(time_parfor < time_for, 'time needed for parallel evaluation of local problems is larger than time needed for central evaluation of local problems - DBFGS - ident')

% check, if obtained results are the same
assert(norm(vertcat(sol_parfor.xxOpt{:}) - vertcat(sol_for.xxOpt{:}), inf) < 1e-6, 'solutions obtained by parfor loop and for loop do not agree - DBFGS ident')
 

clear opts
opts.Hess = 'DBFGS';
opts.BFGSinit = 'exact';

opts.parfor = 'true';
time = tic;
sol_parfor = run_ALADINnew(sProb_test, opts);
time_parfor = toc(time);

opts.parfor = 'false';
time = tic;
sol_for = run_ALADINnew(sProb_test, opts);
time_for = toc(time);

% check, in how far the parallel option is faster than the central option
assert(time_parfor < time_for, 'time needed for parallel evaluation of local problems is larger than time needed for central evaluation of local problems - DBFGS - exact')

% check, if obtained results are the same
assert(norm(vertcat(sol_parfor.xxOpt{:}) - vertcat(sol_for.xxOpt{:}), inf) < 1e-6, 'solutions obtained by parfor loop and for loop do not agree - DBFGS exact')




%% communication xx and gradient

clear opts
opts.commCount = 'true';
opts.innerAlg = 'none';

opts.parfor = 'true';
time = tic;
sol_parfor = run_ALADINnew(sProb_test, opts);
time_parfor = toc(time);

opts.parfor = 'false';
time = tic;
sol_for = run_ALADINnew(sProb_test, opts);
time_for = toc(time);

% check, in how far the parallel option is faster than the central option
assert(time_parfor < time_for, 'time needed for parallel evaluation of local problems is larger than time needed for central evaluation of local problems - communication')

% check, if obtained results are the same
assert(norm(vertcat(sol_parfor.xxOpt{:}) - vertcat(sol_for.xxOpt{:}), inf) < 1e-6, 'solutions obtained by parfor loop and for loop do not agree - communication')




%% reduced Space

clear opts
opts.slack = 'redSpace';
opts.innerAlg = 'none';

opts.parfor = 'true';
time = tic;
sol_parfor = run_ALADINnew(sProb_test, opts);
time_parfor = toc(time);

opts.parfor = 'false';
time = tic;
sol_for = run_ALADINnew(sProb_test, opts);
time_for = toc(time);

% check, in how far the parallel option is faster than the central option
assert(time_parfor < time_for, 'time needed for parallel evaluation of local problems is larger than time needed for central evaluation of local problems - reduced Space')

% check, if obtained results are the same
assert(norm(vertcat(sol_parfor.xxOpt{:}) - vertcat(sol_for.xxOpt{:}), inf) < 1e-6, 'solutions obtained by parfor loop and for loop do not agree - reduced Space')


%% reduced Space. opts.reg = true

clear opts
opts.reg = 'true';

opts.parfor = 'true';
time = tic;
sol_parfor = run_ALADINnew(sProb_test, opts);
time_parfor = toc(time);

opts.parfor = 'false';
time = tic;
sol_for = run_ALADINnew(sProb_test, opts);
time_for = toc(time);

% check, in how far the parallel option is faster than the central option
assert(time_parfor < time_for, 'time needed for parallel evaluation of local problems is larger than time needed for central evaluation of local problems - opts.reg = true')

% check, if obtained results are the same
assert(norm(vertcat(sol_parfor.xxOpt{:}) - vertcat(sol_for.xxOpt{:}), inf) < 1e-6, 'solutions obtained by parfor loop and for loop do not agree - opts.reg = true')


