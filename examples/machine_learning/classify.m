clear all;
import casadi.*;

data = importdata('ML_DATA.mat');

point = data.input;
class = data.class;


N = size(point, 1);
n = size(point, 2);

gamma = 1;

AA{1} = [1,0;0,1];
AA{2} = [-1,0;0,-1];

for i = 1:2
    w{i}  = SX.sym(['w' num2str(i)], [n 1]);
    xy{i} = SX.sym(['xy' num2str(i)], [n+1 1]);
    f{i}  = 1/N*log(1+exp(-xy{i}(3)*xy{i}(1:2)'*w{i})) + gamma/(2*N)*w{i}'*w{i};
end

for i = 1:2
    ML.locFuns.ffi{i} = Function(['f' num2str(i)], {w{i},xy{i}}, {f{i}}); 
    ML.locFuns.ggi{i} = Function(['g' num2str(i)], {w{i},xy{i}}, {[]});
    ML.locFuns.hhi{i} = Function(['h' num2str(i)], {w{i},xy{i}}, {[]});
    
    % lower and upper boundary of variables will be set as default values
    ML.AA{i}  = AA{i}; 
    ML.zz0{i} = zeros(n,1);
    ML.p{i}   = [point(i,:)';class(i)];
    
    SSig{i}   = eye(n);
end

ML.lam0 = 1*ones(size(AA{1},1),1);

% initialize the options for ALADIN
opts.rho = 1e3;
opts.mu = 1e4;
opts.maxit = 100;
opts.term_eps = 0; % no termination criterion, stop after maxit
opts.reuse = 'true';
opts.plot = 'false';

sol_ML = run_ALADIN(ML,opts);

eyebase = eye(n);
zerobase = zeros(n);
ML.AA{1} = repmat(eyebase, N-1, 1);
ML.Mfun  = sol_ML.problemForm.Mfun;
for i = 1:N
    % copy formulation of first subsystem to other subsystems
    ML.nnlp{i}           = sol_ML.problemForm.nnlp{1};
    ML.sens.gg{i}        = sol_ML.problemForm.sens.gg{1};
    ML.sens.JJac{i}      = sol_ML.problemForm.sens.JJac{1};
    ML.sens.HH{i}        = sol_ML.problemForm.sens.HH{1};
    ML.locFunsCas.ggi{i} = sol_ML.problemForm.locFunsCas.ggi{1};
    ML.locFunsCas.hhi{i} = sol_ML.problemForm.locFunsCas.hhi{1};
    ML.locFunsCas.ffi{i} = sol_ML.problemForm.locFunsCas.ffi{1};
    ML.gBounds.llb{i}    = sol_ML.problemForm.gBounds.llb{1};
    ML.gBounds.uub{i}    = sol_ML.problemForm.gBounds.uub{1};
    
    ML.locFuns.ffi{i}    = ML.locFuns.ffi{1};
    ML.locFuns.ggi{i}    = ML.locFuns.ggi{1};
    ML.locFuns.hhi{i}    = ML.locFuns.hhi{1};
    
    % define matrix A    
    if i > 1
        ML.AA{i} = [repmat(zerobase,i-2,1);-eyebase;repmat(zerobase,N-i,1)];
    end
    
    % give paramter to every subsystem
    ML.p{i}   = [point(i,:)';class(i)];
    ML.zz0{i} = zeros(n,1);
    ML.zz0{i} = zeros(n,1);
    
    SSig{i}   = eye(n);
end
ML.lam0 = 1*ones(size(ML.AA{1},1),1);

sol = run_ALADIN(ML, opts)