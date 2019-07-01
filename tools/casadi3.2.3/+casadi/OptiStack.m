classdef  OptiStack < casadi.PrintOptiStack
    %OPTISTACK A simplified interface for NLP modeling/solving.
    %
    %
    %
    %This is the low-level base class. Direct usage of this class is not
    %recommended unless for debugging. There are no guaranties API stability
    %
    %Joris Gillis, Erik Lambrechts
    %
    %C++ includes: optistack.hpp 
    %
  methods
    function varargout = variable(self,varargin)
    %VARIABLE Create a decision variable (symbol)
    %
    %  MX = VARIABLE(self, int n, int m, char attribute)
    %
    %
    %The order of creation matters. The order will be reflected in the
    %optimization problem. It is not required for decision variables to actualy
    %appear in the optimization problem.
    %
    %Parameters:
    %-----------
    %
    %n:  number of rows (default 1)
    %
    %m:  number of columnss (default 1)
    %
    %attribute:  'full' (default) or 'symmetric'
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1124, self, varargin{:});
    end
    function varargout = parameter(self,varargin)
    %PARAMETER Create a parameter (symbol); fixed during optimization.
    %
    %  MX = PARAMETER(self, int n, int m, char attribute)
    %
    %
    %The order of creation does not matter. It is not required for parameter to
    %actualy appear in the optimization problem. Parameters that do appear, must
    %be given a value before the problem can be solved.
    %
    %Parameters:
    %-----------
    %
    %n:  number of rows (default 1)
    %
    %m:  number of columnss (default 1)
    %
    %attribute:  'full' (default) or 'symmetric'
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1125, self, varargin{:});
    end
    function varargout = minimize(self,varargin)
    %MINIMIZE Set objective.
    %
    %  MINIMIZE(self, MX f)
    %
    %
    %Objective must be a scalar. Default objective: 0 When method is called
    %multiple times, the last call takes effect
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1126, self, varargin{:});
    end
    function varargout = subject_to(self,varargin)
    %SUBJECT_TO Clear constraints.
    %
    %  SUBJECT_TO(self)
    %  SUBJECT_TO(self, MX g)
    %    Add constraints.
    %  SUBJECT_TO(self, {MX} g)
    %    Add constraints.
    %
    %
    %
    %> SUBJECT_TO(self)
    %------------------------------------------------------------------------
    %
    %
    %Clear constraints.
    %
    %
    %> SUBJECT_TO(self, MX g)
    %> SUBJECT_TO(self, {MX} g)
    %------------------------------------------------------------------------
    %
    %
    %Add constraints.
    %
    %Examples:
    %
    %::
    %
    %  * \\begin{itemize}
    %  * opti.subject_to( sqrt(x+y) >= 1);
    %  * opti.subject_to( sqrt(x+y) > 1)}: same as above
    %  * opti.subject_to( 1<= sqrt(x+y) )}: same as above
    %  * opti.subject_to( 5*x+y==1 )}: equality
    %  *
    %  * Python
    %  * opti.subject_to([x*y>=1,x==3])
    %  * opti.subject_to(opti.bounded(0,x,1))
    %  *
    %  * MATLAB
    %  * opti.subject_to({x*y>=1,x==3})
    %  * opti.subject_to( 0<=x<=1 )
    %  * 
    %
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1127, self, varargin{:});
    end
    function varargout = set_initial(self,varargin)
    %SET_INITIAL Set initial guess for decision variables
    %
    %  SET_INITIAL(self, {MX} assignments)
    %  SET_INITIAL(self, MX x, DM v)
    %
    %
    %::
    %
    %  * opti.set_initial(x, 2)
    %  * opti.set_initial(10*x(1), 2)
    %  * 
    %
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1128, self, varargin{:});
    end
    function varargout = set_value(self,varargin)
    %SET_VALUE Set value of parameter.
    %
    %  SET_VALUE(self, {MX} assignments)
    %  SET_VALUE(self, MX x, DM v)
    %
    %
    %Each parameter must be given a value before 'solve' can be called
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1129, self, varargin{:});
    end
    function varargout = solve(self,varargin)
    %SOLVE Crunch the numbers; solve the problem.
    %
    %  OptiSol = SOLVE(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1130, self, varargin{:});
    end
    function varargout = value(self,varargin)
    %VALUE Obtain value of expression at the current value
    %
    %  double = VALUE(self, DM x, {MX} values)
    %  double = VALUE(self, SX x, {MX} values)
    %  double = VALUE(self, MX x, {MX} values)
    %
    %
    %In regular mode, teh current value is the converged solution In debug mode,
    %the value can be non-converged
    %
    %Parameters:
    %-----------
    %
    %values:  Optional assignment expressions (e.g. x==3) to overrule the current
    %value
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1131, self, varargin{:});
    end
    function varargout = copy(self,varargin)
    %COPY Copy.
    %
    %  OptiStack = COPY(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1132, self, varargin{:});
    end
    function varargout = stats(self,varargin)
    %STATS Get statistics.
    %
    %  struct = STATS(self)
    %
    %
    %nlpsol stats are passed as-is. No stability can be guaranteed about this
    %part of the API
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1133, self, varargin{:});
    end
    function varargout = return_status(self,varargin)
    %RETURN_STATUS Get return status of solver passed as-is from nlpsol No stability can be
    %
    %  char = RETURN_STATUS(self)
    %
    %guaranteed about this part of the API.
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1134, self, varargin{:});
    end
    function varargout = solver(self,varargin)
    %SOLVER Get the underlying CasADi solver of the Opti stack.
    %
    %  Function = SOLVER(self)
    %  SOLVER(self, char solver, struct options)
    %    Set a solver.
    %
    %
    %
    %> SOLVER(self)
    %------------------------------------------------------------------------
    %
    %
    %Get the underlying CasADi solver of the Opti stack.
    %
    %
    %> SOLVER(self, char solver, struct options)
    %------------------------------------------------------------------------
    %
    %
    %Set a solver.
    %
    %Parameters:
    %-----------
    %
    %solver:  any of the nlpsol plugins can be used here In practice, not all
    %nlpsol plugins may be supported yet
    %
    %options:  passed on to nlpsol No stability can be guaranteed about this part
    %of the API
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1135, self, varargin{:});
    end
    function varargout = initial(self,varargin)
    %INITIAL get assignment expressions for initial values
    %
    %  {MX} = INITIAL(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1136, self, varargin{:});
    end
    function varargout = value_variables(self,varargin)
    %VALUE_VARIABLES get assignment expressions for latest values
    %
    %  {MX} = VALUE_VARIABLES(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1137, self, varargin{:});
    end
    function varargout = value_parameters(self,varargin)
    %VALUE_PARAMETERS 
    %
    %  {MX} = VALUE_PARAMETERS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1138, self, varargin{:});
    end
    function varargout = callback_class(self,varargin)
    %CALLBACK_CLASS 
    %
    %  CALLBACK_CLASS(self)
    %  CALLBACK_CLASS(self, OptiCallback callback)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1139, self, varargin{:});
    end
    function varargout = is_parametric(self,varargin)
    %IS_PARAMETRIC return true if expression is only dependant on Opti parameters, not
    %
    %  bool = IS_PARAMETRIC(self, MX expr)
    %
    %variables
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1140, self, varargin{:});
    end
    function varargout = symvar(self,varargin)
    %SYMVAR Get symbols present in expression.
    %
    %  {MX} = SYMVAR(self)
    %  {MX} = SYMVAR(self, MX expr)
    %  {MX} = SYMVAR(self, MX expr, casadi::OptiStack::VariableType type)
    %
    %
    %Returned vector is ordered according to the order of variable()/parameter()
    %calls used to create the variables
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1141, self, varargin{:});
    end
    function varargout = canon_expr(self,varargin)
    %CANON_EXPR Interpret an expression (for internal use only)
    %
    %  MetaCon = CANON_EXPR(self, MX expr)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1142, self, varargin{:});
    end
    function varargout = get_meta(self,varargin)
    %GET_META Get meta-data of symbol (for internal use only)
    %
    %  MetaVar = GET_META(self, MX m)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1143, self, varargin{:});
    end
    function varargout = get_meta_con(self,varargin)
    %GET_META_CON Get meta-data of symbol (for internal use only)
    %
    %  MetaCon = GET_META_CON(self, MX m)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1144, self, varargin{:});
    end
    function varargout = set_meta(self,varargin)
    %SET_META Set meta-data of an expression.
    %
    %  SET_META(self, MX m, MetaVar meta)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1145, self, varargin{:});
    end
    function varargout = set_meta_con(self,varargin)
    %SET_META_CON Set meta-data of an expression.
    %
    %  SET_META_CON(self, MX m, MetaCon meta)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1146, self, varargin{:});
    end
    function varargout = dual(self,varargin)
    %DUAL get the dual variable
    %
    %  MX = DUAL(self, MX m)
    %
    %
    %m must be a constraint expression. The returned value is still a symbolic
    %expression. Use value on it to obtain the numerical value.
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1147, self, varargin{:});
    end
    function varargout = assert_active_symbol(self,varargin)
    %ASSERT_ACTIVE_SYMBOL 
    %
    %  ASSERT_ACTIVE_SYMBOL(self, MX m)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1148, self, varargin{:});
    end
    function varargout = active_symvar(self,varargin)
    %ACTIVE_SYMVAR 
    %
    %  {MX} = ACTIVE_SYMVAR(self, casadi::OptiStack::VariableType type)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1149, self, varargin{:});
    end
    function varargout = active_values(self,varargin)
    %ACTIVE_VALUES 
    %
    %  {DM} = ACTIVE_VALUES(self, casadi::OptiStack::VariableType type)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1150, self, varargin{:});
    end
    function varargout = solve_prepare(self,varargin)
    %SOLVE_PREPARE 
    %
    %  SOLVE_PREPARE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1151, self, varargin{:});
    end
    function varargout = solve_actual(self,varargin)
    %SOLVE_ACTUAL 
    %
    %  struct:DM = SOLVE_ACTUAL(self, struct:DM args)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1152, self, varargin{:});
    end
    function varargout = arg(self,varargin)
    %ARG 
    %
    %  struct:DM = ARG(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1153, self, varargin{:});
    end
    function varargout = res(self,varargin)
    %RES 
    %
    %  RES(self, struct:DM res)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1154, self, varargin{:});
    end
    function varargout = constraints(self,varargin)
    %CONSTRAINTS 
    %
    %  {MX} = CONSTRAINTS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1155, self, varargin{:});
    end
    function varargout = objective(self,varargin)
    %OBJECTIVE 
    %
    %  MX = OBJECTIVE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1156, self, varargin{:});
    end
    function varargout = nx(self,varargin)
    %NX Number of (scalarised) decision variables.
    %
    %  int = NX(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1157, self, varargin{:});
    end
    function varargout = np(self,varargin)
    %NP Number of (scalarised) parameters.
    %
    %  int = NP(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1158, self, varargin{:});
    end
    function varargout = ng(self,varargin)
    %NG Number of (scalarised) constraints.
    %
    %  int = NG(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1159, self, varargin{:});
    end
    function varargout = x(self,varargin)
    %X Get all (scalarised) decision variables as a symbolic column vector.
    %
    %  MX = X(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1160, self, varargin{:});
    end
    function varargout = p(self,varargin)
    %P Get all (scalarised) parameters as a symbolic column vector.
    %
    %  MX = P(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1161, self, varargin{:});
    end
    function varargout = g(self,varargin)
    %G Get all (scalarised) constraint expressions as a column vector.
    %
    %  MX = G(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1162, self, varargin{:});
    end
    function varargout = f(self,varargin)
    %F Get objective expression.
    %
    %  MX = F(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1163, self, varargin{:});
    end
    function varargout = lam_g(self,varargin)
    %LAM_G Get all (scalarised) dual variables as a symbolic column vector.
    %
    %  MX = LAM_G(self)
    %
    %
    %Useful for obtaining the Lagrange Hessian:
    %
    %::
    %
    %  * sol.value(hessian(opti.f+opti.lam_g'*opti.g,opti.x)) % MATLAB
    %  * sol.value(hessian(opti.f+dot(opti.lam_g,opti.g),opti.x)[0]) # Python
    %  * 
    %
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1164, self, varargin{:});
    end
    function varargout = assert_empty(self,varargin)
    %ASSERT_EMPTY 
    %
    %  ASSERT_EMPTY(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1165, self, varargin{:});
    end
    function varargout = disp(self,varargin)
    %DISP Print representation.
    %
    %  DISP(self, bool trailing_newline)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1166, self, varargin{:});
    end
    function varargout = print(self,varargin)
    %PRINT Print description.
    %
    %  PRINT(self, bool trailing_newline)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1167, self, varargin{:});
    end
    function varargout = internal_bake(self,varargin)
    %INTERNAL_BAKE Fix the structure of the optimization problem.
    %
    %  INTERNAL_BAKE(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1168, self, varargin{:});
    end
    function v = problem_dirty_(self)
      v = casadiMEX(1169, self);
    end
    function varargout = mark_problem_dirty(self,varargin)
    %MARK_PROBLEM_DIRTY 
    %
    %  MARK_PROBLEM_DIRTY(self, bool flag)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1170, self, varargin{:});
    end
    function varargout = problem_dirty(self,varargin)
    %PROBLEM_DIRTY 
    %
    %  bool = PROBLEM_DIRTY(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1171, self, varargin{:});
    end
    function v = solver_dirty_(self)
      v = casadiMEX(1172, self);
    end
    function varargout = mark_solver_dirty(self,varargin)
    %MARK_SOLVER_DIRTY 
    %
    %  MARK_SOLVER_DIRTY(self, bool flag)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1173, self, varargin{:});
    end
    function varargout = solver_dirty(self,varargin)
    %SOLVER_DIRTY 
    %
    %  bool = SOLVER_DIRTY(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1174, self, varargin{:});
    end
    function v = solved_(self)
      v = casadiMEX(1175, self);
    end
    function varargout = mark_solved(self,varargin)
    %MARK_SOLVED 
    %
    %  MARK_SOLVED(self, bool flag)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1176, self, varargin{:});
    end
    function varargout = solved(self,varargin)
    %SOLVED 
    %
    %  bool = SOLVED(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1177, self, varargin{:});
    end
    function varargout = assert_solved(self,varargin)
    %ASSERT_SOLVED 
    %
    %  ASSERT_SOLVED(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1178, self, varargin{:});
    end
    function varargout = assert_baked(self,varargin)
    %ASSERT_BAKED 
    %
    %  ASSERT_BAKED(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1179, self, varargin{:});
    end
    function self = OptiStack(varargin)
    %OPTISTACK 
    %
    %  new_obj = OPTISTACK()
    %    Create Opti Context.
    %
    %
      self@casadi.PrintOptiStack(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(1180, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];
      end
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(1181, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
    function v = OPTI_GENERIC_EQUALITY()
      persistent vInitialized;
      if isempty(vInitialized)
        vInitialized = casadiMEX(0, 125);
      end
      v = vInitialized;
    end
    function v = OPTI_GENERIC_INEQUALITY()
      persistent vInitialized;
      if isempty(vInitialized)
        vInitialized = casadiMEX(0, 126);
      end
      v = vInitialized;
    end
    function v = OPTI_EQUALITY()
      persistent vInitialized;
      if isempty(vInitialized)
        vInitialized = casadiMEX(0, 127);
      end
      v = vInitialized;
    end
    function v = OPTI_INEQUALITY()
      persistent vInitialized;
      if isempty(vInitialized)
        vInitialized = casadiMEX(0, 128);
      end
      v = vInitialized;
    end
    function v = OPTI_DOUBLE_INEQUALITY()
      persistent vInitialized;
      if isempty(vInitialized)
        vInitialized = casadiMEX(0, 129);
      end
      v = vInitialized;
    end
    function v = OPTI_PSD()
      persistent vInitialized;
      if isempty(vInitialized)
        vInitialized = casadiMEX(0, 130);
      end
      v = vInitialized;
    end
    function v = OPTI_UNKNOWN()
      persistent vInitialized;
      if isempty(vInitialized)
        vInitialized = casadiMEX(0, 131);
      end
      v = vInitialized;
    end
    function v = OPTI_VAR()
      persistent vInitialized;
      if isempty(vInitialized)
        vInitialized = casadiMEX(0, 132);
      end
      v = vInitialized;
    end
    function v = OPTI_PAR()
      persistent vInitialized;
      if isempty(vInitialized)
        vInitialized = casadiMEX(0, 133);
      end
      v = vInitialized;
    end
    function v = OPTI_DUAL_G()
      persistent vInitialized;
      if isempty(vInitialized)
        vInitialized = casadiMEX(0, 134);
      end
      v = vInitialized;
    end
  end
end
