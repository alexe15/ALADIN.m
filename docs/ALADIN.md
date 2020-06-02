
## Algorithm description


**Initialization:** Initial guess $\left (\{z_i^0\}_{i\in \mathcal{R}},\lambda^0 \right )$, choose $\Sigma_i \succ 0,\rho^0,\mu^0,\epsilon$. 

**Repeat:**

1. **Parallelizable Step:**
Solve for each $i \in \mathcal{R}$

$$
\begin{aligned}
\min_{x_i\in [\underline {x_i}, \overline x_i]} &f_i(x_i,p_i) + (\lambda^k)^\top A_i x_i + \frac{\rho^k}{2}\left\|x_i-z_i^k\right\|_{\Sigma_i}^2 \;\; \\
\text{s.t.}\quad & g_i(x_i,p_i) = 0, \; \;h_i(x_i,p_i)\leq 0,\; \;\; \underline{x_i} \leq x_i \leq  \overline{x}_i.
\end{aligned}
$$

2. **Termination Criterion:** If $\left\|\sum_{i\in \mathcal{R}}A_ix^k_i -b \right\|\leq \epsilon \text{ and } \left\| x^k - z^k \right \|\leq \epsilon\;,$ return $x^\star = x^k$.
		
3. **Sensitivity Evaluations:** Compute and communicate local gradients $g_i^k=\nabla f_i(x_i^k,p_i)$,
		Hessian approximations $0 \prec B_i^k \approx \nabla^2 \{ f_i( x_i^k,p_i )+\kappa_i^\top h_i(x_i^k,p_i)\}$   
        and constraint Jacobians $C^{k\top }_i :=\left [\nabla g_i(x^k_i,p_i)^\top\;  \left (\nabla \tilde  h_i(x^k_i,p_i) \right )_{j\in \mathbb{A}^k}^\top \right ]$. 
		
3. **Consensus Step:** Solve the coordination QP

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

yielding $\Delta x^k$ and $\lambda^{\mathrm{QP}k}$ as the solution to the above problem.
		
5. **Line Search:** Update primal and dual variables by

$$
\begin{aligned}
z^{k+1}&\leftarrow&z^k + \alpha^k_1(x^k-z^k) + \alpha_2^k\Delta x^k \qquad \qquad
\lambda^{k+1}\leftarrow\lambda^k + \alpha^k_3 (\lambda^{\mathrm{QP}k}-\lambda^k),
\end{aligned}
$$

with $\alpha^k_1,\alpha^k_2,\alpha^k_3$ from [HFD16](https://epubs.siam.org/doi/abs/10.1137/140975991). 
