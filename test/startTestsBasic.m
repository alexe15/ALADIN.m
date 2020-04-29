% run the most important tests for fast intermediate testing

% for even faster testing just use one of the tests below, I usually use
% the testBFGS test for 30bus

t1 = runtests('OptProbsTest');
t2 = runtests('practicalProbsTest/testOPFExample');
t3 = runtests('testBFGS/testBFGSForOPF30bus');
t4 = runtests('testBiLevelAL');


cd parallelTests
tp = runtests('testParforLoop');
cd ..

% show results
table([t1 t2 t3 t4 tp])