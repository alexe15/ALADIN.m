# ALADIN-alpha
ALADIN-alpha is a rapid-prototyping toolbox for *distributed* and *decentralized* non-convex optimization. ALADIN-alpha implements the *Augmented Lagrangian Alternating Direction Inexact Newton (ALADIN)* algorithm and the *Alternating Direction of Multipliers Method (ADMM)* with a unified interface. Moreover, bi-level ALADIN is included in ALADIN-alpha allowing for *decentralized* non-convex optimization. Application examples from various fields highlight the broad applicability of ALADIN-alpha. A documentation can be found [here](https://alexe15.github.io/ALADIN.m/).


## Getting started
1. Download ALADIN-M and add the `\src` folder to you MATLAB path.
2. Run `\exampels\main_example.m`.



## Highlights
ALADIN-alpha 
- supports general partially separable NLPs;
- comes with a bi-level ALADIN extension enabling decentralizes optimization;
- provides a unified interface for ALADIN and ADMM and a centralized solver for direct comparison;
- supports parallel computing;
- comes with a rich set of examples from power systems, estimation and control.

## Requirements:
ALADIN-alpha requires
- [CasADi](https://web.casadi.org/) optimization and automatic differentiation;
- the MATLAB [parallel computing toolbox](https://de.mathworks.com/products/parallel-computing.html) for parallel computin (if needed);
- the MATLAB [symbolic math toolbox](https://de.mathworks.com/products/symbolic.html) (only for some examples).
