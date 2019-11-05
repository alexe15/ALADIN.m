function varargout = conic(varargin)
    %CONIC Create a QP solver Solves the following strictly convex problem:
    %
    %  Function = CONIC(char name, char solver, struct:Sparsity qp, struct opts)
    %
    %
    %
    %
    %::
    %
    %  min          1/2 x' H x + g' x
    %  x
    %  
    %  subject to
    %  LBA <= A x <= UBA
    %  LBX <= x   <= UBX
    %  
    %  resize(Q x, np, np) + P >= 0 (psd)
    %  
    %  with :
    %  H sparse (n x n) positive definite
    %  g dense  (n x 1)
    %  A sparse (nc x n)
    %  Q sparse symmetric (np^2 x n)
    %  P sparse symmetric (np x nq)
    %  
    %  n: number of decision variables (x)
    %  nc: number of constraints (A)
    %  nq: shape of psd constraint matrix
    %
    %
    %
    %If H is not positive-definite, the solver should throw an error.
    %
    %Second-order cone constraints can be added as psd constraints through a
    %helper function 'soc':
    %
    %x in R^n y in R
    %
    %|| x ||_2 <= y
    %
    %<=>
    %
    %soc(x, y) psd
    %
    %This can be proven with soc(x, y)=[y*I x; x' y] using the Shur complement.
    %
    %General information
    %===================
    %
    %
    %
    %>List of available options
    %
    %+------------------+-----------------+------------------+------------------+
    %|        Id        |      Type       |   Description    |     Used in      |
    %+==================+=================+==================+==================+
    %| ad_weight        | OT_DOUBLE       | Weighting factor | casadi::Function |
    %|                  |                 | for derivative   | Internal         |
    %|                  |                 | calculation.When |                  |
    %|                  |                 | there is an      |                  |
    %|                  |                 | option of either |                  |
    %|                  |                 | using forward or |                  |
    %|                  |                 | reverse mode     |                  |
    %|                  |                 | directional      |                  |
    %|                  |                 | derivatives, the |                  |
    %|                  |                 | condition ad_wei |                  |
    %|                  |                 | ght*nf<=(1-ad_we |                  |
    %|                  |                 | ight)*na is used |                  |
    %|                  |                 | where nf and na  |                  |
    %|                  |                 | are estimates of |                  |
    %|                  |                 | the number of    |                  |
    %|                  |                 | forward/reverse  |                  |
    %|                  |                 | mode directional |                  |
    %|                  |                 | derivatives      |                  |
    %|                  |                 | needed. By       |                  |
    %|                  |                 | default,         |                  |
    %|                  |                 | ad_weight is     |                  |
    %|                  |                 | calculated       |                  |
    %|                  |                 | automatically,   |                  |
    %|                  |                 | but this can be  |                  |
    %|                  |                 | overridden by    |                  |
    %|                  |                 | setting this     |                  |
    %|                  |                 | option. In       |                  |
    %|                  |                 | particular, 0    |                  |
    %|                  |                 | means forcing    |                  |
    %|                  |                 | forward mode and |                  |
    %|                  |                 | 1 forcing        |                  |
    %|                  |                 | reverse mode.    |                  |
    %|                  |                 | Leave unset for  |                  |
    %|                  |                 | (class specific) |                  |
    %|                  |                 | heuristics.      |                  |
    %+------------------+-----------------+------------------+------------------+
    %| ad_weight_sp     | OT_DOUBLE       | Weighting factor | casadi::Function |
    %|                  |                 | for sparsity     | Internal         |
    %|                  |                 | pattern          |                  |
    %|                  |                 | calculation calc |                  |
    %|                  |                 | ulation.Override |                  |
    %|                  |                 | s default        |                  |
    %|                  |                 | behavior. Set to |                  |
    %|                  |                 | 0 and 1 to force |                  |
    %|                  |                 | forward and      |                  |
    %|                  |                 | reverse mode     |                  |
    %|                  |                 | respectively.    |                  |
    %|                  |                 | Cf. option       |                  |
    %|                  |                 | "ad_weight".     |                  |
    %+------------------+-----------------+------------------+------------------+
    %| compiler         | OT_STRING       | Just-in-time     | casadi::Function |
    %|                  |                 | compiler plugin  | Internal         |
    %|                  |                 | to be used.      |                  |
    %+------------------+-----------------+------------------+------------------+
    %| derivative_of    | OT_FUNCTION     | The function is  | casadi::Function |
    %|                  |                 | a derivative of  | Internal         |
    %|                  |                 | another          |                  |
    %|                  |                 | function. The    |                  |
    %|                  |                 | type of          |                  |
    %|                  |                 | derivative       |                  |
    %|                  |                 | (directional     |                  |
    %|                  |                 | derivative,      |                  |
    %|                  |                 | Jacobian) is     |                  |
    %|                  |                 | inferred from    |                  |
    %|                  |                 | the function     |                  |
    %|                  |                 | name.            |                  |
    %+------------------+-----------------+------------------+------------------+
    %| discrete         | OT_BOOLVECTOR   | Indicates which  | casadi::Conic    |
    %|                  |                 | of the variables |                  |
    %|                  |                 | are discrete,    |                  |
    %|                  |                 | i.e. integer-    |                  |
    %|                  |                 | valued           |                  |
    %+------------------+-----------------+------------------+------------------+
    %| enable_fd        | OT_BOOL         | Enable           | casadi::Function |
    %|                  |                 | derivative       | Internal         |
    %|                  |                 | calculation by   |                  |
    %|                  |                 | finite           |                  |
    %|                  |                 | differencing.    |                  |
    %|                  |                 | [default:        |                  |
    %|                  |                 | false]]          |                  |
    %+------------------+-----------------+------------------+------------------+
    %| enable_forward   | OT_BOOL         | Enable           | casadi::Function |
    %|                  |                 | derivative       | Internal         |
    %|                  |                 | calculation      |                  |
    %|                  |                 | using generated  |                  |
    %|                  |                 | functions for    |                  |
    %|                  |                 | Jacobian-times-  |                  |
    %|                  |                 | vector products  |                  |
    %|                  |                 | - typically      |                  |
    %|                  |                 | using forward    |                  |
    %|                  |                 | mode AD - if     |                  |
    %|                  |                 | available.       |                  |
    %|                  |                 | [default: true]  |                  |
    %+------------------+-----------------+------------------+------------------+
    %| enable_jacobian  | OT_BOOL         | Enable           | casadi::Function |
    %|                  |                 | derivative       | Internal         |
    %|                  |                 | calculation      |                  |
    %|                  |                 | using generated  |                  |
    %|                  |                 | functions for    |                  |
    %|                  |                 | Jacobians of all |                  |
    %|                  |                 | differentiable   |                  |
    %|                  |                 | outputs with     |                  |
    %|                  |                 | respect to all   |                  |
    %|                  |                 | differentiable   |                  |
    %|                  |                 | inputs - if      |                  |
    %|                  |                 | available.       |                  |
    %|                  |                 | [default: true]  |                  |
    %+------------------+-----------------+------------------+------------------+
    %| enable_reverse   | OT_BOOL         | Enable           | casadi::Function |
    %|                  |                 | derivative       | Internal         |
    %|                  |                 | calculation      |                  |
    %|                  |                 | using generated  |                  |
    %|                  |                 | functions for    |                  |
    %|                  |                 | transposed       |                  |
    %|                  |                 | Jacobian-times-  |                  |
    %|                  |                 | vector products  |                  |
    %|                  |                 | - typically      |                  |
    %|                  |                 | using reverse    |                  |
    %|                  |                 | mode AD - if     |                  |
    %|                  |                 | available.       |                  |
    %|                  |                 | [default: true]  |                  |
    %+------------------+-----------------+------------------+------------------+
    %| fd_method        | OT_STRING       | Method for       | casadi::Function |
    %|                  |                 | finite           | Internal         |
    %|                  |                 | differencing     |                  |
    %|                  |                 | [default         |                  |
    %|                  |                 | 'central']       |                  |
    %+------------------+-----------------+------------------+------------------+
    %| fd_options       | OT_DICT         | Options to be    | casadi::Function |
    %|                  |                 | passed to the    | Internal         |
    %|                  |                 | finite           |                  |
    %|                  |                 | difference       |                  |
    %|                  |                 | instance         |                  |
    %+------------------+-----------------+------------------+------------------+
    %| gather_stats     | OT_BOOL         | Deprecated       | casadi::Function |
    %|                  |                 | option           | Internal         |
    %|                  |                 | (ignored):       |                  |
    %|                  |                 | Statistics are   |                  |
    %|                  |                 | now always       |                  |
    %|                  |                 | collected.       |                  |
    %+------------------+-----------------+------------------+------------------+
    %| input_scheme     | OT_STRINGVECTOR | Deprecated       | casadi::Function |
    %|                  |                 | option (ignored) | Internal         |
    %+------------------+-----------------+------------------+------------------+
    %| inputs_check     | OT_BOOL         | Throw exceptions | casadi::Function |
    %|                  |                 | when the         | Internal         |
    %|                  |                 | numerical values |                  |
    %|                  |                 | of the inputs    |                  |
    %|                  |                 | don't make sense |                  |
    %+------------------+-----------------+------------------+------------------+
    %| jac_penalty      | OT_DOUBLE       | When requested   | casadi::Function |
    %|                  |                 | for a number of  | Internal         |
    %|                  |                 | forward/reverse  |                  |
    %|                  |                 | directions, it   |                  |
    %|                  |                 | may be cheaper   |                  |
    %|                  |                 | to compute first |                  |
    %|                  |                 | the full         |                  |
    %|                  |                 | jacobian and     |                  |
    %|                  |                 | then multiply    |                  |
    %|                  |                 | with seeds,      |                  |
    %|                  |                 | rather than      |                  |
    %|                  |                 | obtain the       |                  |
    %|                  |                 | requested        |                  |
    %|                  |                 | directions in a  |                  |
    %|                  |                 | straightforward  |                  |
    %|                  |                 | manner. Casadi   |                  |
    %|                  |                 | uses a heuristic |                  |
    %|                  |                 | to decide which  |                  |
    %|                  |                 | is cheaper. A    |                  |
    %|                  |                 | high value of    |                  |
    %|                  |                 | 'jac_penalty'    |                  |
    %|                  |                 | makes it less    |                  |
    %|                  |                 | likely for the   |                  |
    %|                  |                 | heurstic to      |                  |
    %|                  |                 | chose the full   |                  |
    %|                  |                 | Jacobian         |                  |
    %|                  |                 | strategy. The    |                  |
    %|                  |                 | special value -1 |                  |
    %|                  |                 | indicates never  |                  |
    %|                  |                 | to use the full  |                  |
    %|                  |                 | Jacobian         |                  |
    %|                  |                 | strategy         |                  |
    %+------------------+-----------------+------------------+------------------+
    %| jit              | OT_BOOL         | Use just-in-time | casadi::Function |
    %|                  |                 | compiler to      | Internal         |
    %|                  |                 | speed up the     |                  |
    %|                  |                 | evaluation       |                  |
    %+------------------+-----------------+------------------+------------------+
    %| jit_options      | OT_DICT         | Options to be    | casadi::Function |
    %|                  |                 | passed to the    | Internal         |
    %|                  |                 | jit compiler.    |                  |
    %+------------------+-----------------+------------------+------------------+
    %| max_num_dir      | OT_INT          | Specify the      | casadi::Function |
    %|                  |                 | maximum number   | Internal         |
    %|                  |                 | of directions    |                  |
    %|                  |                 | for derivative   |                  |
    %|                  |                 | functions.       |                  |
    %|                  |                 | Overrules the    |                  |
    %|                  |                 | builtin optimize |                  |
    %|                  |                 | d_num_dir.       |                  |
    %+------------------+-----------------+------------------+------------------+
    %| output_scheme    | OT_STRINGVECTOR | Deprecated       | casadi::Function |
    %|                  |                 | option (ignored) | Internal         |
    %+------------------+-----------------+------------------+------------------+
    %| print_time       | OT_BOOL         | print            | casadi::Function |
    %|                  |                 | information      | Internal         |
    %|                  |                 | about execution  |                  |
    %|                  |                 | time             |                  |
    %+------------------+-----------------+------------------+------------------+
    %| regularity_check | OT_BOOL         | Throw exceptions | casadi::Function |
    %|                  |                 | when NaN or Inf  | Internal         |
    %|                  |                 | appears during   |                  |
    %|                  |                 | evaluation       |                  |
    %+------------------+-----------------+------------------+------------------+
    %| user_data        | OT_VOIDPTR      | A user-defined   | casadi::Function |
    %|                  |                 | field that can   | Internal         |
    %|                  |                 | be used to       |                  |
    %|                  |                 | identify the     |                  |
    %|                  |                 | function or pass |                  |
    %|                  |                 | additional       |                  |
    %|                  |                 | information      |                  |
    %+------------------+-----------------+------------------+------------------+
    %| verbose          | OT_BOOL         | Verbose          | casadi::Function |
    %|                  |                 | evaluation  for  | Internal         |
    %|                  |                 | debugging        |                  |
    %+------------------+-----------------+------------------+------------------+
    %
    %>Input scheme: casadi::ConicInput (CONIC_NUM_IN = 12)
    %
    %+--------------+--------+--------------------------------------------------+
    %|  Full name   | Short  |                   Description                    |
    %+==============+========+==================================================+
    %| CONIC_H      | h      | The square matrix H: sparse, (n x n). Only the   |
    %|              |        | lower triangular part is actually used. The      |
    %|              |        | matrix is assumed to be symmetrical.             |
    %+--------------+--------+--------------------------------------------------+
    %| CONIC_G      | g      | The vector g: dense, (n x 1)                     |
    %+--------------+--------+--------------------------------------------------+
    %| CONIC_A      | a      | The matrix A: sparse, (nc x n) - product with x  |
    %|              |        | must be dense.                                   |
    %+--------------+--------+--------------------------------------------------+
    %| CONIC_LBA    | lba    | dense, (nc x 1)                                  |
    %+--------------+--------+--------------------------------------------------+
    %| CONIC_UBA    | uba    | dense, (nc x 1)                                  |
    %+--------------+--------+--------------------------------------------------+
    %| CONIC_LBX    | lbx    | dense, (n x 1)                                   |
    %+--------------+--------+--------------------------------------------------+
    %| CONIC_UBX    | ubx    | dense, (n x 1)                                   |
    %+--------------+--------+--------------------------------------------------+
    %| CONIC_X0     | x0     | dense, (n x 1)                                   |
    %+--------------+--------+--------------------------------------------------+
    %| CONIC_LAM_X0 | lam_x0 | dense                                            |
    %+--------------+--------+--------------------------------------------------+
    %| CONIC_LAM_A0 | lam_a0 | dense                                            |
    %+--------------+--------+--------------------------------------------------+
    %| CONIC_Q      | q      | The matrix Q: sparse symmetric, (np^2 x n)       |
    %+--------------+--------+--------------------------------------------------+
    %| CONIC_P      | p      | The matrix P: sparse symmetric, (np x np)        |
    %+--------------+--------+--------------------------------------------------+
    %
    %>Output scheme: casadi::ConicOutput (CONIC_NUM_OUT = 4)
    %
    %+-------------+-------+---------------------------------------------------+
    %|  Full name  | Short |                    Description                    |
    %+=============+=======+===================================================+
    %| CONIC_X     | x     | The primal solution.                              |
    %+-------------+-------+---------------------------------------------------+
    %| CONIC_COST  | cost  | The optimal cost.                                 |
    %+-------------+-------+---------------------------------------------------+
    %| CONIC_LAM_A | lam_a | The dual solution corresponding to linear bounds. |
    %+-------------+-------+---------------------------------------------------+
    %| CONIC_LAM_X | lam_x | The dual solution corresponding to simple bounds. |
    %+-------------+-------+---------------------------------------------------+
    %
    %List of plugins
    %===============
    %
    %
    %
    %- clp
    %
    %- cplex
    %
    %- gurobi
    %
    %- hpmpc
    %
    %- ooqp
    %
    %- qpoases
    %
    %- sqic
    %
    %- nlpsol
    %
    %- qrqp
    %
    %Note: some of the plugins in this list might not be available on your
    %system. Also, there might be extra plugins available to you that are not
    %listed here. You can obtain their documentation with
    %Conic.doc("myextraplugin")
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %clp
    %---
    %
    %
    %
    %Interface to Clp solver for sparse Quadratic Programs
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %cplex
    %-----
    %
    %
    %
    %Interface to Cplex solver for sparse Quadratic Programs
    %
    %>List of available options
    %
    %+---------------+-----------+----------------------------------------------+
    %|      Id       |   Type    |                 Description                  |
    %+===============+===========+==============================================+
    %| cplex         | OT_DICT   | Options to be passed to CPLEX                |
    %+---------------+-----------+----------------------------------------------+
    %| dep_check     | OT_INT    | Detect redundant constraints.                |
    %+---------------+-----------+----------------------------------------------+
    %| dump_filename | OT_STRING | The filename to dump to.                     |
    %+---------------+-----------+----------------------------------------------+
    %| dump_to_file  | OT_BOOL   | Dumps QP to file in CPLEX format.            |
    %+---------------+-----------+----------------------------------------------+
    %| qp_method     | OT_INT    | Determines which CPLEX algorithm to use.     |
    %+---------------+-----------+----------------------------------------------+
    %| tol           | OT_DOUBLE | Tolerance of solver                          |
    %+---------------+-----------+----------------------------------------------+
    %| warm_start    | OT_BOOL   | Use warm start with simplex methods (affects |
    %|               |           | only the simplex methods).                   |
    %+---------------+-----------+----------------------------------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %gurobi
    %------
    %
    %
    %
    %Interface to the GUROBI Solver for quadratic programming
    %
    %>List of available options
    %
    %+--------+-----------------+-----------------------------------------------+
    %|   Id   |      Type       |                  Description                  |
    %+========+=================+===============================================+
    %| gurobi | OT_DICT         | Options to be passed to gurobi.               |
    %+--------+-----------------+-----------------------------------------------+
    %| vtype  | OT_STRINGVECTOR | Type of variables:                            |
    %|        |                 | [CONTINUOUS|binary|integer|semicont|semiint]  |
    %+--------+-----------------+-----------------------------------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %hpmpc
    %-----
    %
    %
    %
    %Interface to HMPC Solver
    %
    %In order to use this interface, you must:
    %
    %Decision variables must only by state and control, and the variable ordering
    %must be [x0 u0 x1 u1 ...]
    %
    %The constraints must be in order: [ gap0 lincon0 gap1 lincon1 ]
    %
    %gap: Ak+1 = Ak xk + Bk uk lincon: yk= Ck xk + Dk uk
    %
    %
    %
    %::
    %
    %         A0 B0 -I
    %         C0 D0
    %                A1 B1 -I
    %                C1 D1
    %
    %
    %
    %where I must be a diagonal sparse matrix Either supply all of N, nx, ng, nu
    %options or rely on automatic detection
    %
    %>List of available options
    %
    %+----------------+--------------+------------------------------------------+
    %|       Id       |     Type     |               Description                |
    %+================+==============+==========================================+
    %| N              | OT_INT       | OCP horizon                              |
    %+----------------+--------------+------------------------------------------+
    %| blasfeo_target | OT_STRING    | hpmpc target                             |
    %+----------------+--------------+------------------------------------------+
    %| inf            | OT_DOUBLE    | HPMPC cannot handle infinities.          |
    %|                |              | Infinities will be replaced by this      |
    %|                |              | option's value.                          |
    %+----------------+--------------+------------------------------------------+
    %| max_iter       | OT_INT       | Max number of iterations                 |
    %+----------------+--------------+------------------------------------------+
    %| mu0            | OT_DOUBLE    | Max element in cost function as estimate |
    %|                |              | of max multiplier                        |
    %+----------------+--------------+------------------------------------------+
    %| ng             | OT_INTVECTOR | Number of non-dynamic constraints,       |
    %|                |              | length N+1                               |
    %+----------------+--------------+------------------------------------------+
    %| nu             | OT_INTVECTOR | Number of controls, length N             |
    %+----------------+--------------+------------------------------------------+
    %| nx             | OT_INTVECTOR | Number of states, length N+1             |
    %+----------------+--------------+------------------------------------------+
    %| target         | OT_STRING    | hpmpc target                             |
    %+----------------+--------------+------------------------------------------+
    %| tol            | OT_DOUBLE    | Tolerance in the duality measure         |
    %+----------------+--------------+------------------------------------------+
    %| warm_start     | OT_BOOL      | Use warm-starting                        |
    %+----------------+--------------+------------------------------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %ooqp
    %----
    %
    %
    %
    %Interface to the OOQP Solver for quadratic programming The current
    %implementation assumes that OOQP is configured with the MA27 sparse linear
    %solver.
    %
    %NOTE: when doing multiple calls to evaluate(), check if you need to
    %reInit();
    %
    %>List of available options
    %
    %+-------------+-----------+------------------------------------------------+
    %|     Id      |   Type    |                  Description                   |
    %+=============+===========+================================================+
    %| artol       | OT_DOUBLE | tolerance as provided with setArTol to OOQP    |
    %+-------------+-----------+------------------------------------------------+
    %| mutol       | OT_DOUBLE | tolerance as provided with setMuTol to OOQP    |
    %+-------------+-----------+------------------------------------------------+
    %| print_level | OT_INT    | Print level. OOQP listens to print_level 0, 10 |
    %|             |           | and 100                                        |
    %+-------------+-----------+------------------------------------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %qpoases
    %-------
    %
    %
    %
    %Interface to QPOases Solver for quadratic programming
    %
    %>List of available options
    %
    %+-------------------------------+-----------+------------------------------+
    %|              Id               |   Type    |         Description          |
    %+===============================+===========+==============================+
    %| CPUtime                       | OT_DOUBLE | The maximum allowed CPU time |
    %|                               |           | in seconds for the whole     |
    %|                               |           | initialisation (and the      |
    %|                               |           | actually required one on     |
    %|                               |           | output). Disabled if unset.  |
    %+-------------------------------+-----------+------------------------------+
    %| boundRelaxation               | OT_DOUBLE | Initial relaxation of bounds |
    %|                               |           | to start homotopy and        |
    %|                               |           | initial value for far        |
    %|                               |           | bounds.                      |
    %+-------------------------------+-----------+------------------------------+
    %| boundTolerance                | OT_DOUBLE | If upper and lower bounds    |
    %|                               |           | differ less than this        |
    %|                               |           | tolerance, they are regarded |
    %|                               |           | equal, i.e. as equality      |
    %|                               |           | constraint.                  |
    %+-------------------------------+-----------+------------------------------+
    %| enableCholeskyRefactorisation | OT_INT    | Specifies the frequency of a |
    %|                               |           | full re-factorisation of     |
    %|                               |           | projected Hessian matrix: 0: |
    %|                               |           | turns them off, 1: uses them |
    %|                               |           | at each iteration etc.       |
    %+-------------------------------+-----------+------------------------------+
    %| enableDriftCorrection         | OT_INT    | Specifies the frequency of   |
    %|                               |           | drift corrections: 0: turns  |
    %|                               |           | them off.                    |
    %+-------------------------------+-----------+------------------------------+
    %| enableEqualities              | OT_BOOL   | Specifies whether equalities |
    %|                               |           | should be treated as always  |
    %|                               |           | active (True) or not (False) |
    %+-------------------------------+-----------+------------------------------+
    %| enableFarBounds               | OT_BOOL   | Enables the use of far       |
    %|                               |           | bounds.                      |
    %+-------------------------------+-----------+------------------------------+
    %| enableFlippingBounds          | OT_BOOL   | Enables the use of flipping  |
    %|                               |           | bounds.                      |
    %+-------------------------------+-----------+------------------------------+
    %| enableFullLITests             | OT_BOOL   | Enables condition-hardened   |
    %|                               |           | (but more expensive) LI      |
    %|                               |           | test.                        |
    %+-------------------------------+-----------+------------------------------+
    %| enableInertiaCorrection       | OT_BOOL   | Should working set be        |
    %|                               |           | repaired when negative       |
    %|                               |           | curvature is discovered      |
    %|                               |           | during hotstart.             |
    %+-------------------------------+-----------+------------------------------+
    %| enableNZCTests                | OT_BOOL   | Enables nonzero curvature    |
    %|                               |           | tests.                       |
    %+-------------------------------+-----------+------------------------------+
    %| enableRamping                 | OT_BOOL   | Enables ramping.             |
    %+-------------------------------+-----------+------------------------------+
    %| enableRegularisation          | OT_BOOL   | Enables automatic Hessian    |
    %|                               |           | regularisation.              |
    %+-------------------------------+-----------+------------------------------+
    %| epsDen                        | OT_DOUBLE | Denominator tolerance for    |
    %|                               |           | ratio tests.                 |
    %+-------------------------------+-----------+------------------------------+
    %| epsFlipping                   | OT_DOUBLE | Tolerance of squared         |
    %|                               |           | Cholesky diagonal factor     |
    %|                               |           | which triggers flipping      |
    %|                               |           | bound.                       |
    %+-------------------------------+-----------+------------------------------+
    %| epsIterRef                    | OT_DOUBLE | Early termination tolerance  |
    %|                               |           | for iterative refinement.    |
    %+-------------------------------+-----------+------------------------------+
    %| epsLITests                    | OT_DOUBLE | Tolerance for linear         |
    %|                               |           | independence tests.          |
    %+-------------------------------+-----------+------------------------------+
    %| epsNZCTests                   | OT_DOUBLE | Tolerance for nonzero        |
    %|                               |           | curvature tests.             |
    %+-------------------------------+-----------+------------------------------+
    %| epsNum                        | OT_DOUBLE | Numerator tolerance for      |
    %|                               |           | ratio tests.                 |
    %+-------------------------------+-----------+------------------------------+
    %| epsRegularisation             | OT_DOUBLE | Scaling factor of identity   |
    %|                               |           | matrix used for Hessian      |
    %|                               |           | regularisation.              |
    %+-------------------------------+-----------+------------------------------+
    %| finalRamping                  | OT_DOUBLE | Final value for ramping      |
    %|                               |           | strategy.                    |
    %+-------------------------------+-----------+------------------------------+
    %| growFarBounds                 | OT_DOUBLE | Factor to grow far bounds.   |
    %+-------------------------------+-----------+------------------------------+
    %| hessian_type                  | OT_STRING | Type of Hessian - see        |
    %|                               |           | qpOASES documentation [UNKNO |
    %|                               |           | WN|posdef|semidef|indef|zero |
    %|                               |           | |identity]]                  |
    %+-------------------------------+-----------+------------------------------+
    %| initialFarBounds              | OT_DOUBLE | Initial size for far bounds. |
    %+-------------------------------+-----------+------------------------------+
    %| initialRamping                | OT_DOUBLE | Start value for ramping      |
    %|                               |           | strategy.                    |
    %+-------------------------------+-----------+------------------------------+
    %| initialStatusBounds           | OT_STRING | Initial status of bounds at  |
    %|                               |           | first iteration.             |
    %+-------------------------------+-----------+------------------------------+
    %| linsol_plugin                 | OT_STRING | Linear solver plugin         |
    %+-------------------------------+-----------+------------------------------+
    %| maxDualJump                   | OT_DOUBLE | Maximum allowed jump in dual |
    %|                               |           | variables in linear          |
    %|                               |           | independence tests.          |
    %+-------------------------------+-----------+------------------------------+
    %| maxPrimalJump                 | OT_DOUBLE | Maximum allowed jump in      |
    %|                               |           | primal variables in nonzero  |
    %|                               |           | curvature tests.             |
    %+-------------------------------+-----------+------------------------------+
    %| max_schur                     | OT_INT    | Maximal number of Schur      |
    %|                               |           | updates [75]                 |
    %+-------------------------------+-----------+------------------------------+
    %| nWSR                          | OT_INT    | The maximum number of        |
    %|                               |           | working set recalculations   |
    %|                               |           | to be performed during the   |
    %|                               |           | initial homotopy. Default is |
    %|                               |           | 5(nx + nc)                   |
    %+-------------------------------+-----------+------------------------------+
    %| numRefinementSteps            | OT_INT    | Maximum number of iterative  |
    %|                               |           | refinement steps.            |
    %+-------------------------------+-----------+------------------------------+
    %| numRegularisationSteps        | OT_INT    | Maximum number of successive |
    %|                               |           | regularisation steps.        |
    %+-------------------------------+-----------+------------------------------+
    %| printLevel                    | OT_STRING | Defines the amount of text   |
    %|                               |           | output during QP solution,   |
    %|                               |           | see Section 5.7              |
    %+-------------------------------+-----------+------------------------------+
    %| schur                         | OT_BOOL   | Use Schur Complement         |
    %|                               |           | Approach [false]             |
    %+-------------------------------+-----------+------------------------------+
    %| sparse                        | OT_BOOL   | Formulate the QP using       |
    %|                               |           | sparse matrices. [false]     |
    %+-------------------------------+-----------+------------------------------+
    %| terminationTolerance          | OT_DOUBLE | Relative termination         |
    %|                               |           | tolerance to stop homotopy.  |
    %+-------------------------------+-----------+------------------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %sqic
    %----
    %
    %
    %
    %Interface to the SQIC solver for quadratic programming
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %nlpsol
    %------
    %
    %
    %
    %Solve QPs using an Nlpsol Use the 'nlpsol' option to specify the NLP solver
    %to use.
    %
    %>List of available options
    %
    %+----------------+-----------+---------------------------------+
    %|       Id       |   Type    |           Description           |
    %+================+===========+=================================+
    %| nlpsol         | OT_STRING | Name of solver.                 |
    %+----------------+-----------+---------------------------------+
    %| nlpsol_options | OT_DICT   | Options to be passed to solver. |
    %+----------------+-----------+---------------------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %qrqp
    %----
    %
    %
    %
    %Solve QPs using an active-set method
    %
    %>List of available options
    %
    %+--------------+-----------+-----------------------------------------------+
    %|      Id      |   Type    |                  Description                  |
    %+==============+===========+===============================================+
    %| du_to_pr     | OT_DOUBLE | How much larger dual than primal error is     |
    %|              |           | acceptable [1000]                             |
    %+--------------+-----------+-----------------------------------------------+
    %| max_iter     | OT_INT    | Maximum number of iterations [1000].          |
    %+--------------+-----------+-----------------------------------------------+
    %| print_header | OT_BOOL   | Print header [true].                          |
    %+--------------+-----------+-----------------------------------------------+
    %| print_iter   | OT_BOOL   | Print iterations [true].                      |
    %+--------------+-----------+-----------------------------------------------+
    %| tol          | OT_DOUBLE | Tolerance [1e-8].                             |
    %+--------------+-----------+-----------------------------------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %Joel Andersson
    %
    %
    %
  [varargout{1:nargout}] = casadiMEX(866, varargin{:});
end
