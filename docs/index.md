# ALADIN-M 
## A toolbox for distributed non-convex optimization

ALADIN-M is a bare-bone implementation of the ALADIN algorithm with extensions including a set of application examples from different engineering fields. ALADIN-M solves problem of the form 

$$
\begin{aligned} 
&\min_{x_1,\dots,x_R} && \sum_{i\in \mathcal{R}} f_i(x_i) \\
&\;\;\text{subject to}&&g_{i}(x_i,p_i) = 0 \quad  \mid \kappa_i,  &\forall i \in \mathcal{R}, \\
&&&h_{i}(x_i) \leq 0 \quad \;\, \mid \gamma_i,  &\forall i \in \mathcal{R}, \\
&&&\underline{x}_i \leq x_i \leq  \overline{x}_i\;\, \mid\eta_i,  &\forall i \in \mathcal{R}, \\
&&&\sum_{i\in \mathcal{R}}A_i x_i=0\;\mid\lambda.
\end{aligned}
$$

in a distributed fashion.

## An example

Here's an example how to use ALADIN-M. First, define your problem in the above form.
``` matlab
% define local objective functions
f1 = @(x) 2 * ( x(1) - 1)^2;
f2 = @(y) (y(2) - 2)^2;

% local nonlinear inequality constraints
h1 = @(x) (1 - x(1) * x(2));
h2 = @(y) (-1.5 + y(1) * y(2));

% coupling matrices
A1  =   [ 1,  0;
          0,  1];
A2  =   [-1   0;
          0, -1];
     
% collect variables in sProb struct
sProb.locFuns.ffi  = {f1, f2};
sProb.locFuns.hhi  = {h1, h2};
sProb.AA           = {A1, A2};

% solve with ALADIN-M
sol_ALADIN = run_ALADINnew( sProb ); 
```


If the option `plot` is `true`, ALADIN-M shows progress by the following plot while iterating.  A sample plot is shown below.

![](.\figures\exPlot.png)

The resulting solver console output is shown next.

```
   ========================================================      
   ==               This is ALADIN-M v0.1                ==      
   ========================================================      
   QP solver:        MA57
   Local solver:     ipopt
   Inner algorithm:  none
                                                                
   No termination criterion was specified.
   Consensus violation: 1.1368e-10
                                                                
   Maximum number of iterations reached.
                                                           
   -----------------   ALADIN-M timing   ------------------
                       t[s]        %tot         %iter
   Tot time:......:    2.5                                 
   Prob setup:....:    0.1         2.3                     
   Iter time:.....:    2.4         97.6                    
   ------
   NLP time:......:    0.9                      37.3       
   QP time:.......:    0.0                      1.5        
   Reg time:......:    0.0                      0.4        
   Plot time:.....:    1.4                      56.2       
                                                           
   ========================================================
```

## How to install
Clone `https://github.com/alexe15/ALADIN.m` and add `/ALADIN.m` to your MATLAB path.

### Requirements
- MATLAB
- [CasADi](https://web.casadi.org/get/) 
- MATLAB symbolic toolbox (only for examples)

The current version is tested with MATLAB R2019b and [CasADi](https://web.casadi.org/get/)  3.5.1.



#### References
###### Algorithmic Details
[1] [Houska, B., Frasch, J., & Diehl, M. (2016). An augmented Lagrangian based algorithm for distributed nonconvex optimization. SIAM Journal on Optimization, 26(2), 1101-1127.](https://epubs.siam.org/doi/abs/10.1137/140975991) 

[2] [Engelmann, A., Jiang, Y., Houska, B., & Faulwasser, T. (2019). Decomposition of non-convex optimization via bi-level distributed ALADIN. arXiv preprint arXiv:1903.11280.](https://arxiv.org/abs/1903.11280) 

###### Application to power systems

[3] [Engelmann, A., Jiang, Y., Mühlpfordt, T., Houska, B., & Faulwasser, T. (2018). Toward distributed OPF using ALADIN. IEEE Transactions on Power Systems, 34(1), 584-594.](https://ieeexplore.ieee.org/abstract/document/8450020) 


[4] [Engelmann, A., Mühlpfordt, T., Jiang, Y., Houska, B., & Faulwasser, T. (2017). Distributed AC optimal power flow using ALADIN. IFAC-PapersOnLine, 50(1), 5536-5541.](https://www.sciencedirect.com/science/article/pii/S2405896317315823) 

[5] [Du, X., Engelmann, A., Jiang, Y., Faulwasser, T., & Houska, B. (2019). Distributed State Estimation for AC Power Systems using Gauss-Newton ALADIN. arXiv preprint arXiv:1903.08956.](https://arxiv.org/abs/1903.08956) 

###### Application to  Traffic engineering
###### Application to Optimal control





