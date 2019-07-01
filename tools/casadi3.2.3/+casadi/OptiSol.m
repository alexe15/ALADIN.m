classdef  OptiSol < SwigRef
    %OPTISOL A simplified interface for NLP modeling/solving.
    %
    %
    %
    %This class offers a view with solution retrieval facilities The API is
    %guaranteed to be stable.
    %
    %Example NLP:
    %
    %::
    %
    %    opti = casadi.Opti();
    %  
    %    x = opti.variable();
    %    y = opti.variable();
    %  
    %    opti.minimize(  (y-x^2)^2   );
    %    opti.subject_to( x^2+y^2==1 );
    %    opti.subject_to(     x+y>=1 );
    %  
    %    opti.solver('ipopt');
    %    sol = opti.solve();
    %  
    %    sol.value(x)
    %    sol.value(y)
    %
    %
    %
    %Example parametric NLP:
    %
    %::
    %
    %    opti = casadi.Opti();
    %  
    %    x = opti.variable(2,1);
    %    p = opti.parameter();
    %  
    %    opti.minimize(  (p*x(2)-x(1)^2)^2   );
    %    opti.subject_to( 1<=sum(x)<=2 );
    %  
    %    opti.solver('ipopt');
    %  
    %    opti.set_value(p, 3);
    %    sol = opti.solve();
    %    sol.value(x)
    %  
    %    opti.set_value(p, 5);
    %    sol = opti.solve();
    %    sol.value(x)
    %
    %
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
      [varargout{1:nargout}] = casadiMEX(1235, self, varargin{:});
    end
    function varargout = getRepresentation(self,varargin)
    %GETREPRESENTATION 
    %
    %  char = GETREPRESENTATION(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1236, self, varargin{:});
    end
    function varargout = disp(self,varargin)
    %DISP Print representation.
    %
    %  DISP(self, bool trailing_newline)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1237, self, varargin{:});
    end
    function varargout = print(self,varargin)
    %PRINT Print description.
    %
    %  PRINT(self, bool trailing_newline)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1238, self, varargin{:});
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
      [varargout{1:nargout}] = casadiMEX(1239, self, varargin{:});
    end
    function varargout = value_variables(self,varargin)
    %VALUE_VARIABLES get assignment expressions for latest values
    %
    %  {MX} = VALUE_VARIABLES(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(1240, self, varargin{:});
    end
    function varargout = value_parameters(self,varargin)
    %VALUE_PARAMETERS 
    %
    %  {MX} = VALUE_PARAMETERS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1241, self, varargin{:});
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
      [varargout{1:nargout}] = casadiMEX(1242, self, varargin{:});
    end
    function varargout = debug(self,varargin)
    %DEBUG 
    %
    %  OptiStack = DEBUG(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1243, self, varargin{:});
    end
    function varargout = opti(self,varargin)
    %OPTI 
    %
    %  Opti = OPTI(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1244, self, varargin{:});
    end
    function self = OptiSol(varargin)
    %OPTISOL 
    %
    %  new_obj = OPTISOL(OptiStack opti)
    %
    %
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(1245, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];
      end
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(1246, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
