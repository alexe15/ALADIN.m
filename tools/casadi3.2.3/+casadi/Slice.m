classdef  Slice < casadi.PrintSlice
    %SLICE Class representing a Slice.
    %
    %
    %
    %Note that Python or Octave do not need to use this class. They can just use
    %slicing utility from the host language ( M[0:6] in Python, M(1:7) )
    %
    %C++ includes: slice.hpp 
    %
  methods
    function v = start(self)
      v = casadiMEX(186, self);
    end
    function v = stop(self)
      v = casadiMEX(187, self);
    end
    function v = step(self)
      v = casadiMEX(188, self);
    end
    function varargout = all(self,varargin)
    %ALL Get a vector of indices (nested slice)
    %
    %  [int] = ALL(self, int len, bool ind1)
    %    Get a vector of indices.
    %  [int] = ALL(self, Slice outer, int len)
    %
    %
    %
    %> ALL(self, int len, bool ind1)
    %------------------------------------------------------------------------
    %
    %
    %Get a vector of indices.
    %
    %
    %> ALL(self, Slice outer, int len)
    %------------------------------------------------------------------------
    %
    %
    %Get a vector of indices (nested slice)
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(189, self, varargin{:});
    end
    function varargout = is_scalar(self,varargin)
    %IS_SCALAR Is the slice a scalar.
    %
    %  bool = IS_SCALAR(self, int len)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(190, self, varargin{:});
    end
    function varargout = scalar(self,varargin)
    %SCALAR Get scalar (if is_scalar)
    %
    %  int = SCALAR(self, int len)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(191, self, varargin{:});
    end
    function varargout = eq(self,varargin)
    %EQ 
    %
    %  bool = EQ(self, Slice other)
    %
    %
      [varargout{1:nargout}] = casadiMEX(192, self, varargin{:});
    end
    function varargout = ne(self,varargin)
    %NE 
    %
    %  bool = NE(self, Slice other)
    %
    %
      [varargout{1:nargout}] = casadiMEX(193, self, varargin{:});
    end
    function varargout = disp(self,varargin)
    %DISP Print a representation of the object.
    %
    %  DISP(self, bool trailing_newline)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(194, self, varargin{:});
    end
    function varargout = print(self,varargin)
    %PRINT Print a description of the object.
    %
    %  PRINT(self, bool trailing_newline)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(195, self, varargin{:});
    end
    function self = Slice(varargin)
    %SLICE 
    %
    %  new_obj = SLICE()
    %    Default constructor - all elements.
    %  new_obj = SLICE(int i, bool ind1)
    %    A single element (explicit to avoid ambiguity with IM overload.
    %  new_obj = SLICE(int start, int stop, int step)
    %    A slice.
    %
    %> SLICE()
    %------------------------------------------------------------------------
    %
    %
    %Default constructor - all elements.
    %
    %
    %> SLICE(int start, int stop, int step)
    %------------------------------------------------------------------------
    %
    %
    %A slice.
    %
    %
    %> SLICE(int i, bool ind1)
    %------------------------------------------------------------------------
    %
    %
    %A single element (explicit to avoid ambiguity with IM overload.
    %
    %
    %
      self@casadi.PrintSlice(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(196, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];
      end
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(197, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
