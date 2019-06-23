classdef  MetaVar < casadi.IndexAbstraction
    %METAVAR 
    %
    %   = METAVAR()
    %
    %
  methods
    function v = attribute(self)
      v = casadiMEX(1170, self);
    end
    function v = n(self)
      v = casadiMEX(1171, self);
    end
    function v = m(self)
      v = casadiMEX(1172, self);
    end
    function v = type(self)
      v = casadiMEX(1173, self);
    end
    function v = count(self)
      v = casadiMEX(1174, self);
    end
    function v = i(self)
      v = casadiMEX(1175, self);
    end
    function v = extra(self)
      v = casadiMEX(1176, self);
    end
    function self = MetaVar(varargin)
    %METAVAR 
    %
    %  new_obj = METAVAR()
    %
    %
      self@casadi.IndexAbstraction(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(1177, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];
      end
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(1178, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
