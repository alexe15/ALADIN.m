function tests = OptProbsTest

    tests = functiontests(localfunctions);
    
end

% reset environment variables for running the tests
% restoredefaultpath;
% clear all;
% clc;

%% test first optimization example
function testMainExample(testCase)

    run ../examples/example_main.m                          
    assert(full(norm(sol.x -xoptAL,inf)) < 1e-6, 'Out of tolerance for local minimizer!')
    
    close all;
end

%% test Rosenbrock example
function testRosenbrock(TestRosenbrock)

    run ../examples/rosenbrock_example.m
    assert(full(norm(sol.x -xoptAL,inf)) < 1e-6, 'Out of tolerance for local minimizer!')
    
    close all;
end

%% test Beale's problem example
function testBealeProblem(TestBealeProblem)
        
    run ../examples/beale_example.m
    assert(full(norm(sol.x -xoptAL,inf)) < 1e-6, 'Out of tolerance for local minimizer!')

    close all;
end

%% test Mishra's Bird example
function testMishrasBirdExample(TestMishrasBird)


    run ../examples/mishras_bird_example.m
    assert(full(norm(sol.x -xoptAL,inf)) < 1e-1, 'Out of tolerance for local minimizer!')
   
   close all;
end

%% test Rastrigin Problem
function testRastriginProblem(TestRastriginProblem)


    run ../examples/rastrigin_example.m
    assert(full(norm(sol.x -xoptAL,inf)) < 1e-1, 'Out of tolerance for local minimizer!')

    close all;
end

