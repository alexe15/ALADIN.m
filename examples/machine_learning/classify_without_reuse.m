clear all;
import casadi.*;

data = importdata('ML_DATA.mat');

point = data.input;
class = data.class;
% connect point and their classes
set   = [point,class];


N     = size(point, 1);
n     = size(point, 2);
Nsubs = 10;
cap   = N/Nsubs;

gamma = 1;

w  = SX.sym('w', [n 1]);
xy = SX.sym('xy', [n+1 1]);

f  = 1/N*log(1+exp(-xy(n+1)*xy(1:n)'*w)) + gamma/(2*N)*w'*w;

eyebase = eye(n);
zerobase = zeros(n);
ML.AA{1} = repmat(eyebase, N-1, 1);

for i = 1:N
    ML.locFuns.ffi{i} = Function(['f' num2str(i)], {w,xy}, {f}); 
    ML.locFuns.ggi{i} = Function(['g' num2str(i)], {w,xy}, {[]});
    ML.locFuns.hhi{i} = Function(['h' num2str(i)], {w,xy}, {[]});
    
    % lower and upper boundary of variables will be set as default values
    if i > 1
        ML.AA{i} = [repmat(zerobase,i-2,1);-eyebase;repmat(zerobase,N-i,1)];
    end
    ML.zz0{i} = zeros(n,1);
    ML.p{i}   = [point(i,:)';class(i)];
    
    SSig{i}   = eye(n);
end

ML.lam0 = 1*ones(size(ML.AA{1},1),1);

% initialize the options for ALADIN
opts.rho = 1e3;
opts.mu = 1e4;
opts.maxiter = 20;
opts.term_eps = 0; % no termination criterion, stop after maxit

opts.reuse = 'true';
opts.plot = 'false';

sol_ML = run_ALADINnew(ML,opts);

%% in this section the data set will be divided into 10 groups
clear ML;
point = data.input;
class = data.class;

% the total data set is divided into 10 groups
Nsubs = 10;
cap   = N/Nsubs;

w  = SX.sym('w', [cap*n 1]);
xy = SX.sym('xy', [cap*(n+1) 1]);

% set up objective function and constraints
ff  = 0;
gg = [];
for i = 1:cap
    j   = (i-1)*n;
    k   = (i-1)*(n+1);
    ff  = ff + 1/N*log(1+exp(-xy(k+n+1)*xy(k+1:n)'*w(j+1:n))) +...
             gamma/(2*N)*w(j+1:n)'*w(j+1:n);
    if i > 1
        for p = 1:n
            gg = [gg; w(p)-w(j+p)];
        end
    end
end

% create elements used to set matrix A
eyebase = eye(n*cap);
zerobase = zeros(n*cap);
ML.AA{1} = repmat(eyebase, Nsubs-1, 1);
for i = 1:Nsubs
    ML.locFuns.ffi{i} = Function(['f' num2str(i)], {w,xy}, {ff}); 
    ML.locFuns.ggi{i} = Function(['g' num2str(i)], {w,xy}, {gg});
    ML.locFuns.hhi{i} = Function(['h' num2str(i)], {w,xy}, {[]});
    
    % lower and upper boundary of variables will be set as default values
    % set up consensus constraints
    if i > 1
        ML.AA{i} = [repmat(zerobase,i-2,1);-eyebase;repmat(zerobase,Nsubs-i,1)];
    end
    ML.zz0{i} = zeros(n*cap,1);
    points    = set((i-1)*cap + 1:cap, :);
    ML.p{i}   = reshape(points', [], 1);
    
    SSig{i}   = eye(n*cap);
end

ML.lam0 = 1*ones(size(ML.AA{1},1),1);

% initialize the options for ALADIN
opts.rho = 1e3;
opts.mu = 1e4;
opts.maxiter = 20;
opts.term_eps = 0; % no termination criterion, stop after maxit
opts.reuse = 'true';
opts.plot = 'true';

sol_ML_group = run_ALADINnew(ML,opts);