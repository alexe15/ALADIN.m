classdef  ExpDM < casadi.GenericExpressionCommon
    %EXPDM Expression interface.
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
    function self = ExpDM(varargin)
    %EXPDM 
    %
    %  new_obj = EXPDM()
    %
    %
      self@casadi.GenericExpressionCommon(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(411, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];
      end
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(412, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
