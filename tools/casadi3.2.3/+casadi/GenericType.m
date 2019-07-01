classdef  GenericType < SwigRef
    %GENERICTYPE Generic data type, can hold different types such as bool, int, string etc.
    %
    %
    %
    %Joel Andersson
    %
    %C++ includes: generic_type.hpp 
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function self = GenericType(varargin)
    %GENERICTYPE 
    %
    %  new_obj = GENERICTYPE()
    %
    %
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(66, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];
      end
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(67, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
