function varargout = interpolant(varargin)
    %INTERPOLANT An interpolant function for lookup table data
    %
    %  Function = INTERPOLANT(char name, char solver, {[double]} grid, [double] values, struct opts)
    %
    %
    %Parameters:
    %-----------
    %
    %name:  label for the resulting Function
    %
    %solver:  name of the plugin
    %
    %grid:  collection of 1D grids whose outer product defines the full N-D
    %rectangular grid
    %
    %values:  flattened vector of all values for all gridpoints
    %
    %Syntax 1D
    %
    %::
    %
    %  * # Python
    %  * xgrid = np.linspace(1,6,6)
    %  * V = [-1,-1,-2,-3,0,2]
    %  * LUT = casadi.interpolant("LUT","bspline",[xgrid],V)
    %  * print(LUT(2.5))
    %  * 
    %
    %
    %
    %::
    %
    %  * % Matlab
    %  * xgrid = 1:6;
    %  * V = [-1 -1 -2 -3 0 2];
    %  * LUT = casadi.interpolant('LUT','bspline',{xgrid},V);
    %  * LUT(2.5)
    %  * 
    %
    %
    %
    %Syntax 2D
    %
    %::
    %
    %  * # Python
    %  * xgrid = np.linspace(-5,5,11)
    %  * ygrid = np.linspace(-4,4,9)
    %  * X,Y = np.meshgrid(xgrid,ygrid,indexing='ij')
    %  * R = np.sqrt(5*X**2 + Y**2)+ 1
    %  * data = np.sin(R)/R
    %  * data_flat = data.ravel(order='F')
    %  * LUT = casadi.interpolant('name','bspline',[xgrid,ygrid],data_flat)
    %  * print(LUT([0.5,1]))
    %  * \\enverbatim
    %  * \\verbatim
    %  * % Matlab
    %  * xgrid = -5:1:5;
    %  * ygrid = -4:1:4;
    %  * R = sqrt(5*X.^2 + Y.^2)+ 1;
    %  * V = sin(R)./(R);
    %  * LUT = interpolant('LUT','bspline',{xgrid, ygrid},V(:));
    %  * LUT([0.5 1])
    %  * 
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
    %| lookup_mode      | OT_STRINGVECTOR | Specifies, for   | casadi::Interpol |
    %|                  |                 | each grid        | ant              |
    %|                  |                 | dimenion, the    |                  |
    %|                  |                 | lookup algorithm |                  |
    %|                  |                 | used to find the |                  |
    %|                  |                 | correct index.   |                  |
    %|                  |                 | 'linear' uses a  |                  |
    %|                  |                 | for-loop +       |                  |
    %|                  |                 | break; (default  |                  |
    %|                  |                 | when             |                  |
    %|                  |                 | #knots<=100),    |                  |
    %|                  |                 | 'exact' uses     |                  |
    %|                  |                 | floored division |                  |
    %|                  |                 | (only for        |                  |
    %|                  |                 | uniform grids),  |                  |
    %|                  |                 | 'binary' uses a  |                  |
    %|                  |                 | binary search.   |                  |
    %|                  |                 | (default when    |                  |
    %|                  |                 | #knots>100).     |                  |
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
    %List of plugins
    %===============
    %
    %
    %
    %- bspline
    %
    %- linear
    %
    %Note: some of the plugins in this list might not be available on your
    %system. Also, there might be extra plugins available to you that are not
    %listed here. You can obtain their documentation with
    %Interpolant.doc("myextraplugin")
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %bspline
    %-------
    %
    %
    %
    %>List of available options
    %
    %+--------------------+--------------+--------------------------------------+
    %|         Id         |     Type     |             Description              |
    %+====================+==============+======================================+
    %| algorithm          | OT_STRING    | Algorithm used for fitting the data: |
    %|                    |              | 'not_a_knot' (default, same as       |
    %|                    |              | Matlab), 'smooth_linear'.            |
    %+--------------------+--------------+--------------------------------------+
    %| degree             | OT_INTVECTOR | Sets, for each grid dimension, the   |
    %|                    |              | degree of the spline.                |
    %+--------------------+--------------+--------------------------------------+
    %| linear_solver      | OT_STRING    | Solver used for constructing the     |
    %|                    |              | coefficient tensor.                  |
    %+--------------------+--------------+--------------------------------------+
    %| smooth_linear_frac | OT_DOUBLE    | When 'smooth_linear' algorithm is    |
    %|                    |              | active, determines sharpness between |
    %|                    |              | 0 (sharp, as linear interpolation)   |
    %|                    |              | and 0.5 (smooth).Default value is    |
    %|                    |              | 0.1.                                 |
    %+--------------------+--------------+--------------------------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %linear
    %------
    %
    %
    %
    %>List of available options
    %
    %+-------------+-----------------+------------------------------------------+
    %|     Id      |      Type       |               Description                |
    %+=============+=================+==========================================+
    %| lookup_mode | OT_STRINGVECTOR | Sets, for each grid dimenion, the lookup |
    %|             |                 | algorithm used to find the correct       |
    %|             |                 | index. 'linear' uses a for-loop + break; |
    %|             |                 | 'exact' uses floored division (only for  |
    %|             |                 | uniform grids).                          |
    %+-------------+-----------------+------------------------------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %Joel Andersson
    %
    %
    %
  [varargout{1:nargout}] = casadiMEX(933, varargin{:});
end
