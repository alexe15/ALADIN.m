classdef  GenMX < casadi.GenericMatrixCommon & casadi.SparsityInterfaceCommon
    %GENMX Matrix base class.
    %
    %
    %
    %This is a common base class for MX and Matrix<>, introducing a uniform
    %syntax and implementing common functionality using the curiously recurring
    %template pattern (CRTP) idiom.  The class is designed with the idea that
    %"everything is a matrix", that is, also scalars and vectors. This
    %philosophy makes it easy to use and to interface in particularly with Python
    %and Matlab/Octave.  The syntax tries to stay as close as possible to the
    %ublas syntax when it comes to vector/matrix operations.  Index starts with
    %0. Index vec happens as follows: (rr, cc) -> k = rr+cc*size1() Vectors are
    %column vectors.  The storage format is Compressed Column Storage (CCS),
    %similar to that used for sparse matrices in Matlab, but unlike this format,
    %we do allow for elements to be structurally non-zero but numerically zero.
    %The sparsity pattern, which is reference counted and cached, can be accessed
    %with Sparsity& sparsity() Joel Andersson
    %
    %C++ includes: generic_matrix.hpp 
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function varargout = nnz(self,varargin)
    %NNZ 
    %
    %  int = NNZ(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(322, self, varargin{:});
    end
    function varargout = nnz_lower(self,varargin)
    %NNZ_LOWER 
    %
    %  int = NNZ_LOWER(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(323, self, varargin{:});
    end
    function varargout = nnz_upper(self,varargin)
    %NNZ_UPPER 
    %
    %  int = NNZ_UPPER(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(324, self, varargin{:});
    end
    function varargout = nnz_diag(self,varargin)
    %NNZ_DIAG 
    %
    %  int = NNZ_DIAG(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(325, self, varargin{:});
    end
    function varargout = numel(self,varargin)
    %NUMEL 
    %
    %  int = NUMEL(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(326, self, varargin{:});
    end
    function varargout = size1(self,varargin)
    %SIZE1 
    %
    %  int = SIZE1(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(327, self, varargin{:});
    end
    function varargout = rows(self,varargin)
    %ROWS 
    %
    %  int = ROWS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(328, self, varargin{:});
    end
    function varargout = size2(self,varargin)
    %SIZE2 
    %
    %  int = SIZE2(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(329, self, varargin{:});
    end
    function varargout = columns(self,varargin)
    %COLUMNS 
    %
    %  int = COLUMNS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(330, self, varargin{:});
    end
    function varargout = dim(self,varargin)
    %DIM 
    %
    %  char = DIM(self, bool with_nz)
    %
    %
      [varargout{1:nargout}] = casadiMEX(331, self, varargin{:});
    end
    function varargout = size(self,varargin)
    %SIZE 
    %
    %  [int,int] = SIZE(self)
    %  int = SIZE(self, int axis)
    %
    %
      out = casadiMEX(332, self, varargin{:});
      if nargout<=1
        varargout{1}=out;
      else
        nargoutchk(length(out),length(out))
        for i=1:nargout
          varargout{i} = out(i);
        end
      end
    end
    function varargout = is_empty(self,varargin)
    %IS_EMPTY 
    %
    %  bool = IS_EMPTY(self, bool both)
    %
    %
      [varargout{1:nargout}] = casadiMEX(333, self, varargin{:});
    end
    function varargout = is_dense(self,varargin)
    %IS_DENSE 
    %
    %  bool = IS_DENSE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(334, self, varargin{:});
    end
    function varargout = is_scalar(self,varargin)
    %IS_SCALAR 
    %
    %  bool = IS_SCALAR(self, bool scalar_and_dense)
    %
    %
      [varargout{1:nargout}] = casadiMEX(335, self, varargin{:});
    end
    function varargout = is_square(self,varargin)
    %IS_SQUARE 
    %
    %  bool = IS_SQUARE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(336, self, varargin{:});
    end
    function varargout = is_vector(self,varargin)
    %IS_VECTOR 
    %
    %  bool = IS_VECTOR(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(337, self, varargin{:});
    end
    function varargout = is_row(self,varargin)
    %IS_ROW 
    %
    %  bool = IS_ROW(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(338, self, varargin{:});
    end
    function varargout = is_column(self,varargin)
    %IS_COLUMN 
    %
    %  bool = IS_COLUMN(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(339, self, varargin{:});
    end
    function varargout = is_triu(self,varargin)
    %IS_TRIU 
    %
    %  bool = IS_TRIU(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(340, self, varargin{:});
    end
    function varargout = is_tril(self,varargin)
    %IS_TRIL 
    %
    %  bool = IS_TRIL(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(341, self, varargin{:});
    end
    function varargout = row(self,varargin)
    %ROW 
    %
    %  [int] = ROW(self)
    %  int = ROW(self, int el)
    %
    %
      [varargout{1:nargout}] = casadiMEX(342, self, varargin{:});
    end
    function varargout = colind(self,varargin)
    %COLIND 
    %
    %  [int] = COLIND(self)
    %  int = COLIND(self, int col)
    %
    %
      [varargout{1:nargout}] = casadiMEX(343, self, varargin{:});
    end
    function varargout = sparsity(self,varargin)
    %SPARSITY 
    %
    %  Sparsity = SPARSITY(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(344, self, varargin{:});
    end
    function self = GenMX(varargin)
    %GENMX 
    %
    %  new_obj = GENMX()
    %
    %
      self@casadi.GenericMatrixCommon(SwigRef.Null);
      self@casadi.SparsityInterfaceCommon(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(348, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];
      end
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(349, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
    function varargout = sym(varargin)
    %SYM 
    %
    %  MX = SYM(char name, int nrow, int ncol)
    %  MX = SYM(char name, [int,int] rc)
    %  MX = SYM(char name, Sparsity sp)
    %  {MX} = SYM(char name, Sparsity sp, int p)
    %  {MX} = SYM(char name, int nrow, int ncol, int p)
    %  {{MX}} = SYM(char name, Sparsity sp, int p, int r)
    %  {{MX}} = SYM(char name, int nrow, int ncol, int p, int r)
    %
    %
     [varargout{1:nargout}] = casadiMEX(345, varargin{:});
    end
    function varargout = zeros(varargin)
    %ZEROS 
    %
    %  MX = ZEROS(int nrow, int ncol)
    %  MX = ZEROS([int,int] rc)
    %  MX = ZEROS(Sparsity sp)
    %
    %
     [varargout{1:nargout}] = casadiMEX(346, varargin{:});
    end
    function varargout = ones(varargin)
    %ONES 
    %
    %  MX = ONES(int nrow, int ncol)
    %  MX = ONES([int,int] rc)
    %  MX = ONES(Sparsity sp)
    %
    %
     [varargout{1:nargout}] = casadiMEX(347, varargin{:});
    end
  end
end
