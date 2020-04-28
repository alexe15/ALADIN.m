function [sol, time] =run_sensor_network(N, sigma, parallelOpt)


sProb = setupSolver(N, sigma);
opts.parfor = parallelOpt;
timeALADIN = tic;
sol = run_ALADIN(sProb, opts);
time = toc(timeALADIN);
