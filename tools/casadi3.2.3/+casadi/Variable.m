classdef  Variable < casadi.PrintVariable
    %VARIABLE 
    %
    %   = VARIABLE()
    %
    %
  methods
    function varargout = name(self,varargin)
    %NAME 
    %
    %  char = NAME(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1017, self, varargin{:});
    end
    function v = v(self)
      v = casadiMEX(1018, self);
    end
    function v = d(self)
      v = casadiMEX(1019, self);
    end
    function v = nominal(self)
      v = casadiMEX(1020, self);
    end
    function v = start(self)
      v = casadiMEX(1021, self);
    end
    function v = min(self)
      v = casadiMEX(1022, self);
    end
    function v = max(self)
      v = casadiMEX(1023, self);
    end
    function v = guess(self)
      v = casadiMEX(1024, self);
    end
    function v = derivative_start(self)
      v = casadiMEX(1025, self);
    end
    function v = variability(self)
      v = casadiMEX(1026, self);
    end
    function v = causality(self)
      v = casadiMEX(1027, self);
    end
    function v = category(self)
      v = casadiMEX(1028, self);
    end
    function v = alias(self)
      v = casadiMEX(1029, self);
    end
    function v = description(self)
      v = casadiMEX(1030, self);
    end
    function v = valueReference(self)
      v = casadiMEX(1031, self);
    end
    function v = unit(self)
      v = casadiMEX(1032, self);
    end
    function v = display_unit(self)
      v = casadiMEX(1033, self);
    end
    function v = free(self)
      v = casadiMEX(1034, self);
    end
    function varargout = print(self,varargin)
    %PRINT 
    %
    %  PRINT(self, bool trailing_newline)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1035, self, varargin{:});
    end
    function varargout = disp(self,varargin)
    %DISP 
    %
    %  DISP(self, bool trailing_newline)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1036, self, varargin{:});
    end
    function self = Variable(varargin)
    %VARIABLE 
    %
    %  new_obj = VARIABLE()
    %  new_obj = VARIABLE(char name, Sparsity sp)
    %
    %
      self@casadi.PrintVariable(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(1037, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];
      end
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(1038, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
