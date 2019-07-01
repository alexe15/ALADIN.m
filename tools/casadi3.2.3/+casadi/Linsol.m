classdef  Linsol < casadi.SharedObject
    %LINSOL Linear solver Create a solver for linear systems of equations Solves the
    %
    %
    %linear system A*X = B or A^T*X = B for X with A square and non- singular.
    %
    %If A is structurally singular, an error will be thrown during init. If A is
    %numerically singular, the prepare step will fail.
    %
    %General information
    %===================
    %
    %
    %
    %List of plugins
    %===============
    %
    %
    %
    %- csparsecholesky
    %
    %- csparse
    %
    %- ma27
    %
    %- lapacklu
    %
    %- lapackqr
    %
    %- symbolicqr
    %
    %Note: some of the plugins in this list might not be available on your
    %system. Also, there might be extra plugins available to you that are not
    %listed here. You can obtain their documentation with
    %Linsol.doc("myextraplugin")
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %csparsecholesky
    %---------------
    %
    %
    %
    %Linsol with CSparseCholesky Interface
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %csparse
    %-------
    %
    %
    %
    %Linsol with CSparse Interface
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %ma27
    %----
    %
    %
    %
    %Interface to the sparse direct linear solver MA27 Works for symmetric
    %indefinite systems Partly adopted from qpOASES 3.2 Joel Andersson
    %
    %--------------------------------------------------------------------------------
    %
    %lapacklu
    %--------
    %
    %
    %
    %This class solves the linear system A.x=b by making an LU factorization of
    %A: A = L.U, with L lower and U upper triangular
    %
    %>List of available options
    %
    %+-----------------------------+---------+----------------------------------+
    %|             Id              |  Type   |           Description            |
    %+=============================+=========+==================================+
    %| allow_equilibration_failure | OT_BOOL | Non-fatal error when             |
    %|                             |         | equilibration fails              |
    %+-----------------------------+---------+----------------------------------+
    %| equilibration               | OT_BOOL | Equilibrate the matrix           |
    %+-----------------------------+---------+----------------------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %lapackqr
    %--------
    %
    %
    %
    %This class solves the linear system A.x=b by making an QR factorization of
    %A: A = Q.R, with Q orthogonal and R upper triangular
    %
    %>List of available options
    %
    %+----------+--------+------------------------------------------------------+
    %|    Id    |  Type  |                     Description                      |
    %+==========+========+======================================================+
    %| max_nrhs | OT_INT | Maximum number of right-hand-sides that get          |
    %|          |        | processed in a single pass [default:10].             |
    %+----------+--------+------------------------------------------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %symbolicqr
    %----------
    %
    %
    %
    %Linear solver for sparse least-squares problems Inspired
    %fromhttps://github.com/scipy/scipy/blob/v0.14.0/scipy/sparse/linalg/isolve/lsqr.py#L96
    %
    %Linsol based on QR factorization with sparsity pattern based reordering
    %without partial pivoting
    %
    %>List of available options
    %
    %+----------+-----------+---------------------------------------------------+
    %|    Id    |   Type    |                    Description                    |
    %+==========+===========+===================================================+
    %| codegen  | OT_BOOL   | C-code generation                                 |
    %+----------+-----------+---------------------------------------------------+
    %| compiler | OT_STRING | Compiler command to be used for compiling         |
    %|          |           | generated code                                    |
    %+----------+-----------+---------------------------------------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %Joel Andersson
    %
    %C++ includes: linsol.hpp 
    %
  methods
    function varargout = plugin_name(self,varargin)
    %PLUGIN_NAME Query plugin name.
    %
    %  char = PLUGIN_NAME(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(889, self, varargin{:});
    end
    function varargout = solve(self,varargin)
    %SOLVE Create a solve node.
    %
    %  DM = SOLVE(self, DM A, DM B, bool tr)
    %    Solve numerically.
    %  MX = SOLVE(self, MX A, MX B, bool tr)
    %
    %
    %
    %> SOLVE(self, MX A, MX B, bool tr)
    %------------------------------------------------------------------------
    %
    %
    %Create a solve node.
    %
    %
    %> SOLVE(self, DM A, DM B, bool tr)
    %------------------------------------------------------------------------
    %
    %
    %Solve numerically.
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(890, self, varargin{:});
    end
    function varargout = cholesky_sparsity(self,varargin)
    %CHOLESKY_SPARSITY Obtain a symbolic Cholesky factorization Only for Cholesky solvers.
    %
    %  Sparsity = CHOLESKY_SPARSITY(self, bool tr)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(891, self, varargin{:});
    end
    function varargout = cholesky(self,varargin)
    %CHOLESKY Obtain a numeric Cholesky factorization Only for Cholesky solvers.
    %
    %  DM = CHOLESKY(self, bool tr)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(892, self, varargin{:});
    end
    function varargout = neig(self,varargin)
    %NEIG Number of negative eigenvalues Not available for all solvers.
    %
    %  int = NEIG(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(893, self, varargin{:});
    end
    function varargout = rank(self,varargin)
    %RANK Matrix rank Not available for all solvers.
    %
    %  int = RANK(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(894, self, varargin{:});
    end
    function self = Linsol(varargin)
    %LINSOL 
    %
    %  new_obj = LINSOL()
    %    Default constructor.
    %  new_obj = LINSOL(char name, char solver, struct opts)
    %    Importer factory.
    %
    %> LINSOL(char name, char solver, struct opts)
    %------------------------------------------------------------------------
    %
    %
    %Importer factory.
    %
    %
    %> LINSOL()
    %------------------------------------------------------------------------
    %
    %
    %Default constructor.
    %
    %
    %
      self@casadi.SharedObject(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(895, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];
      end
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(896, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
    function varargout = test_cast(varargin)
    %TEST_CAST 
    %
    %  bool = TEST_CAST(casadi::SharedObjectInternal const * ptr)
    %
    %
     [varargout{1:nargout}] = casadiMEX(885, varargin{:});
    end
    function varargout = has_plugin(varargin)
    %HAS_PLUGIN 
    %
    %  bool = HAS_PLUGIN(char name)
    %
    %
     [varargout{1:nargout}] = casadiMEX(886, varargin{:});
    end
    function varargout = load_plugin(varargin)
    %LOAD_PLUGIN 
    %
    %  LOAD_PLUGIN(char name)
    %
    %
     [varargout{1:nargout}] = casadiMEX(887, varargin{:});
    end
    function varargout = doc(varargin)
    %DOC 
    %
    %  char = DOC(char name)
    %
    %
     [varargout{1:nargout}] = casadiMEX(888, varargin{:});
    end
  end
end
