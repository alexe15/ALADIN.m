clear all
N = [5, 10, 15 , 20, 25, 30, 35, 40, 50, 60, 70, 80, 90, 100];
sigma = [0.5, 1, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5];

opts.maxiter = 5;

time = zeros(2, length(N));


for i = 1 : length(N)
    sProb = setupSolver(N(i), sigma(i));
    opts.parfor = 'true'; 

    time_parfor = tic;
    sol = run_ALADINnew(sProb, opts);
    time(1, i) = toc(time_parfor);

    time_for = tic;
    opts.parfor = 'false';
    sol = run_ALADINnew(sProb, opts);
    time(2, i) = toc(time_for);
end

figure 
plot(N, time(1, :))
title('runtime analysis')
hold on
plot(N, time(2, :))
hold off
legend('time parfor', 'time for')
xlabel('number of sensors')
ylabel('time [s]')