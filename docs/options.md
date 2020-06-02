# Options
ALADIN-$\alpha$ comes with several ALADIN variants. These variants can be activated by setting options. All options with possible values can be found in `loadDefOpts.m`. Here, we give a little more detailled description of these options. 


**Basic options**

| ALADIN option    | default values       | alternative |
| -------------:   |----------------------|------------ |
| rho0             |1e2                   |double > 0   |
| rhoUpdate        |1.1                   |double > 0   |
| rhoMax           |1e8                   |double > 0   |
| Sig              |'const'               | 'dyn'       |
| lamInit          |'false'               | 'true'      |
| term_eps         |0                     | double > 0  |
| maxiter          |30                    | integer > 0 |
| mu0              |1e3                   | double > 0  |
| muUpdate         |2                     | double > 0  |
| muMax            |2*1e6                 | double > 0  |
| solveQP          |'MA57'                | 'ipopt', 'pinv', 'linsolve', 'sparseBs', 'MOSEK', 'quadprog'|
| loc Sol          |'MA57'                | 'ipopt','sqpmethod'|
| reg              |'true'                | 'false'     |
| regParam         |1e-4                  | double > 0  |
| actMargin        |-1e-6                 | double < 0  |
| plot             |'true'                | 'false'     |


**Extensions**

| ALADIN option    | default values       | alternative |
| -------------:   |----------------------|------------ |
| slack            |   'standard'         | 'redSpace'  |
| hessian          |    'standard'        |             |
| Hess             |   'standard'         | 'DBFGS', $\text{ }$ 'BFGS'            |
| BFGSinit         |    'ident'           | 'exact'     |
| parfor           |     'false'          |  'true'     |
| DelUp            |     'false'          |  'true'     |
| reuse            |     'false'          |  'true'     |
| commCount        |     'false'          |  'true'     |


**Bi-Level options**

| ALADIN option    | default values       | alternative |
| -------------:   |----------------------|------------ |
| innnerAlg        | 'none'               | 'D-CG', 'D-ADMM'             |
| rhoADM           | 2e-2                  |             |
| warmStart        | 'true'                | 'false'     |
| innerIter        |  200                  | integer > 0 |


**Parameter choices for initialization**

During the initialization process, the options for the parameters $\Sigma, \rho 0, \mu 0$ and $\varepsilon$ are of relevance. The default settings are given by 

| ALADIN option    | default values       | alternatives |
| -------------:   |----------------------|--------------|
| Sig              |'const'               |     'dny'        |
| rho0             |1e2                   |     $\geq 0$     |
| mu0              |1e3                   |     $\geq 0$     |
| term_eps         |0                     |     $\geq 0$     |

 The parameter $\texttt{rho0}$ represents the penalization of the distance (augmented step size) $\left|x_i-z_i^k\right|_{\Sigma_i}^2$ during the first parallel step. The option $\texttt{Sig}$ determines the augemented norm. In the first step, $\texttt{Sig}$ is the identity matrix, thus the norm $|x_i - z_i|$ is evaluated. Changing sigma leads to penalization of the distance $|\Sigma_i(x_i - z_i)| = |x_i - z_i|_{\Sigma_i}$.



First, we recall, that the algorithm consists of several stepts, which are [see here](ALADIN.md). Keeping the algorithm in mind, we can now focus on the options that can be selected.

## Basic Options
**Parameter $\rho$**

During the **Parallelizable Step** $k$, the optimization problems

$$
\begin{aligned}
\min_{x_i\in [\underline {x_i}, \overline x_i]} &f_i(x_i) + (\lambda^k)^\top A_i x_i + \frac{\rho^k}{2}\left\|x_i-z_i^k\right\|_{\Sigma_i}^2 \;\; \\
\text{s.t.}\quad & g_i(x_i) = 0, \; \;h_i(x_i)\leq 0,\; \;\; \underline{x_i} \leq x_i \leq  \overline{x}_i.
\end{aligned}
$$

 need to be solved for fixed $z_i$. The parameter $\rho^k$ represents the penalization of the distance $\left|x_i-z_i^k\right|_{\Sigma_i}^2$. As long as $\texttt{rho}$ is smaller than $\texttt{rhoMax}$, it is increased by factor $\texttt{rhoUpdate}$.

| ALADIN option    | default values       | alternative |
| -------------:   |----------------------|------------ |
| rho0             |1e2                   |double > 0   |
| rhoUpdate        |1.1                   |double > 0   |
| rhoMax           |1e8                   |double > 0   |

     
**Dynamic $\Sigma$**

The second parameter relevant for the **Parallelizable Step** is the scaling matrix $\Sigma$. During the first iteration, $\Sigma$ equals the identity matrix. When the alternative option 'dyn' was selected, in each step the it is checked whether the step sizes for all variables decrease. In case that a step size is not decreasing in a sufficient manner, $\Sigma$ is changed dynamically to increase the negative impact of the large step size on the objective function in the parallel step.

| ALADIN option    | default value       | alternative |
| -------------:   |---------------------| -------     |
| Sig              |'const'              | 'dyn'       |

**Parameter $\lambda$**

The parameter $\lambda$ takes over the function of the lagrange multipliers. We can decide whether we want to hand over a specific one or not.

| ALADIN option    | default value       | alternative |
| -------------:   |---------------------| -------     |
| lamInit          |'false'              | 'true'     |

**Termination criterion**

Executing the ALADIN algorithm, in each step a termination criterion is checked. The termination criterion is split into two parts. Part one checks, whether the maximum number $\texttt{maxiter}$ of iterations is reached. Additionatlly, a termination bound $\varepsilon > 0$ can be handed over. Then, in each step, it is terminated, if $\left\|\sum_{i\in \mathcal{R}}A_ix^k_i -b \right\|\leq \epsilon \text{ and } \left\| x^k - z^k \right \|\leq \epsilon\;,$ holds true.

| ALADIN option    | default value       | alternative |
| -------------:   |---------------------| -------     |
| term_eps         |0                    | double > 0          |
| maxiter          |30                   | integer > 0 |

**Parameter $\mu$**

During the consensus step, the coordination QP 

$$
\begin{aligned}
&\underset{\Delta x,s}{\min}\;\;\sum_{i\in \mathcal{R}}\left\{\frac{1}{2}\Delta x_i^\top B^k_i\Delta x_i + {g_i^k}^\top \Delta x_i\right\}     + (\lambda^k)^\top s + \frac{\mu^k}{2}\|s\|^2_2  \\ 
&
\begin{aligned}
\text{subject to}\;                                   \sum_{i\in \mathcal{R}}A_i(x^k_i+\Delta x_i) &=  s    \qquad  |\; \lambda^{\mathrm{QP} k},\\
C^k_i \Delta x_i &= 0                                     \qquad   \forall i\in \mathcal{R},\\
\end{aligned}
\end{aligned}
$$ 

has to be executed. Setting $s:= \sum A_ix_i - b \overset{!}{=} 0$, the parameter $\mu$ is similarly to the parameter $\rho$ from above a penalty parameter. It can be set in the same manner as $\rho$.  

| ALADIN option    | default values       | alternative |
| -------------:   |----------------------| ----------  |
| mu0              |1e3                   | double > 0  |
| muUpdate         |2                     | double > 0  |
| muMax            |2*1e6                 | double > 0  |

**Solvers** 

To solve the two optimization problems in each iteration step, the desired solvers can be indicated via setting the option opts.solveQP and opts.locSol:

**1. QP Solver**

| ALADIN option    | default value       | alternatives |
| -------------:   |---------------------| ------------ |
| solveQP        |'MA57'                 | 'ipopt', 'pinv', 'linsolve', 'sparseBs', 'MOSEK', 'quadprog'|

**2. Local Solver**

| ALADIN option    | default value       | alternatives        |
| -------------:   |---------------------| ------------------- |
| locSol          |'ipopt'               | 'ipopt', 'sqpmethod'|

**Regularization Parameters**

Sometimes the Hessian matrices of the given problems do not have full rank, such that some important matrix operations are not readily available. Remedy can be obtained by regularization approaches that increase the rank of the matrix. The option can be set as follows:

| ALADIN option    | default value       | alternative |
| -------------:   |---------------------| -------     |
| reg              |'true'               | 'false'     |
| regParam         |1e-4                 |             |

**Active Margin Detection**

ALADIN, beeing a solver for constraint optimization, needs an active margin detection. The tolerance is handed over by the option $\texttt{actMargin}$

| ALADIN option    | default value        |
| -------------:   |----------------------|
| actMargin        |-1e-6                 |

**Plots**

Plotting results is nice, because one can immediately see the results. However, push up windows spreading plots over your screen can be annoying and slow down the algorithm, so we included an option to deactivate plots :)

| ALADIN option    | default value       | alternative |
| -------------:   |---------------------| -------     |
| plot             |'true'               | 'false'       |

## Extensions
**parfor Option**

The parallelizable step from the ALADIN Algorithm can be executed in the parallel threads in matlab using its implemented `parfor` -loop. This can be activeted by:

| ALADIN option    | default value       | alternative |
| -------------:   |---------------------| -------     |
| parfor           |'false'              | 'true'      |


## Bilevel Options



!!! warning "Parameter combinations"
    __Note that ss ALADIN-$\alpha$ is still in a prototypical phase of development, it is not guaranteed that *all* combinations of options work. We tried to make ALADIN-$\alpha$ as stable as possible running tests with a high code coverage, but we are at the moment not able to guarantee that all combinations of options work__