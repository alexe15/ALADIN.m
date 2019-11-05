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
      [varargout{1:nargout}] = casadiMEX(1032, self, varargin{:});
    end
    function v = v(self)
      v = casadiMEX(1033, self);
    end
    function v = d(self)
      v = casadiMEX(1034, self);
    end
    function v = nominal(self)
      v = casadiMEX(1035, self);
    end
    function v = start(self)
      v = casadiMEX(1036, self);
    end
    function v = min(self)
      v = casadiMEX(1037, self);
    end
    function v = max(self)
      v = casadiMEX(1038, self);
    end
    function v = guess(self)
      v = casadiMEX(1039, self);
    end
    function v = derivative_start(self)
      v = casadiMEX(1040, self);
    end
    function v = variability(self)
      v = casadiMEX(1041, self);
    end
    function v = causality(self)
      v = casadiMEX(1042, self);
    end
    function v = category(self)
      v = casadiMEX(1043, self);
    end
    function v = alias(self)
      v = casadiMEX(1044, self);
    end
    function v = description(self)
      v = casadiMEX(1045, self);
    end
    function v = valueReference(self)
      v = casadiMEX(1046, self);
    end
    function v = unit(self)
      v = casadiMEX(1047, self);
    end
    function v = display_unit(self)
      v = casadiMEX(1048, self);
    end
    function v = free(self)
      v = casadiMEX(1049, self);
    end
    function varargout = type_name(self,varargin)
    %TYPE_NAME 
    %
    %  char = TYPE_NAME(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1050, self, varargin{:});
    end
    function varargout = disp(self,varargin)
    %DISP 
    %
    %  std::ostream & = DISP(self, bool more)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1051, self, varargin{:});
    end
    function varargout = str(self,varargin)
    %STR 
    %
    %  char = STR(self, bool more)
    %
    %
      [varargout{1:nargout}] = casadiMEX(1052, self, varargin{:});
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
        tmp = casadiMEX(1053, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.SwigClear();
      end
    end
    function delete(self)
        if self.swigPtr
          casadiMEX(1054, self);
          self.SwigClear();
        end
    end
  end
  methods(Static)
  end
end
