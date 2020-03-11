# Example for the usage of ALADIN with parfor option
We consider the sensor network localization problem for the usage of the ALADIN solver presented in the original [ALADIN publication](https://www.researchgate.net/publication/299465495_An_Augmented_Lagrangian_Based_Algorithm_for_Distributed_NonConvex_Optimization). The problem is stated as follows:

## Problem setup

Declataion of variables:

Let $N$ be the number of agents, let $\chi_i \in \mathbb{R}^2$ be the unknown position of the $i$-th sensor, let $\eta_i$ be its estimated position, let $\xi_i$be the position of senosor $i+1$ estimated by sensor $i$ let $\bar{\eta_i}$ be the estimated distance between sensor $i$ and its neighbours.    

The measurement error is given by $\eta_i - \chi_i$ and is assumed to be Gaussian distributed with variance $\sigma_i^2 I_{2 \times 2}$. We further denote the measured distance between sensor $i$ and sensor $i + 1$ by $\bar{\eta_i}$.


If we define the design variable as $x_i = (\chi_i^\top, \xi_i^\top)^\top \in \mathbb{R}^4$ then we obtain the overall problem


$\min_x \sum_{i = 1}^N f_i(x_i)\quad \text{ s.t. }\quad h_i(x_i) \leq 0\quad \text{ and } \quad\xi_i = \chi_{i+1}  \quad \forall i \in \{1, \cdots, N\}$

with 
  
$f_i(x_i)=\frac{1}{4\sigma_i^2}\vert\vert\chi_i - \eta_i\vert\vert_2^2 + \frac{1}{4\sigma_{i+1}^2}\vert\vert\xi_i - \eta_{i+1}\vert\vert_2^2 + \frac{1}{2\sigma_{i+1}^2}(\vert\vert\chi_i - \xi_i\vert\vert_2^2  - \bar{\eta}_i)^2$

$h_i(x_i) = (\vert\vert\chi_i - \xi_i\vert\vert_2 - \bar{\eta_i})^2 - \bar{\sigma_i}^2$   

$\xi_i = \chi_{i+1} \quad \forall i \in \{1, \cdots, N\}$

### Implementation

For the implementaiton, firstly the problem needs to be defined in a way that is compatible to the ALADIN solver:
```matlab
function [sProb] = setupSolver(N, sigma)

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


% definition of coupling matrix

A1 = [ 0,  0, -1,  0;...
       0,  0,  0, -1; ...
       1,  0,  0,  0; ...
       0,  1,  0,  0];
   
A2 = [ 1,  0,  0,  0;...
       0,  1,  0,  0; ...
       0,  0, -1,  0; ...
       0,  0,  0, -1];

sProb.AA = cell(1, N);

for i = 1 : 2 : N
    AA(i) = mat2cell(A1, n, n);
end

for i = 2 : 2 : N
    AA(i) = mat2cell(A2, n, n);
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
sProb.locFuns.ffifun          = cell(1, N);
sProb.locFuns.hhifun          = cell(1, N);


for i = 1 : N
    sProb.locFuns.ffifun(i) = {matlabFunction(F(i), 'Vars', {y_sym(:, i)})} ;
    sProb.locFuns.hhifun(i) = {matlabFunction(H(i), 'Vars', {y_sym(:, i)})} ;
end

sProb.AA = AA;
sProb.zz0 = zz0;

```
### Runtime Analysis
```matlab
N = [5, 10, 15 , 20, 25, 30, 35, 40, 50, 60, 70, 80, 90, 100];
sigma = [0.5, 1, 1.5, 2, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5];

time = zeros(2, length(N));
for i = 1 : length(N)
    sProb = setupSolver(N(i), sigma(i));
    opts.parfor = 'true' 

    time_parfor = tic;
    sol = run_ALADINnew(sProb, opts);
    time(1, i) = toc(time_parfor);

    time_for = tic;
    sol = run_ALADINnew(sProb, opts);
    time(2, i) = toc(time_for);
end

figure 
plot(N, time(1, :))
title('runtime analysis')
hold on
plot(N, time(2, :))
hold off
legend('decentral optimization', 'central optimization')

```
### Result
The runtime result can be obtained from the following figure. 

 ![Robot](./figures/run_time_comparison.png)

Thus, for the case of the senor network localization problem a significant runtime improvement can be observed when the parfor option is set. Nonetheless it needs to be mentioned that an improvement on the runtime cannot always be achieved for every problem setup using the parfor option. In general, parfor is useful when the number of local optimization problems is large and the time for solving each of the local  optimizationproblems is relatively long. For details, see [decide when to use parfor](https://de.mathworks.com/help/parallel-computing/decide-when-to-use-parfor.html;jsessionid=4c67399db5b15c1b7951a965e1c7)