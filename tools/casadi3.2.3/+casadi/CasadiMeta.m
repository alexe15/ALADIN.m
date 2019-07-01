classdef  CasadiMeta < SwigRef
    %CASADIMETA Collects global CasADi meta information.
    %
    %
    %
    %Joris Gillis
    %
    %C++ includes: casadi_meta.hpp 
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function self = CasadiMeta(varargin)
    %CASADIMETA 
    %
    %  new_obj = CASADIMETA()
    %
    %
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(996, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];
      end
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(997, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
    function varargout = getVersion(varargin)
    %GETVERSION 
    %
    %  char = GETVERSION()
    %
    %
     [varargout{1:nargout}] = casadiMEX(974, varargin{:});
    end
    function varargout = getGitRevision(varargin)
    %GETGITREVISION 
    %
    %  char = GETGITREVISION()
    %
    %
     [varargout{1:nargout}] = casadiMEX(975, varargin{:});
    end
    function varargout = getGitDescribe(varargin)
    %GETGITDESCRIBE 
    %
    %  char = GETGITDESCRIBE()
    %
    %
     [varargout{1:nargout}] = casadiMEX(976, varargin{:});
    end
    function varargout = getFeatureList(varargin)
    %GETFEATURELIST 
    %
    %  char = GETFEATURELIST()
    %
    %
     [varargout{1:nargout}] = casadiMEX(977, varargin{:});
    end
    function varargout = getBuildType(varargin)
    %GETBUILDTYPE 
    %
    %  char = GETBUILDTYPE()
    %
    %
     [varargout{1:nargout}] = casadiMEX(978, varargin{:});
    end
    function varargout = getCompilerId(varargin)
    %GETCOMPILERID 
    %
    %  char = GETCOMPILERID()
    %
    %
     [varargout{1:nargout}] = casadiMEX(979, varargin{:});
    end
    function varargout = getCompiler(varargin)
    %GETCOMPILER 
    %
    %  char = GETCOMPILER()
    %
    %
     [varargout{1:nargout}] = casadiMEX(980, varargin{:});
    end
    function varargout = getCompilerFlags(varargin)
    %GETCOMPILERFLAGS 
    %
    %  char = GETCOMPILERFLAGS()
    %
    %
     [varargout{1:nargout}] = casadiMEX(981, varargin{:});
    end
    function varargout = getModules(varargin)
    %GETMODULES 
    %
    %  char = GETMODULES()
    %
    %
     [varargout{1:nargout}] = casadiMEX(982, varargin{:});
    end
    function varargout = getPlugins(varargin)
    %GETPLUGINS 
    %
    %  char = GETPLUGINS()
    %
    %
     [varargout{1:nargout}] = casadiMEX(983, varargin{:});
    end
    function varargout = getInstallPrefix(varargin)
    %GETINSTALLPREFIX 
    %
    %  char = GETINSTALLPREFIX()
    %
    %
     [varargout{1:nargout}] = casadiMEX(984, varargin{:});
    end
    function varargout = version(varargin)
    %VERSION 
    %
    %  char const * = VERSION()
    %
    %
     [varargout{1:nargout}] = casadiMEX(985, varargin{:});
    end
    function varargout = git_revision(varargin)
    %GIT_REVISION 
    %
    %  char const * = GIT_REVISION()
    %
    %
     [varargout{1:nargout}] = casadiMEX(986, varargin{:});
    end
    function varargout = git_describe(varargin)
    %GIT_DESCRIBE 
    %
    %  char const * = GIT_DESCRIBE()
    %
    %
     [varargout{1:nargout}] = casadiMEX(987, varargin{:});
    end
    function varargout = feature_list(varargin)
    %FEATURE_LIST 
    %
    %  char const * = FEATURE_LIST()
    %
    %
     [varargout{1:nargout}] = casadiMEX(988, varargin{:});
    end
    function varargout = build_type(varargin)
    %BUILD_TYPE 
    %
    %  char const * = BUILD_TYPE()
    %
    %
     [varargout{1:nargout}] = casadiMEX(989, varargin{:});
    end
    function varargout = compiler_id(varargin)
    %COMPILER_ID 
    %
    %  char const * = COMPILER_ID()
    %
    %
     [varargout{1:nargout}] = casadiMEX(990, varargin{:});
    end
    function varargout = compiler(varargin)
    %COMPILER 
    %
    %  char const * = COMPILER()
    %
    %
     [varargout{1:nargout}] = casadiMEX(991, varargin{:});
    end
    function varargout = compiler_flags(varargin)
    %COMPILER_FLAGS 
    %
    %  char const * = COMPILER_FLAGS()
    %
    %
     [varargout{1:nargout}] = casadiMEX(992, varargin{:});
    end
    function varargout = modules(varargin)
    %MODULES 
    %
    %  char const * = MODULES()
    %
    %
     [varargout{1:nargout}] = casadiMEX(993, varargin{:});
    end
    function varargout = plugins(varargin)
    %PLUGINS 
    %
    %  char const * = PLUGINS()
    %
    %
     [varargout{1:nargout}] = casadiMEX(994, varargin{:});
    end
    function varargout = install_prefix(varargin)
    %INSTALL_PREFIX 
    %
    %  char const * = INSTALL_PREFIX()
    %
    %
     [varargout{1:nargout}] = casadiMEX(995, varargin{:});
    end
  end
end
