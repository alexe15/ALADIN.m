function [sProb ] = setupSolver(N, sigma)

% general setup

n       = 4;   % dimension of design variables          
d       = 2;   % dimension of coordinate system 

% initialization of variables

y = cell(1, N);

y_sym = sym('y%d%d', [N n], 'real');
y_sym = y_sym';

for i = 1 : N
    y(i) = {y_sym(:, 1)};
end

% definition of estimated initial positions

 eta     = zeros(d, N);
 eta_bar = zeros(1, N);
 
 for i = 1 : N
     eta( :, i ) = [N * cos(2 * i * pi / 8) + normrnd(0, sigma) ; ...
                    N * sin(2 * i * pi / 8) + normrnd(0, sigma)];
     
     eta_bar(i)  = 2 * N * sin( pi / N) + normrnd(0, sigma);
 end

 % definition of objective functions

F = zeros(N, 1);
F = sym(F);

for i = 1 : N - 1
    F(i) = 1 / (4 * sigma^2) * ((y_sym(1, i) - eta(1, i))^2 + (y_sym(2, i) - eta(2, i))^2) ...
          + 1 / (4 * sigma^2) * ((y_sym(3, i) - eta(1, i + 1))^2 + (y_sym(4, i) - eta(2, i + 1))^2) ...
          + 1 / (2 * sigma^2) * (sqrt((y_sym(1, i) - y_sym(3, i))^2 + (y_sym(2, i) - y_sym(4, i))^2) - eta_bar(i))^2;

end


F(N) = 1 / (4 * sigma^2) * ((y_sym(1, N) - eta(1, N))^2 + (y_sym(2, N) - eta(2, N))^2) ...
    + 1 / (4 * sigma^2) * ((y_sym(3, N) - eta(1, 1))^2 + (y_sym(4, N) - eta(2, 1))^2) ...
    + 1 / (2 * sigma^2) * (sqrt((y_sym(1, N) - y_sym(3, N))^2 + (y_sym(2, N) - y_sym(4, N))^2) - eta_bar(N))^2;


% definition of inequality constraint

H = zeros(N, 1);
H = sym(H);
 
for i = 1 : N
    H(i) = (sqrt((y_sym(1, i) - y_sym(3, i))^2 + (y_sym(2, i) - y_sym(4, i))^2) - eta_bar(i))^2;
end

I = [1, 0; 0, 1];
A0 = zeros(2*N, n);
% A1 = A0;
% A1(end-1:end, 1:2) = -I;
% A1(1:2, 3:4) = I;
% 
% A2(1:2, 1:2) = -I;
% A2(3:4, 3:4) = I;
% 
% A3(3:4, 1:2) = I;
% A3(5:6, 3:4) = -I;
% 
% A4(5:6, 1:2) = I;
% A4(7:8, 3:4) = -I;
% 
% A0(3:4, 3:4) = I;

% definition of coupling matrix

%A1 = [ 0,  0, -1,  0;...
%       0,  0,  0, -1; ...
%       1,  0,  0,  0; ...
%       0,  1,  0,  0];
   
%A2 = [ 1,  0,  0,  0;...
%       0,  1,  0,  0; ...
%       0,  0, -1,  0; ...
%       0,  0,  0, -1];

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

% for i = 2 : 2 : N
%    AA(i) = mat2cell(A2, n, n);
% end


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
    sProb.locFuns.ffi(i) = {matlabFunction(F(i), 'Vars', {y_sym(:, i)})} ;
    sProb.locFuns.hhi(i) = {matlabFunction(H(i), 'Vars', {y_sym(:, i)})} ;
end

sProb.AA = AA;
sProb.zz0 = zz0;

