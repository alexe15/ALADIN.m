clear all;
import casadi.*

p = gcp;
delete(p)

parpool;
load('./problem_data/SensorNetworkLocalizationProblemN10.mat');

opts.parfor = 'true';
time = tic;
sol_parfor = run_ALADINnew(sProb_test, opts);
time_parfor = toc(time);

opts.parfor = 'false';
time = tic;
sol_for = run_ALADINnew(sProb_test, opts);
time_for = toc(time);

assert(time_parfor < time_for, 'time needed for parallel evaluation of local problems is larger than time needed for central evaluation of local problems')