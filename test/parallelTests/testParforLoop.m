clear all;
import casadi.*

p = gcp;
delete(p)

parpool;
load('.././problem_data/SensorNetworkLocalizationProblemN10.mat');

opts.maxiter = 3;
opts.parfor = 'true';
time = tic;
sol_parfor_1 = run_ALADIN(sProb_test, opts);
time_parfor_1 = toc(time);

opts.maxiter = 30;
opts.parfor = 'true';
time = tic;
sol_parfor = run_ALADIN(sProb_test, opts);
time_parfor = toc(time);

opts.parfor = 'false';
time = tic;
sol_for = run_ALADIN(sProb_test, opts);
time_for = toc(time);

% check, in how far the parallel option is faster than the central option
assert(time_parfor < time_for, 'time needed for parallel evaluation of local problems is larger than time needed for central evaluation of local problems')

% check, if obtained results are the same
assert(norm(vertcat(sol_parfor.xxOpt{:}) - vertcat(sol_for.xxOpt{:}), inf) < 1e-6, 'solutions obtained by parfor loop and for loop do not agree')

% check BFGS option for parfor
opts.Hess = 'BFGS';
opts.maxiter = 40;
opts.parfor = 'true';
time = tic;
sol_parfor = run_ALADIN(sProb_test, opts);
time_parfor = toc(time);

opts.parfor = 'false';
time = tic;
sol_for = run_ALADIN(sProb_test, opts);
time_for = toc(time);

% check, in how far the parallel option is faster than the central option
assert(time_parfor < time_for, 'time needed for parallel evaluation of local problems is larger than time needed for central evaluation of local problems for BFGS')

% check, if obtained results are the same
assert(norm(vertcat(sol_parfor.xxOpt{:}) - vertcat(sol_for.xxOpt{:}), inf) < 1e-6, 'solutions obtained by parfor loop and for loop do not agree for BFGS')
