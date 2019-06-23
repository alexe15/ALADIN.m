classdef  Callback < casadi.Function
    %CALLBACK Callback function functionality.
    %
    %
    %
    %This class provides a public API to the FunctionInternal class that can be
    %subclassed by the user, who is then able to implement the different virtual
    %method. Note that the Function class also provides a public API to
    %FunctionInternal, but only allows calling, not being called.
    %
    %The user is responsible for not deleting this class for the lifetime of the
    %internal function object.
    %
    %Joris Gillis, Joel Andersson
    %
    %C++ includes: callback.hpp 
    %
  methods
    function self = Callback(varargin)
      self@casadi.Function(SwigRef.Null);
    %CALLBACK Copy constructor (throws an error)
    %
    %  new_obj = CALLBACK(self)
    %    Default constructor.
    %
    %
    %
    %
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        if strcmp(class(self),'director_basic.Callback')
          tmp = casadiMEX(940, 0, varargin{:});
        else
          tmp = casadiMEX(940, self, varargin{:});
        end
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];
      end
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(941, self);
        self.swigPtr=[];
      end
    end
    function varargout = construct(self,varargin)
    %CONSTRUCT Construct internal object This is the step that actually construct the
    %
    %  CONSTRUCT(self, char name, struct opts)
    %
    %internal object, as the class constructor only creates a null pointer. It
    %should be called from the user constructor.
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(942, self, varargin{:});
    end
    function varargout = init(self,varargin)
    %INIT Initialize the object This function is called after the object construction
    %
    %  INIT(self)
    %
    %(for the whole class hierarchy) is complete, but before the finalization
    %step. It is called recursively for the whole class hierarchy, starting with
    %the lowest level.
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(943, self, varargin{:});
    end
    function varargout = finalize(self,varargin)
    %FINALIZE Finalize the object This function is called after the construction and init
    %
    %  FINALIZE(self)
    %
    %steps are completed, but before user functions are called. It is called
    %recursively for the whole class hierarchy, starting with the highest level.
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(944, self, varargin{:});
    end
    function varargout = eval(self,varargin)
    %EVAL Evaluate numerically, temporary matrices and work vectors.
    %
    %  {DM} = EVAL(self, {DM} arg)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(945, self, varargin{:});
    end
    function varargout = get_n_in(self,varargin)
    %GET_N_IN Get the number of inputs This function is called during construction.
    %
    %  int = GET_N_IN(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(946, self, varargin{:});
    end
    function varargout = get_n_out(self,varargin)
    %GET_N_OUT Get the number of outputs This function is called during construction.
    %
    %  int = GET_N_OUT(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(947, self, varargin{:});
    end
    function varargout = get_sparsity_in(self,varargin)
    %GET_SPARSITY_IN Get the sparsity of an input This function is called during construction.
    %
    %  Sparsity = GET_SPARSITY_IN(self, int i)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(948, self, varargin{:});
    end
    function varargout = get_sparsity_out(self,varargin)
    %GET_SPARSITY_OUT Get the sparsity of an output This function is called during construction.
    %
    %  Sparsity = GET_SPARSITY_OUT(self, int i)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(949, self, varargin{:});
    end
    function varargout = get_name_in(self,varargin)
    %GET_NAME_IN Get the sparsity of an input This function is called during construction.
    %
    %  char = GET_NAME_IN(self, int i)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(950, self, varargin{:});
    end
    function varargout = get_name_out(self,varargin)
    %GET_NAME_OUT Get the sparsity of an output This function is called during construction.
    %
    %  char = GET_NAME_OUT(self, int i)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(951, self, varargin{:});
    end
    function varargout = uses_output(self,varargin)
    %USES_OUTPUT Do the derivative functions need nondifferentiated outputs?
    %
    %  bool = USES_OUTPUT(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(952, self, varargin{:});
    end
    function varargout = has_jacobian(self,varargin)
    %HAS_JACOBIAN Return Jacobian of all input elements with respect to all output elements.
    %
    %  bool = HAS_JACOBIAN(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(953, self, varargin{:});
    end
    function varargout = get_jacobian(self,varargin)
    %GET_JACOBIAN Return Jacobian of all input elements with respect to all output elements.
    %
    %  Function = GET_JACOBIAN(self, char name, [char] inames, [char] onames, struct opts)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(954, self, varargin{:});
    end
    function varargout = has_forward(self,varargin)
    %HAS_FORWARD Return function that calculates forward derivatives forward(nfwd) returns a
    %
    %  bool = HAS_FORWARD(self, int nfwd)
    %
    %cached instance if available, and calls  Function get_forward(int nfwd) if
    %no cached version is available.
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(955, self, varargin{:});
    end
    function varargout = get_forward(self,varargin)
    %GET_FORWARD Return function that calculates forward derivatives forward(nfwd) returns a
    %
    %  Function = GET_FORWARD(self, int nfwd, char name, [char] inames, [char] onames, struct opts)
    %
    %cached instance if available, and calls  Function get_forward(int nfwd) if
    %no cached version is available.
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(956, self, varargin{:});
    end
    function varargout = has_reverse(self,varargin)
    %HAS_REVERSE Return function that calculates adjoint derivatives reverse(nadj) returns a
    %
    %  bool = HAS_REVERSE(self, int nadj)
    %
    %cached instance if available, and calls  Function get_reverse(int nadj) if
    %no cached version is available.
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(957, self, varargin{:});
    end
    function varargout = get_reverse(self,varargin)
    %GET_REVERSE Return function that calculates adjoint derivatives reverse(nadj) returns a
    %
    %  Function = GET_REVERSE(self, int nadj, char name, [char] inames, [char] onames, struct opts)
    %
    %cached instance if available, and calls  Function get_reverse(int nadj) if
    %no cached version is available.
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(958, self, varargin{:});
    end
    function varargout = alloc_w(self,varargin)
    %ALLOC_W Allocate work vectors.
    %
    %  ALLOC_W(self, size_t sz_w, bool persist)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(959, self, varargin{:});
    end
    function varargout = alloc_iw(self,varargin)
    %ALLOC_IW Allocate work vectors.
    %
    %  ALLOC_IW(self, size_t sz_iw, bool persist)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(960, self, varargin{:});
    end
    function varargout = alloc_arg(self,varargin)
    %ALLOC_ARG Allocate work vectors.
    %
    %  ALLOC_ARG(self, size_t sz_arg, bool persist)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(961, self, varargin{:});
    end
    function varargout = alloc_res(self,varargin)
    %ALLOC_RES Allocate work vectors.
    %
    %  ALLOC_RES(self, size_t sz_res, bool persist)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(962, self, varargin{:});
    end
  end
  methods(Static)
    function varargout = type_name(varargin)
    %TYPE_NAME 
    %
    %  char = TYPE_NAME()
    %
    %
     [varargout{1:nargout}] = casadiMEX(939, varargin{:});
    end
  end
end
