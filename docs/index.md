# ALADIN-M

ALADIN-M is a barebone implementation of the ALADIN algorithm with extensions including a set of application examples from different engineering fields.

## Getting started
### Requirements
- MATLAB
- [CasADi](https://web.casadi.org/get/) 
- MATLAB symbolic toolbox (only for examples)

The current version is tested with MATLAB R2019b and [CasADi](https://web.casadi.org/get/)  3.5.1.

## Standard Form
ALADIN-M solves problem of the form 

$$
\begin{aligned} 
&\min_{x_1,\dots,x_R} && \sum_{i\in \mathcal{R}} f_i(x_i) \\
&\;\;\text{subject to}&&g_{i}(x_i) = 0 \quad \;\, \mid \kappa_i,  &\forall i \in \mathcal{R}, \\
&&&h_{i}(x_i) \leq 0 \quad \;\, \mid \gamma_i,  &\forall i \in \mathcal{R}, \\
&&&\underline{x}_i \leq x_i \leq  \overline{x}_i\;\, \mid\eta_i,  &\forall i \in \mathcal{R}, \\
&&&\sum_{i\in \mathcal{R}}A_i x_i=0\;\mid\lambda.
\end{aligned}
$$

where $f_i:\mathbb{R}^{n_{xi}}\rightarrow\mathbb{R}$, $g_i:\mathbb{R}^{n_{xi}}\rightarrow\mathbb{R}^{n_{gi}}$, $h_i:\mathbb{R}^{n_{xi}}\rightarrow\mathbb{R}^{n_{hi}}$, $A_i \in \mathbb{R}^{n_{c}\times n_{xi}}$ and a set of subsystems $\mathcal{R}=\{1,\dots,R\}$.

## An example

Define problem in standard form.

```matlab
N   =   2;
n   =   2;
m   =   1;

A1  =   [1, 0;
        0, 1];
A2  =   [-1,0;
        0, -1];
b   =   [0; 0];

lb1 =   [0;0];
lb2 =   [0;0];

ub1 =   [10;10];
ub2 =   [10;10];

%% define the problem using function handle
f1 = @(x) 2 * ( x(1) - 1)^2;
f2 = @(y) (y(2) - 2)^2;

h1 = @(x) (1 - x(1) * x(2));
h2 = @(y) (-1.5 + y(1) * y(2));
```

Collect problem information and define minimal options.

```matlab
sProb.locFuns.ffi  = {f1, f2};
sProb.locFuns.hhi  = {h1, h2};

opts.Sig = {eye(n),eye(n)};

% no termination criterion, stop after maxit
term_eps = 0;

%% solve with ALADIN
emptyfun      = @(x) [];
[ggifun{1:N}] = deal(emptyfun);

% define the optimization set up
% define objective and constraint functions
sProb.locFuns.ffi  = {f1f, f2f};
sProb.locFuns.hhi  = {h1f, h2f};
sProb.locFuns.ggi  = ggifun;

% define boundaries
sProb.llbx = {lb1,lb2};
sProb.uubx = {ub1,ub2};

% define counpling matrix
sProb.AA   = {A1,A2};

% define initial values for solutions and lagrange multipliers
sProb.zz0  = {y0(1:2),y0(3:4)};
sProb.lam0 = lam0;

sol_ALADIN = run_ALADINnew( sProb, opts ); 

```
# References
## Algorithmic Details
[1] [Houska, B., Frasch, J., & Diehl, M. (2016). An augmented Lagrangian based algorithm for distributed nonconvex optimization. SIAM Journal on Optimization, 26(2), 1101-1127.](https://epubs.siam.org/doi/abs/10.1137/140975991) 

[2] [Engelmann, A., Jiang, Y., Houska, B., & Faulwasser, T. (2019). Decomposition of non-convex optimization via bi-level distributed ALADIN. arXiv preprint arXiv:1903.11280.](https://arxiv.org/abs/1903.11280) 

## Application Examples
### Power systems

[3] [Engelmann, A., Jiang, Y., Mühlpfordt, T., Houska, B., & Faulwasser, T. (2018). Toward distributed OPF using ALADIN. IEEE Transactions on Power Systems, 34(1), 584-594.](https://ieeexplore.ieee.org/abstract/document/8450020) 


[4] [Engelmann, A., Mühlpfordt, T., Jiang, Y., Houska, B., & Faulwasser, T. (2017). Distributed AC optimal power flow using ALADIN. IFAC-PapersOnLine, 50(1), 5536-5541.](https://www.sciencedirect.com/science/article/pii/S2405896317315823) 

[5] [Du, X., Engelmann, A., Jiang, Y., Faulwasser, T., & Houska, B. (2019). Distributed State Estimation for AC Power Systems using Gauss-Newton ALADIN. arXiv preprint arXiv:1903.08956.](https://arxiv.org/abs/1903.08956) 

### Traffic engineering
### Optimal control




