classdef  GlobalOptions < SwigRef
    %GLOBALOPTIONS Collects global CasADi options.
    %
    %
    %
    %Note to developers: use sparingly. Global options are - in general - a
    %rather bad idea
    %
    %this class must never be instantiated. Access its static members directly
    %Joris Gillis
    %
    %C++ includes: global_options.hpp 
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function self = GlobalOptions(varargin)
    %GLOBALOPTIONS 
    %
    %  new_obj = GLOBALOPTIONS()
    %
    %
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(971, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];
      end
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(972, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
    function varargout = setSimplificationOnTheFly(varargin)
    %SETSIMPLIFICATIONONTHEFLY 
    %
    %  SETSIMPLIFICATIONONTHEFLY(bool flag)
    %
    %
     [varargout{1:nargout}] = casadiMEX(963, varargin{:});
    end
    function varargout = getSimplificationOnTheFly(varargin)
    %GETSIMPLIFICATIONONTHEFLY 
    %
    %  bool = GETSIMPLIFICATIONONTHEFLY()
    %
    %
     [varargout{1:nargout}] = casadiMEX(964, varargin{:});
    end
    function varargout = setHierarchicalSparsity(varargin)
    %SETHIERARCHICALSPARSITY 
    %
    %  SETHIERARCHICALSPARSITY(bool flag)
    %
    %
     [varargout{1:nargout}] = casadiMEX(965, varargin{:});
    end
    function varargout = getHierarchicalSparsity(varargin)
    %GETHIERARCHICALSPARSITY 
    %
    %  bool = GETHIERARCHICALSPARSITY()
    %
    %
     [varargout{1:nargout}] = casadiMEX(966, varargin{:});
    end
    function varargout = setCasadiPath(varargin)
    %SETCASADIPATH 
    %
    %  SETCASADIPATH(char path)
    %
    %
     [varargout{1:nargout}] = casadiMEX(967, varargin{:});
    end
    function varargout = getCasadiPath(varargin)
    %GETCASADIPATH 
    %
    %  char = GETCASADIPATH()
    %
    %
     [varargout{1:nargout}] = casadiMEX(968, varargin{:});
    end
    function varargout = setMaxNumDir(varargin)
    %SETMAXNUMDIR 
    %
    %  SETMAXNUMDIR(int ndir)
    %
    %
     [varargout{1:nargout}] = casadiMEX(969, varargin{:});
    end
    function varargout = getMaxNumDir(varargin)
    %GETMAXNUMDIR 
    %
    %  int = GETMAXNUMDIR()
    %
    %
     [varargout{1:nargout}] = casadiMEX(970, varargin{:});
    end
  end
end
