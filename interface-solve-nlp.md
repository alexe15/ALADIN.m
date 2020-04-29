### Interface `solve_nlp()`

This function forms the heart of the parallel step of Aladin: it is a function handle to solve the local NLPs.
It is created within [`createLocalSolvers.m`](src/core/createLocalSolvers.m).

Its interface is

```matlab
sol = problem.solve_nlp(x0, z, rho, lambda, Sigma, problem.pars)
```

where `problem` is an entry of [`nnlp`](#`nnlp`).
The meanings of `x0`, `z`, `rho`, `lambda`, and `Sigma` are obvious; `problem.pars` is the generic struct of parameters from the description of [`nnlp`](#`nnlp`).

The output `sol` is a struct with the following entries.

| Name | Type |  Meaning |
| --- | --- | ---  |
| `x` | `vector` | local optimal solution | 
| `lam_g` | `vector` | Lagrange multiplier of equality constraints |
| `lam_x` | `vector` | Lagrange multiplier of lower/upper bounds on state $x$ |
| `pars` | `struct` or `empty` | if applicable, parameter values that need to be returned