function tests = OptProbsTest
    tests = functiontests(localfunctions);
end

% reset environment variables for running the tests
% restoredefaultpath;
% clear all;
% clc;

%% test IEEE118-bus OPF
function testOPFExample(testCase)
    run ../examples/optimal_power_flow/optimal_power_flow.m   
    assert(norm(vertcat(res_ALADIN.xxOpt{:}) - res_IPOPT.x,inf) < 1e-6, 'Out of tolerance for local minimizer!')
    
    close all;
end


%% test reactor-separator example
function testChemReacExample(testCase)
    run ../examples/chemical_reactor/reactor_separator_process.m
    assert(norm(full(sol.x)-vertcat(sol_ALADIN.xxOpt{:}),inf) < 1e-6, 'Out of tolerance for local minimizer!')
    
    close all;
end



