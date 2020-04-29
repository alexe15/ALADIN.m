# Interface `iterateAL()`
The function `iterateAL()` is defined as

```matlab
function [ sol, timers ] = iterateAL( sProb, opts, timers )
```

In the following, we define the structure of `sProb`; `opts` and `timers` remain untouched.
Also note that we use the terms *struct*  and *cell array* 

The struct `sProb` fully describes the distributed optimization problem, and it contains arrays and function handles that are needed by the Aladin algorithm.

For example, for a distributed optimization problem with a total of three regions, the struct `sProb` looks as follows

```matlab
sProb = 

  struct with fields:

    locFuns: [1×1 struct]
       sens: [1×1 struct]
       nnlp: {[1×1 struct]  [1×1 struct]  [1×1 struct]}
        zz0: {3×1 cell}
       llbx: {3×1 cell}
       uubx: {3×1 cell}
         AA: {3×1 cell}
          b: [12×1 double]
       lam0: [12×1 double]
       pars: [1×1 struct]
       Mfun: @(x)[]

```

| Name | Type | Element type | #Entries | Meaning |
| --- | --- | --- | --- | --- | 
| `locFuns` | `struct` | `cell array`| - | see [here](#`locFuns`) |
| `sens` | `struct` | `cell array` | - | see [here](#`sens`) |
| `nnlp`| `cell array` | `struct`| $N_{\text{regions}}$ | handles to local NLP solvers, see [here](#`nnlp`) |
| `zz0` | `cell array` | `vector` | $N_{\text{regions}}$ | initial conditions for local problems |
| `llbx`| `cell array`| `vector`| $N_{\text{regions}}$ | lower bounds for local problems |
| `uubx`| `cell array`| `vector`| $N_{\text{regions}}$ | upper bounds for local problems |
| `AA`| `cell array` | `matrix` | $N_{\text{regions}}$ | consensus matrices |
| `b`| `vector` | - | - | right-hand side of consensus constraints |
| `lam0` | `vector` | - | - | initial conditions for multipliers for consensus constraints |
| `pars` | `struct` or empty | - | - | contains additional information for Aladin such as $\Sigma$ matrices or $\rho$ values, for instance. |
| `Mfun` | `function handle` | - | - | merit function |


## Default values

tbd

## `locFuns`

The struct `locFuns` has the following fields.

| Name | Type | Element type | #Entries | Meaning |
| --- | --- | --- | --- | --- |
| `ffi` | `cell` | `function handle` | $N_{\text{regions}}$ | local cost function |
| `ggi` | `cell` | `function handle` | $N_{\text{regions}}$ | local equality constraints | 
| `hhi` | `cell` | `function handle` | $N_{\text{regions}}$ | local inequality constraints |
| `dims` | `cell array` | `struct`| $N_{\text{regions}}$ | dimensions of local subproblem, see [here](#`dims`) |

### `dims`

__This cell array has to be auto-generated within `iterateAL()`__

Each of the $N_{\text{regions}}$ entries of the cell array `dims` is a struct with the following fields.
| Name | Type |  Meaning |
| --- | --- | ---  |
| `state` | `int` | dimension of local state |
| `eq` | `int` or `empty` | number of local equality constraints |
| `ineq` | `int` or `empty`  | number of local inequaliy constraints | 

## `sens`

The struct `sens` has the following fields.

| Name | Type | Element type | #Entries | Meaning |
| --- | --- | --- | --- | --- |
| `gg` | `cell array` | `function handle` | $N_{\text{regions}}$ | local gradients |
| `JJac` | `cell array` | `function handle` | $N_{\text{regions}}$ | local Jacobians | 
| `HH` | `cell array` | `function handle` | $N_{\text{regions}}$ | local Hessians |

## `nnlp`

Each of the $N_{\text{regions}}$ entries of the cell array `nnlp` is a struct with the following fields.
| Name | Type |  Meaning |
| --- | --- | ---  |
| `name` | `string` | name of NLP solver | 
| `solve_nlp` | `function handle` | handle to NLP solver, see [here](interface-solve-nlp.md) |
| `pars` | `struct` or `empty` | parameters for NLP solver (if applicable) |




