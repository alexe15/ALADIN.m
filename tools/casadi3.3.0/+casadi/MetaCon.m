classdef  MetaCon < casadi.IndexAbstraction
    %METACON 
    %
    %   = METACON()
    %
    %
  methods
    function v = original(self)
      v = casadiMEX(1158, self);
    end
    function v = canon(self)
      v = casadiMEX(1159, self);
    end
    function v = type(self)
      v = casadiMEX(1160, self);
    end
    function v = lb(self)
      v = casadiMEX(1161, self);
    end
    function v = ub(self)
      v = casadiMEX(1162, self);
    end
    function v = n(self)
      v = casadiMEX(1163, self);
    end
    function v = flipped(self)
      v = casadiMEX(1164, self);
    end
    function v = dual_canon(self)
      v = casadiMEX(1165, self);
    end
    function v = dual(self)
      v = casadiMEX(1166, self);
    end
    function v = extra(self)
      v = casadiMEX(1167, self);
    end
    function self = MetaCon(varargin)
    %METACON 
    %
    %  new_obj = METACON()
    %
    %
      self@casadi.IndexAbstraction(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(1168, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];
      end
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(1169, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
