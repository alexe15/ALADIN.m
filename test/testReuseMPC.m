% reset envoronment variables for running the tests
clear all;
import casadi.*

%% test MPC with 'reuse' option for chemical reactor example
load('./problem_data/chemReact_MPC.mat')

Nmpc = 3;

% first solve with deactive reuse option
opts.reuse = 'false';
opts.plot  = 'false';
sol_ALADIN{1} = run_ALADIN(chem,opts);

for i = 2:Nmpc
    chem.zz0 = sol_ALADIN{i-1}.xxOpt;
    for j = 1:Nunit
        xx0{j} = sol_ALADIN{i-1}.xxOpt{j}(12+[1+(j-1)*4:j*4]);
    end
    chem.p = vertcat(xx0{:});
    sol_ALADIN{i} = run_ALADIN(chem, opts);
end

% solve with active reuse option
opts.reuse = 'true';
chem.p     = vertcat(x0{:});
for i = 1:Nunit
    chem.zz0{i}  = [repmat(vertcat(x0{:}),N,1); Qs(i)*ones(N,1)];
end
sol_ALADIN_re{1} = run_ALADIN(chem,opts);

for i = 2:Nmpc
    chem.zz0 = sol_ALADIN_re{i-1}.xxOpt;
    for j = 1:Nunit
        xx0{j} = sol_ALADIN_re{i-1}.xxOpt{j}(12+[1+(j-1)*4:j*4]);
    end
    
    % reuse problem formulation 
    fNames = fieldnames(sol_ALADIN_re{1}.problemForm);
    for j = 1:length(fNames)
       chem.(fNames{j}) = sol_ALADIN_re{i-1}.problemForm.(fNames{j});
    end
    
    
  %  chem.reuse = sol_ALADIN_re{i-1}.reuse;
    chem.p = vertcat(xx0{:});
    sol_ALADIN_re{i} = run_ALADIN(chem, opts);
end

% check whether solutions with/without resuing problem formulation are close enough 
for i = 1:Nmpc
    assert(norm(vertcat(sol_ALADIN{i}.xxOpt{:})-vertcat(sol_ALADIN_re{i}.xxOpt{:}),inf) < 1e-6, 'Out of tolerance for local minimizer!')
end

% check whether primal solution is close enough to centralized one

load('./problem_data/chemReact.mat')
res_IPOPT  = run_IPOPT(chem);

assert(norm(full(res_IPOPT.x)-vertcat(sol_ALADIN_re{1}.xxOpt{:}),inf) < 1e-6, 'Out of tolerance for local minimizer!')
close all;
    
