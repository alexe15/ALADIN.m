# ALADIN-M

ALADIN-M is a toolbox for distributed non-convex optimization in MALTAB with  [ALADIN](https://epubs.siam.org/doi/abs/10.1137/140975991) and ADMM.
A detailed documentation can be found [here](https://alexe15.github.io/ALADIN.m/).


## Getting started
1. Download ALADIN-M and add the `\src` folder to you MATLAB path.
2. Run `\exampels\main_example.m`.



## Highlights
ALADIN-M 
- supports general partially separable NLPs;
- provides a unified interface for ALADIN and ADMM and a centralized solver for direct comparison;
- supports parallel computing;
- comes with a rich set of examples from power systems, estimation and control;
- (runs with Octave?)

## Requirements:
ALADIN requires
- [CasADi](https://web.casadi.org/) optimization and automatic differentiation;
- the MATLAB [parallel computing toolbox](https://de.mathworks.com/products/parallel-computing.html) for parallel computin (if needed);
- the MATLAB [symbolic math toolbox](https://de.mathworks.com/products/symbolic.html) (only for some examples).

## Example
Suppose we would like to solve the problem 

![](https://render.githubusercontent.com/render/math?math=%5Cmin_%7By_1,y_2%20%5Cin%20%5Cmathbb%7BR%7D%5E2%7D%20%20%202%20(y_%7B11%7D%20-%201)%5E2%20+%20%20%20(y_%7B22%7D%20-%202)%5E2%5Cquad%5Ctext%7Bs.t.%7D%5Cquad1-%20y_%7B11%7Dy_%7B12%7D%20%5Cleq%200\quad%20\text{and}\quad%20-1.5%20+%20y_{21}%20y_{22}%20\leq%200)

and

![(0\;\;1)y_1\;\;+\;\;(-1\;\;0)y_2=0](https://render.githubusercontent.com/render/math?math=(0%5C%3B%5C%3B1)y_1%5C%3B%5C%3B%2B%5C%3B%5C%3B(-1%5C%3B%5C%3B0)y_2%3D0,)

which is in partially-separable form.
This non-convex problem can be solved by ALADIN-M with the following code snippet.

```
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
````
This yields the output
```
   ================== ALADIN response ===================    
                                                                
   ============== ALADIN iteration summary ==============    
                                                                
Current iteration: 30
                                                                
Applied solvers: 
QP solver:        MA57
Local solver:     ipopt
Inner algorithm:  none
                                                                
No specific termination error bound was handed over.
Remaining iterations:         0
Current constraint violation: 6.6531e-12
                                                                
Maximum number of iterations is reached.
                                                          
   ==================   ALADIN timing   ==================
                  t[s]              %tot              %iter             
Tot time......:     3.4                                                 
Prob setup....:     0.14             4.2                                
Iter time.....:     3.25            95.6                                
 ---------                                                              
NLP time......:     0.93                              28.8              
QP time.......:     0.08                               2.4              
Reg time......:     0.02                               0.6              
Plot time.....:     1.99                              61.4     
```
and a primal-optimal solution
```
>> sol_ALADIN.xxOpt{:}

ans =

    0.8166
    1.8369


ans =

    0.8166
    1.8369
```

By default ALADIN-M shows progress in the iterations e.g. by the consensus gap ![\text{log}_{10}(\|Ax-b\|_\infty)](https://render.githubusercontent.com/render/math?math=%5Ctext%7Blog%7D_%7B10%7D(%5C%7CAx-b%5C%7C_%5Cinfty)) and the stepsizes in the local step and the coordination. 

![](docs/figures/microExOut.png)

Note that the above is a reformulation of the problem

![\min_{x_1,x_2\in \mathbb{R}}  2 \, (x_1 - 1)^2 + (x_2 - 2)^2 \quad \text{subject to}\quad -1 \leq x_1 \, x_2 \leq 1.5 ](https://render.githubusercontent.com/render/math?math=%5Cmin_%7Bx_1%2Cx_2%5Cin%20%5Cmathbb%7BR%7D%7D%20%202%20%5C%2C%20(x_1%20-%201)%5E2%20%2B%20(x_2%20-%202)%5E2%20%5Cquad%20%5Ctext%7Bsubject%20to%7D%5Cquad%20-1%20%5Cleq%20x_1%20%5C%2C%20x_2%20%5Cleq%201.5%20)

which can be reformulated by introducing auxiliary variables and additional consensus constraints.



## License
ALADIN-M comes under the [MIT license](https://en.wikipedia.org/wiki/MIT_License), see the [license file](https://github.com/alexe15/ALADIN.m/blob/master/LICENSE.txt).