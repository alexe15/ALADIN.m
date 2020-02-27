# ALADIN-M - An open-source MATLAB toolbox for distributed optimization

ALADIN-M is a toolbox for distributed non-convex optimization in MALTAB with  [ALADIN](https://epubs.siam.org/doi/abs/10.1137/140975991) and ADMM.

## Highlights
ALADIN-M 
- supports general partially separable NLPs;
- provides a unified interface for ALADIN and ADMM and a centralized solver for direct comparison;
- supports parallel computing;
- comes with a rich set of examples from power systems, estimation and control;
- (is runnable with Octave.)


## Requirements:
ALADIN requires
- [CasADi](https://web.casadi.org/) optimization and automatic differentiation;
- the MATLAB [parallel computing toolbox](https://de.mathworks.com/products/parallel-computing.html) for parallel computin (if needed);
- the MATLAB [symbolic math toolbox](https://de.mathworks.com/products/symbolic.html) (only for some examples).

A detailed documentation can be found [here](https://alexe15.github.io/ALADIN.m/).

## Getting started
1. Download ALADIN-M and add the `\src` folder to you MATLAB path.
2. Run `\exampels\main_example.m`.

## License
ALADIN-M comes under the [MIT license](https://en.wikipedia.org/wiki/MIT_License), see the [license file](https://github.com/alexe15/ALADIN.m/blob/master/LICENSE.txt).