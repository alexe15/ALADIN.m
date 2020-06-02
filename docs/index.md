# ALADIN-$\alpha$ 

ALADIN-$\alpha$ is a rapid-prototyping toolbox for *distributed* and *decentralized* non-convex optimization.
ALADIN-$\alpha$ provides an implementation of the *Augmented Lagrangian Alternating Direction Inexact Newton (ALADIN)* algorithm and the Alternating Direction of Multipliers Method (ADMM) with a unified interface.
Moreover, a bi-level ALADIN variant is included in ALADIN-$\alpha$ allowing for *decentralized* non-convex optimization.
Application examples from various fields highlight the broad applicability of ALADIN-$\alpha$.


ALADIN-$\alpha$ solves problem of the form 

$$
\begin{aligned} 
&\min_{x_1,\dots,x_{n_s}} && \sum_{i\in \mathcal{S}} f_i(x_i,p_i) \\
&\;\;\text{subject to}&&g_{i}(x_i,p_i) = 0 \quad  &&\mid \kappa_i,  &\forall i \in \mathcal{R}, \\
&&&h_{i}(x_i,p_i) \leq 0 \quad \;\,&& \mid \gamma_i,  &\forall i \in \mathcal{R}, \\
&&&\underline{x}_i \leq x_i \leq  \overline{x}_i\;\,&& \mid\eta_i,  &\forall i \in \mathcal{R}, \\
&&&\sum_{i\in \mathcal{S}}A_i x_i=0\;&&\mid\lambda.
\end{aligned}
$$

in a distributed fashion.


!!! note "Eearly-stage version of ALADIN-$\alpha$"
    __Note that ALADIN-$\alpha$ is still in a prototypical phase of development.__


## An example

Here's an example how to use ALADIN-$\alpha$. Let us consider an inequality-constrained non-convex problem

$$
	\begin{aligned}  
&	\min_{x \in \mathbb{R},y \in \mathbb{R}^2}   2 \,(x - 1)^2 +   (y(2) - 2)^2\\
	\;\;\text{subject to} \;\;    &  - 1 - y(1)\,y(2) \leq 0, \quad 
	 -1.5 + y(1) y(2) \leq 0, \\
	 & 1\,x \;\;+\; \;(\,-1 \;\; 0 \,)\,y = 0,
	\end{aligned}
$$

which is in the above form. In MATLAB code, this looks as follows:

``` matlab
% define local objective functions
f1 = @(x) 2 * ( x - 1)^2;
f2 = @(y) (y(2) - 2)^2;

% local nonlinear inequality constraints
h1 = @(x) [];
h2 = @(y) [-1 -  y(1) * y(2) ;-1.5 + y(1) * y(2)];

% coupling matrices
A1  =    1;
A2  =   [-1   0];
     
% collect variables in sProb struct
sProb.locFuns.ffi  = {f1, f2};
sProb.locFuns.hhi  = {h1, h2};
sProb.AA           = {A1, A2};
```

That's all! Now we are ready to solve our problem with the `run_ALADIN` function.

``` matlab
sol_ALADIN = run_ALADINnew( sProb ); 
```


If the option `plot` is `true`, ALADIN-M shows progress by the following plot while iterating.  A sample plot is shown below.

![](.\figures\exPlot.png)

The resulting solver console output is shown next.

```
   ========================================================      
   ==               This is ALADIN-alpha v0.1            ==      
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

For further examples checkout the `/examples` and the `/test` folder!

## How to install
Clone `https://github.com/alexe15/ALADIN.m` and add `/ALADIN.m` to your MATLAB path.

## Requirements
- MATLAB
- [CasADi](https://web.casadi.org/get/) 
- MATLAB symbolic toolbox (only for examples)

The current version is tested with MATLAB R2019b and [CasADi](https://web.casadi.org/get/)  3.5.1.





