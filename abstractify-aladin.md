# Abstractify Aladin

The abstract part of Aladin lies entirely with `iterateAL()`, it is where the Aladin algorithm is executed.
Inside of `iterateAL()` there are __no definitions/declarations of variables or functions__ such as gradients, Jacobians, Hessians; the purpose of `iterateAL()` is to *use* the supplied function handles, and to apply the Aladin algorithm to them.
Hence, `iterateAL()` needs to be passed only structures containing either arrays or function handles.

Basically, `iterateAL()` needs function handles (*not* casadi functions or anything else) to evaluate
- local cost functions
- local equality constraints
- local inequality constraints
- local gradients
- local Jacobians
- local Hessians, and
- __additionally, `iterateAL()` requires function handles to solve the NLPs.__

The interface for `iterateAL()` is documented [here](interface-iterate-al.md); the interface for the local NLP solvers is documented [here](interface-solve-nlp.md).

## ToDos


- [ ] [agree on interface for `iterateAL()`](interface-iterate-al.md)
- [ ] [agree on interface for `solve_nlp()`](interface-solve-nlp.md)
- [ ] [implement interface for `iterateAL()`](interface-iterate-al.md)
    - this implementation largely means to convert casadi functions to matlab function handles
    - additionally, there will be a lot of details that need to be taken care of
- [ ] implement a function that validates that `sProb` passed to `iterateAL()` adheres to agreed interface

