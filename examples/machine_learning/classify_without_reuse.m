clear all;
import casadi.*;

data = importdata('ML_DATA.mat'); % import data set

point = data.input; % defeine data
class = data.class; % define label
% connect point and their label
set   = [point,class];


N     = size(point, 1); % number of input data
nx    = size(point, 2); % dimension of input data
Nsubs = 10; % number of groups
cap   = N/Nsubs;
gamma = 1; % choose hyperparameter gamma

w  = SX.sym('w', [nx 1]); % decision variable
xy = SX.sym('xy', [nx+1 1]); % data and label

f  = 1/N*log(1+exp(-xy(nx+1)*xy(1:nx)'*w)) + gamma/(2*N)*w'*w;

eyebase = eye(nx);
zerobase = zeros(nx);
ML.AA{1} = repmat(eyebase, N-1, 1);

for i = 1:N
    ML.locFuns.ffi{i} = Function(['f' num2str(i)], {w,xy}, {f}); 
    ML.locFuns.ggi{i} = Function(['g' num2str(i)], {w,xy}, {[]});
    ML.locFuns.hhi{i} = Function(['h' num2str(i)], {w,xy}, {[]});
    
    % lower and upper boundary of variables will be set as default values
    if i > 1
        ML.AA{i} = [repmat(zerobase,i-2,1);-eyebase;repmat(zerobase,N-i,1)];
    end
    ML.zz0{i} = zeros(nx,1);
    ML.p{i}   = [point(i,:)';class(i)];
    
end

ML.lam0 = 1*ones(size(ML.AA{1},1),1);

% initialize the options for ALADIN
opts.rho = 1e3;
opts.mu = 1e4;
opts.maxiter = 20;
opts.term_eps = 0; % no termination criterion, stop after maxit

opts.reuse = 'true';
opts.plot = 'false';

sol_ML = run_ALADIN(ML,opts);

%% in this section the data set will be divided into 10 groups
clear ML;
point = data.input;
class = data.class;

% the total data set is divided into 10 groups
Nsubs = 10;
cap   = N/Nsubs;

w  = SX.sym('w', [cap*nx 1]); % decision variable
xy = SX.sym('xy', [cap*(nx+1) 1]); % data and label

% set up objective function and constraints
ff  = 0;
gg = [];
for i = 1:cap
    j   = (i-1)*nx;
    k   = (i-1)*(nx+1);
    ff  = ff + 1/N*log(1+exp(-xy(k+nx+1)*xy(k+1:nx)'*w(j+1:nx))) +...
             gamma/(2*N)*w(j+1:nx)'*w(j+1:nx);
    if i > 1
        for p = 1:nx
            gg = [gg; w(p)-w(j+p)]; 
        end
    end
end

% create elements used to set matrix A
eyebase = eye(nx*cap);
zerobase = zeros(nx*cap);
% set up consensus constraints
AA{1} = repmat(eyebase, Nsubs-1, 1);
for i = 2:Nsubs
    AA{i} = [repmat(zerobase,i-2,1);-eyebase;repmat(zerobase,Nsubs-i,1)];
end

for i = 1:Nsubs
    ML.locFuns.ffi{i} = Function(['f' num2str(i)], {w,xy}, {ff}); 
    ML.locFuns.ggi{i} = Function(['g' num2str(i)], {w,xy}, {gg});
    ML.locFuns.hhi{i} = Function(['h' num2str(i)], {w,xy}, {[]});
    
    % lower and upper boundary of variables will be set as default values
    ML.AA{i} = AA{i};
    ML.zz0{i} = zeros(nx*cap,1);
    ML.p{i}   = reshape(set((i-1)*cap + 1:cap, :)', [], 1);
end

ML.lam0 = 1*ones(size(ML.AA{1},1),1);

% initialize the options for ALADIN
opts.rho = 1e3;
opts.mu = 1e4;
opts.maxiter = 10;
opts.term_eps = 0; % no termination criterion, stop after maxit
opts.plot = 'true';

sol_ML_group = run_ALADIN(ML,opts);