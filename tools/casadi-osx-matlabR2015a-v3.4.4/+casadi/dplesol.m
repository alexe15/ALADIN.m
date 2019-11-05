function varargout = dplesol(varargin)
    %DPLESOL 
    %
    %  {DM} = DPLESOL({DM} A, {DM} V, char solver, struct opts)
    %  MX = DPLESOL(MX A, MX V, char solver, struct opts)
    %  {MX} = DPLESOL({MX} A, {MX} V, char solver, struct opts)
    %  Function = DPLESOL(char name, char solver, struct:Sparsity qp, struct opts)
    %    Discrete periodic Lyapunov Equation solver Given matrices $A_k$ and
    %
    %> DPLESOL({DM} A, {DM} V, char solver, struct opts)
    %> DPLESOL(MX A, MX V, char solver, struct opts)
    %> DPLESOL({MX} A, {MX} V, char solver, struct opts)
    %------------------------------------------------------------------------
    %
    %> DPLESOL(char name, char solver, struct:Sparsity qp, struct opts)
    %------------------------------------------------------------------------
    %
    %
    %Discrete periodic Lyapunov Equation solver Given matrices $A_k$ and
    %symmetric $V_k, k = 0..K-1$
    %
    %::
    %
    %  A_k in R^(n x n)
    %  V_k in R^n
    %  
    %
    %provides all of $P_k$ that satisfy:
    %
    %::
    %
    %  P_0 = A_(K-1)*P_(K-1)*A_(K-1)' + V_k
    %  P_k+1 = A_k*P_k*A_k' + V_k  for k = 1..K-1
    %  
    %
    %
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
    %| const_dim        | OT_BOOL         | Assume constant  | casadi::Dple     |
    %|                  |                 | dimension of P   |                  |
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
    %| eps_unstable     | OT_DOUBLE       | A margin for     | casadi::Dple     |
    %|                  |                 | unstability      |                  |
    %|                  |                 | detection        |                  |
    %+------------------+-----------------+------------------+------------------+
    %| error_unstable   | OT_BOOL         | Throw an         | casadi::Dple     |
    %|                  |                 | exception when   |                  |
    %|                  |                 | it is detected   |                  |
    %|                  |                 | that             |                  |
    %|                  |                 | Product(A_i,     |                  |
    %|                  |                 | i=N..1)has       |                  |
    %|                  |                 | eigenvalues      |                  |
    %|                  |                 | greater than     |                  |
    %|                  |                 | 1-eps_unstable   |                  |
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
    %| pos_def          | OT_BOOL         | Assume P         | casadi::Dple     |
    %|                  |                 | positive         |                  |
    %|                  |                 | definite         |                  |
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
    %>Input scheme: casadi::DpleInput (DPLE_NUM_IN = 2)
    %
    %+-----------+-------+------------------------------------------------------+
    %| Full name | Short |                     Description                      |
    %+===========+=======+======================================================+
    %| DPLE_A    | a     | A matrices (horzcat when const_dim, diagcat          |
    %|           |       | otherwise) [a].                                      |
    %+-----------+-------+------------------------------------------------------+
    %| DPLE_V    | v     | V matrices (horzcat when const_dim, diagcat          |
    %|           |       | otherwise) [v].                                      |
    %+-----------+-------+------------------------------------------------------+
    %
    %>Output scheme: casadi::DpleOutput (DPLE_NUM_OUT = 1)
    %
    %+-----------+-------+------------------------------------------------------+
    %| Full name | Short |                     Description                      |
    %+===========+=======+======================================================+
    %| DPLE_P    | p     | Lyapunov matrix (horzcat when const_dim, diagcat     |
    %|           |       | otherwise) (Cholesky of P if pos_def) [p].           |
    %+-----------+-------+------------------------------------------------------+
    %
    %List of plugins
    %===============
    %
    %
    %
    %- slicot
    %
    %Note: some of the plugins in this list might not be available on your
    %system. Also, there might be extra plugins available to you that are not
    %listed here. You can obtain their documentation with
    %Dple.doc("myextraplugin")
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %slicot
    %------
    %
    %
    %
    %An efficient solver for Discrete Periodic Lyapunov Equations using SLICOT
    %
    %Uses Periodic Schur Decomposition ('psd') and does not assume positive
    %definiteness. Based on Periodic Lyapunov equations: some applications and
    %new algorithms. Int. J. Control, vol. 67, pp. 69-87, 1997.
    %
    %Overview of the method: J. Gillis Practical Methods for Approximate Robust
    %Periodic Optimal Control ofNonlinear Mechanical Systems, PhD Thesis,
    %KULeuven, 2015
    %
    %>List of available options
    %
    %+-----------------------+-----------+--------------------------------------+
    %|          Id           |   Type    |             Description              |
    %+=======================+===========+======================================+
    %| linear_solver         | OT_STRING | User-defined linear solver class.    |
    %|                       |           | Needed for sensitivities.            |
    %+-----------------------+-----------+--------------------------------------+
    %| linear_solver_options | OT_DICT   | Options to be passed to the linear   |
    %|                       |           | solver.                              |
    %+-----------------------+-----------+--------------------------------------+
    %| psd_num_zero          | OT_DOUBLE | Numerical zero used in Periodic      |
    %|                       |           | Schur decomposition with slicot.This |
    %|                       |           | option is needed when your systems   |
    %|                       |           | has Floquet multiplierszero or close |
    %|                       |           | to zero                              |
    %+-----------------------+-----------+--------------------------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %Joris Gillis
    %
    %
    %
  [varargout{1:nargout}] = casadiMEX(919, varargin{:});
end
