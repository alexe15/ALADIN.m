classdef  Slice < casadi.PrintableCommon
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
      v = casadiMEX(168, self);
    end
    function v = stop(self)
      v = casadiMEX(169, self);
    end
    function v = step(self)
      v = casadiMEX(170, self);
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
      [varargout{1:nargout}] = casadiMEX(171, self, varargin{:});
    end
    function varargout = is_scalar(self,varargin)
    %IS_SCALAR Is the slice a scalar.
    %
    %  bool = IS_SCALAR(self, int len)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(172, self, varargin{:});
    end
    function varargout = scalar(self,varargin)
    %SCALAR Get scalar (if is_scalar)
    %
    %  int = SCALAR(self, int len)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(173, self, varargin{:});
    end
    function varargout = eq(self,varargin)
    %EQ 
    %
    %  bool = EQ(self, Slice other)
    %
    %
      [varargout{1:nargout}] = casadiMEX(174, self, varargin{:});
    end
    function varargout = ne(self,varargin)
    %NE 
    %
    %  bool = NE(self, Slice other)
    %
    %
      [varargout{1:nargout}] = casadiMEX(175, self, varargin{:});
    end
    function varargout = type_name(self,varargin)
    %TYPE_NAME Get name of the class.
    %
    %  char = TYPE_NAME(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(176, self, varargin{:});
    end
    function varargout = disp(self,varargin)
    %DISP Print a description of the object.
    %
    %  std::ostream & = DISP(self, bool more)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(177, self, varargin{:});
    end
    function varargout = str(self,varargin)
    %STR Get string representation.
    %
    %  char = STR(self, bool more)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(178, self, varargin{:});
    end
    function varargout = info(self,varargin)
    %INFO Obtain information
    %
    %  struct = INFO(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(179, self, varargin{:});
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
      self@casadi.PrintableCommon(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(180, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];
      end
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(181, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
