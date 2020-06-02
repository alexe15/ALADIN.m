% run tests, the ones possible in parallel, the oters in serial

% run serial tests in parallel
serTest = runtests('UseParallel',true);

% run parallel tests in serial
cd parallelTests\
parTest = runtests;
cd ..

% display results
table(serTest)
table(parTest)
