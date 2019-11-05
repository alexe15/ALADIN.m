classdef  GenericType < casadi.PrintableCommon
    %GENERICTYPE Generic data type, can hold different types such as bool, casadi_int, string
    %
    %
    %etc.
    %
    %Joel Andersson
    %
    %C++ includes: generic_type.hpp 
    %
  methods
    function self = GenericType(varargin)
    %GENERICTYPE 
    %
    %  new_obj = GENERICTYPE()
    %
    %
      self@casadi.PrintableCommon(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(38, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.SwigClear();
      end
    end
    function delete(self)
        if self.swigPtr
          casadiMEX(39, self);
          self.SwigClear();
        end
    end
  end
  methods(Static)
  end
end
