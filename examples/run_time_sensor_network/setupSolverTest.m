function [sProb ] = setupSolverTest(N, sigma)

% general setup

n       = 4;   % dimension of design variables          
d       = 2;   % dimension of coordinate system 

% initialization of variables

y = sym('y%d%d', [N n], 'real');
y = y';

% definition of estimated initial positions

 eta     = zeros(d, N + 1);
 eta_bar = zeros(1, N);
 
 for i = 1 : N
     eta( :, i ) = [N * cos(2 * i * pi / 8) + normrnd(0, sigma) ; ...
                    N * sin(2 * i * pi / 8) + normrnd(0, sigma)];
     
     eta_bar(i)  = 2 * N * sin( pi / N) + normrnd(0, sigma);
 end
 
 eta(:, N + 1) = eta(:, 1);

 % definition of objective functions

F = zeros(N, 1);
F = sym(F);

F(:) = 1 / (4 * sigma^2) * ((y(1, :) - eta(1, 1 : N)).^2 + (y(2, :) - eta(2, 1 : N)).^2) ...
     + 1 / (4 * sigma^2) * ((y(3, :) - eta(1, 2 : end)).^2 + (y(4, :) - eta(2, 2 : end)).^2) ...
     + 1 / (2 * sigma^2) * (sqrt((y(1, :) - y(3, :)).^2 + (y(2, :) - y(4, :)).^2) - eta_bar(:)').^2;


% definition of inequality constraint

H = zeros(N, 1);
H = sym(H);
 
for i = 1 : N
    H(i) = (sqrt((y(1, i) - y(3, i))^2 + (y(2, i) - y(4, i))^2) - eta_bar(i))^2;
end

I = [1, 0; 0, 1];
A0 = zeros(2*N, n);

sProb.AA = cell(1, N);

A_1 = A0;
A_1(1:2, 3:4) = I;
A_1(2*N - 1: 2*N, 1:2) = -I;

AA(1) = mat2cell(A_1, 2 * N, n);


for i = 2 : 1 : N
    A_i = A0;
    A_i(2*(i-2) + 1 : 2*(i-2) + 2, 1:2) = -I;
    A_i(2*i - 1: 2*i, 3:4 ) = I;
    AA(i) = mat2cell(A_i, 2*N, n);
end

% start value for optimization

initial_position = zeros(2, N);
for i = 1  : N
    initial_position(1, i) = N * cos( 2 * i * pi / N ) + normrnd(0, sigma);
    initial_position(2, i) = N * sin( 2 * i * pi / N ) + normrnd(0, sigma);
end

zz0 = cell(1, N);

for i = 1 : N-1
    zz0(i) = {[initial_position(:, i); initial_position(:, i + 1)]};
end

zz0(N) = {[initial_position(:, N); initial_position(:, 1)]};


%% setting up solver

% set search area
sProb.llbx = cell(1, N);
sProb.uubx = cell(1, N);
for i = 1 : N
    sProb.llbx(i) = mat2cell([-inf; -inf; -inf; -inf], 4, 1);
    sProb.uubx(i) = mat2cell([ inf;  inf;  inf;  inf], 4, 1);
end

% handover of functions
sProb.locFuns.ffi          = cell(1, N);
sProb.locFuns.hhi          = cell(1, N);


for i = 1 : N
    sProb.locFuns.ffi(i) = {matlabFunction(F(i), 'Vars', {y(:, i)})} ;
    sProb.locFuns.hhi(i) = {matlabFunction(H(i), 'Vars', {y(:, i)})} ;
end


sProb.AA = AA;
sProb.zz0 = zz0;
