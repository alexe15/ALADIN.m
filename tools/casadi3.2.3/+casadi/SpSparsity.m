classdef  SpSparsity < casadi.SparsityInterfaceCommon
    %SPSPARSITY Sparsity interface class.
    %
    %
    %
    %This is a common base class for GenericMatrix (i.e. MX and Matrix<>) and
    %Sparsity, introducing a uniform syntax and implementing common functionality
    %using the curiously recurring template pattern (CRTP) idiom. Joel Andersson
    %
    %C++ includes: sparsity_interface.hpp 
    %
  methods
    function self = SpSparsity(varargin)
    %SPSPARSITY 
    %
    %  new_obj = SPSPARSITY()
    %
    %
      self@casadi.SparsityInterfaceCommon(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(92, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];
      end
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(93, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
