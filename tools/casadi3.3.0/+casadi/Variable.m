classdef  Variable < casadi.PrintableCommon
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
      [varargout{1:nargout}] = casadiMEX(1007, self, varargin{:});
    end
    function v = v(self)
      v = casadiMEX(1008, self);
    end
    function v = d(self)
      v = casadiMEX(1009, self);
    end
    function v = nominal(self)
      v = casadiMEX(1010, self);
    end
    function v = start(self)
      v = casadiMEX(1011, self);
    end
    function v = min(self)
      v = casadiMEX(1012, self);
    end
    function v = max(self)
      v = casadiMEX(1013, self);
    end
    function v = guess(self)
      v = casadiMEX(1014, self);
    end
    function v = derivative_start(self)
      v = casadiMEX(1015, self);
    end
    function v = variability(self)
      v = casadiMEX(1016, self);
    end
    function v = causality(self)
      v = casadiMEX(1017, self);
    end
    function v = category(self)
      v = casadiMEX(1018, self);
    end
    function v = alias(self)
      v = casadiMEX(1019, self);
    end
    function v = description(self)
      v = casadiMEX(1020, self);
    end
    function v = valueReference(self)
      v = casadiMEX(1021, self);
    end
    function v = unit(self)
      v = casadiMEX(1022, self);
    end
    function v = display_unit(self)
      v = casadiMEX(1023, self);
    end
    function v = free(self)
      v = casadiMEX(1024, self);
    end
    function varargout = type_name(self,varargin)
    %TYPE_NAME 
    %
    %  char = TYPE_NAME(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1025, self, varargin{:});
    end
    function varargout = disp(self,varargin)
    %DISP 
    %
    %  std::ostream & = DISP(self, bool more)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1026, self, varargin{:});
    end
    function varargout = str(self,varargin)
    %STR 
    %
    %  char = STR(self, bool more)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1027, self, varargin{:});
    end
    function self = Variable(varargin)
    %VARIABLE 
    %
    %  new_obj = VARIABLE()
    %  new_obj = VARIABLE(char name, Sparsity sp)
    %
    %
      self@casadi.PrintableCommon(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(1028, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];
      end
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(1029, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
