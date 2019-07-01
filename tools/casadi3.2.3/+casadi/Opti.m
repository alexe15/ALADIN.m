classdef  Opti < SwigRef
    %OPTI A simplified interface for NLP modeling/solving.
    %
    %
    %
    %This class offers a view with model description facilities The API is
    %guaranteed to be stable.
    %
    %Joris Gillis, Erik Lambrechts
    %
    %C++ includes: optistack.hpp 
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function varargout = getDescription(self,varargin)
    %GETDESCRIPTION 
    %
    %  char = GETDESCRIPTION(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1206, self, varargin{:});
    end
    function varargout = getRepresentation(self,varargin)
    %GETREPRESENTATION 
    %
    %  char = GETREPRESENTATION(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1207, self, varargin{:});
    end
    function varargout = disp(self,varargin)
    %DISP Print representation.
    %
    %  DISP(self, bool trailing_newline)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1208, self, varargin{:});
    end
    function varargout = print(self,varargin)
    %PRINT Print description.
    %
    %  PRINT(self, bool trailing_newline)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1209, self, varargin{:});
    end
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
      [varargout{1:nargout}] = casadiMEX(1210, self, varargin{:});
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
      [varargout{1:nargout}] = casadiMEX(1211, self, varargin{:});
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
      [varargout{1:nargout}] = casadiMEX(1212, self, varargin{:});
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
      [varargout{1:nargout}] = casadiMEX(1213, self, varargin{:});
    end
    function varargout = solver(self,varargin)
    %SOLVER Set a solver.
    %
    %  SOLVER(self, char solver, struct options)
    %
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
      [varargout{1:nargout}] = casadiMEX(1214, self, varargin{:});
    end
    function varargout = solve(self,varargin)
    %SOLVE Crunch the numbers; solve the problem.
    %
    %  OptiSol = SOLVE(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1215, self, varargin{:});
    end
    function varargout = debug(self,varargin)
    %DEBUG 
    %
    %  OptiStack = DEBUG(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1216, self, varargin{:});
    end
    function varargout = copy(self,varargin)
    %COPY 
    %
    %  Opti = COPY(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1217, self, varargin{:});
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
      [varargout{1:nargout}] = casadiMEX(1218, self, varargin{:});
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
      [varargout{1:nargout}] = casadiMEX(1219, self, varargin{:});
    end
    function varargout = initial(self,varargin)
    %INITIAL get assignment expressions for initial values
    %
    %  {MX} = INITIAL(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1220, self, varargin{:});
    end
    function varargout = constraints(self,varargin)
    %CONSTRAINTS 
    %
    %  {MX} = CONSTRAINTS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1221, self, varargin{:});
    end
    function varargout = objective(self,varargin)
    %OBJECTIVE 
    %
    %  MX = OBJECTIVE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1222, self, varargin{:});
    end
    function varargout = callback_class(self,varargin)
    %CALLBACK_CLASS 
    %
    %  CALLBACK_CLASS(self)
    %  CALLBACK_CLASS(self, OptiCallback callback)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1223, self, varargin{:});
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
      [varargout{1:nargout}] = casadiMEX(1224, self, varargin{:});
    end
    function varargout = nx(self,varargin)
    %NX Number of (scalarised) decision variables.
    %
    %  int = NX(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1225, self, varargin{:});
    end
    function varargout = ng(self,varargin)
    %NG Number of (scalarised) constraints.
    %
    %  int = NG(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1226, self, varargin{:});
    end
    function varargout = np(self,varargin)
    %NP Number of (scalarised) parameters.
    %
    %  int = NP(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1227, self, varargin{:});
    end
    function varargout = x(self,varargin)
    %X Get all (scalarised) decision variables as a symbolic column vector.
    %
    %  MX = X(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1228, self, varargin{:});
    end
    function varargout = p(self,varargin)
    %P Get all (scalarised) parameters as a symbolic column vector.
    %
    %  MX = P(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1229, self, varargin{:});
    end
    function varargout = f(self,varargin)
    %F Get objective expression.
    %
    %  MX = F(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1230, self, varargin{:});
    end
    function varargout = g(self,varargin)
    %G Get all (scalarised) constraint expressions as a column vector.
    %
    %  MX = G(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1231, self, varargin{:});
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
      [varargout{1:nargout}] = casadiMEX(1232, self, varargin{:});
    end

    function [] = callback(self, varargin)
      casadi.OptiCallbackHelper.callback_setup(self, varargin{:})
    end
      function self = Opti(varargin)
    %OPTI 
    %
    %  new_obj = OPTI()
    %
    %
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(1233, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];
      end
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(1234, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
