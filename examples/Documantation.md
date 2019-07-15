# Documentation

## Problem Formulation
Example: Rosenbrock function
$$
\begin{aligned}
\min f(x_1,x_2) &= (1-x_1)^2 + 100 (x_2-x^2_1)^2\\
s.t.\\
x_1 &\geq -1.5 
\end{aligned}
$$

$$
\begin{aligned}
\min f(y_1, y_2, y_3) &= (1-y_1)^2 + 100 (y_2-y^2_3)^2 \\
&= f(y_1) + f(y_2,y_3)\\
s.t.\\
y_1 &= y_3,\\
 y_2 & \geq -1.5
\end{aligned}
$$

$$
\begin{aligned}
\min f(\tilde{y}_1, \tilde{y}_2) &= f(\tilde{y}_1) + f(\tilde{y}_2) \\
&= (1-\tilde{y}_1(1))^2 + 100 (\tilde{y}_2(1)-\tilde{y}_2(2)^2)^2 \\
s.t.\\
[1] \tilde{y}_1 + [0\ -1] \tilde{y}_2 &=0,\\
-1.5 - y_2(1) &\leq 0\\
\text{with } \tilde{y}_1 &= [y_1],\ \tilde{y}_2 = [y_2\ y_3]^\top
\end{aligned}
$$

