classdef  ExpIM < casadi.GenericExpressionCommon
    %EXPIM Expression interface.
    %
    %
    %
    %This is a common base class for SX, MX and Matrix<>, introducing a uniform
    %syntax and implementing common functionality using the curiously recurring
    %template pattern (CRTP) idiom. Joel Andersson
    %
    %C++ includes: generic_expression.hpp 
    %
  methods
    function self = ExpIM(varargin)
    %EXPIM 
    %
    %  new_obj = EXPIM()
    %
    %
      self@casadi.GenericExpressionCommon(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(409, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];
      end
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(410, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
