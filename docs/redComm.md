# Reducing Communication
There are different ways of reducing the communication overhead in ALADIN-$\alpha$. Compared with ADMM for example, the coordination step of ALADIN is quite heavy due to the necessity to exchange derivative information. However, there are different ways to reduce the communication overhead of ALADIN-$\alpha$. Which one works best also depends on the problem at hand.

The first option is to use Hessian approximations instead of exact Hessians. The advantage here is, that with the [*Broyden-Fletcher–Goldfarb-Shanno (BFGS)*](https://en.wikipedia.org/wiki/Broyden%E2%80%93Fletcher%E2%80%93Goldfarb%E2%80%93Shanno_algorithm) formula for example, the Hessian matrix is approximated based on two subsequent gradients. Gradients scale with $O(n)$ whereas symmetric matrices with $O(n^2)$ in general making Hessian approximations preferable. However, one has to keep in mind that due to their approximative nature, ALADIM-M might need more iterations to convergence which might compensate the saved communication overhead per iteration. BFGS and damped BFGS can be activated in ALADIN-$\alpha$ with the `Hess` option with `BFGS` or `DBFGS` respectively. 

Another option is based on the so-called *reduced-space* or *nullspace* method (cf. Chapter 18 in [1] for example). The idea here is to eliminate all active constraints by computing a basis of the nullspace they span. With that, the dimension of the problem can be reduced by two-times the number of constraints and thus the communication-overhead can be substantially smaller - especially in case of many active constraints.

A further improvement of the nullspace-method is using the *Schur-complement*. Here, the dimension of the coordination problem in ALADIN can be reduced to the number of coupling variables which is in general much smaller than the original coordination QP. On this reduced problem it is then also possible to use the both proposed variants of bi-level ALADIN which solves this reduced coordination problem purely on a neighbor-to-neighbor baisis yielding one of the first decentralized algorithms for non-convex optimization with convergence guarantees. The used inner algorithms are variants of the [Alternating Direction of Multipliers Method (ADMM)](https://en.wikipedia.org/wiki/Augmented_Lagrangian_method#Alternating_direction_method_of_multipliers) and the [Conjugate Gradient (CG)](https://en.wikipedia.org/wiki/Conjugate_gradient_method) method. For details on all of the above mentioned methods we refer to [1] and [3].

### Numerical Example: Optimal Power Flow
Next, we give a numerical example showing the benefits of the above mentioned methods. We load a given problem formulation containing an Optimal Power FLow problem with 30 buses from [2]. The data is included in ALADIN-$\alpha$ in the `./test/problem_data/` folder.

```matlab
load('./test/problem_data/IEEE30busPrbFrm.mat')

opts.commCount    = 'true';

%% standard ALADIN
opts.maxiter      = 30;
opts.innerAlg     = 'none';
opts.slack        = 'standard'; 
opts.Hess         = 'standard';       
res_ALADINs       = run_ALADINnew(sProb, opts);

%% damped BFGS
opts.Hess         = 'DBFGS';   % damped BFGS       
opts.slack        = 'standard'; 
opts.BFGSinit     = 'exact';   % with exact Hessian initialization
res_ALADINbf      = run_ALADINnew(sProb, opts);

%% reduced-space method
opts.slack        = 'redSpace'; 
opts.Hess         = 'standard';    
res_ALADINred     = run_ALADINnew(sProb, opts);

%% bi-level ALADIN with D-CG
opts.innerAlg     = 'D-CG';
opts.innerIter    = 50;
opts.Hess         = 'standard';
opts.slack        = 'standard'; 
res_ALADINcg      = run_ALADINnew(sProb, opts);

%% bi-level ALADIN with D-ADMM
opts.innerAlg     = 'D-ADMM';
opts.innerIter    = 130;
opts.Hess         = 'standard';
opts.slack        = 'standard'; 
res_ALADINadm     = run_ALADINnew(sProb, opts);
```

By activating the `commCount` option, global and neighbor-neighbor communication is counted during the ALADIN-M iterations. An exemplary solver output looks for standard ALADIN like this: 

```
========================================================      
==               This is ALADIN-M v0.1                ==      
========================================================      
QP solver:        MA57
Local solver:     ipopt
Inner algorithm:  none
                                                            
No termination criterion was specified.
Consensus violation: 3.3407e-12
                                                            
Maximum number of iterations reached.
                                                        
-----------------   ALADIN-M timing   ------------------
                    t[s]        %tot         %iter
Tot time:......:    7.7                                 
Prob setup:....:    1.5         19.8                    
Iter time:.....:    6.2         80.0                    
------
NLP time:......:    2.6                      42.3       
QP time:.......:    0.2                      3.8        
Reg time:......:    0.1                      1.2        
Plot time:.....:    2.9                      46.9       
                                                        
--------------  Communication analysis  ----------------
floats                   tot              avg 
Global forward:....:     344176           11473      
Neighbor-neighbor:.:     0                0          
========================================================
```

Note that we have a new section now where the communication overhead is counted. The results for the average communication per ALADIN-M iteration are shown below for all the above cases in floats. Note that we only count forward communication here.

| ALADIN variant   | standard      | D-BFGS | red.-space | bi-level CG | bi-level ADMM |
| -------------:   |---------------| ------ | -------------|---------------| ------|
| global           |11.473         | 7.245  | 1663         | 8             | - 
| neighbor-neighbor| -             | -      | -            | 64            | 64


From this table, one can clearly see that using a reduced-space method can reduce the per-step communication overhead substantially for this example. Even more, we can use bi-level ALADIN reducing the communication overhead even further. However, consider that due to the different inaccuracies introduce in bi-level ALADIN for example, one might need more iterations in total as shown in [2].






#### References
[1] [Nocedal, J., & Wright, S. (2006). Numerical optimization. Springer Science & Business Media.](https://www.springer.com/de/book/9780387303031)

[2] [Engelmann, A., Jiang, Y., Houska, B., & Faulwasser, T. (2019). Decomposition of non-convex optimization via bi-level distributed ALADIN. arXiv preprint arXiv:1903.11280.](https://arxiv.org/abs/1903.11280) 

[3] Engelmann, A., Jiang, Y., Houska, B., & Faulwasser, T. (2019). ALADIN-M – An open-source MATLAB toolbox for distributed optimization.

