classdef  SX < casadi.MatrixCommon & casadi.GenericExpressionCommon & casadi.GenSX & casadi.PrintableCommon
    %SX Sparse matrix class. SX and DM are specializations.
    %
    %
    %
    %General sparse matrix class that is designed with the idea that "everything
    %is a matrix", that is, also scalars and vectors. This philosophy makes it
    %easy to use and to interface in particularly with Python and Matlab/Octave.
    %Index starts with 0. Index vec happens as follows: (rr, cc) -> k =
    %rr+cc*size1() Vectors are column vectors.  The storage format is Compressed
    %Column Storage (CCS), similar to that used for sparse matrices in Matlab,
    %but unlike this format, we do allow for elements to be structurally non-zero
    %but numerically zero.  Matrix<Scalar> is polymorphic with a
    %std::vector<Scalar> that contain all non-identical-zero elements. The
    %sparsity can be accessed with Sparsity& sparsity() Joel Andersson
    %
    %C++ includes: casadi_common.hpp 
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function varargout = sanity_check(self,varargin)
    %SANITY_CHECK 
    %
    %  SANITY_CHECK(self, bool complete)
    %
    %
      [varargout{1:nargout}] = casadiMEX(592, self, varargin{:});
    end
    function varargout = has_nz(self,varargin)
    %HAS_NZ 
    %
    %  bool = HAS_NZ(self, int rr, int cc)
    %
    %
      [varargout{1:nargout}] = casadiMEX(593, self, varargin{:});
    end
    function varargout = nonzero(self,varargin)
    %NONZERO [INTERNAL] 
    %
    %  bool = NONZERO(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(594, self, varargin{:});
    end
    function varargout = get(self,varargin)
    %GET 
    %
    %  SX = GET(self, bool ind1, Sparsity sp)
    %  SX = GET(self, bool ind1, Slice rr)
    %  SX = GET(self, bool ind1, IM rr)
    %  SX = GET(self, bool ind1, Slice rr, Slice cc)
    %  SX = GET(self, bool ind1, Slice rr, IM cc)
    %  SX = GET(self, bool ind1, IM rr, Slice cc)
    %  SX = GET(self, bool ind1, IM rr, IM cc)
    %
    %
      [varargout{1:nargout}] = casadiMEX(595, self, varargin{:});
    end
    function varargout = set(self,varargin)
    %SET 
    %
    %  SET(self, SX m, bool ind1, Sparsity sp)
    %  SET(self, SX m, bool ind1, Slice rr)
    %  SET(self, SX m, bool ind1, IM rr)
    %  SET(self, SX m, bool ind1, Slice rr, Slice cc)
    %  SET(self, SX m, bool ind1, Slice rr, IM cc)
    %  SET(self, SX m, bool ind1, IM rr, Slice cc)
    %  SET(self, SX m, bool ind1, IM rr, IM cc)
    %
    %
      [varargout{1:nargout}] = casadiMEX(596, self, varargin{:});
    end
    function varargout = get_nz(self,varargin)
    %GET_NZ 
    %
    %  SX = GET_NZ(self, bool ind1, Slice k)
    %  SX = GET_NZ(self, bool ind1, IM k)
    %
    %
      [varargout{1:nargout}] = casadiMEX(597, self, varargin{:});
    end
    function varargout = set_nz(self,varargin)
    %SET_NZ 
    %
    %  SET_NZ(self, SX m, bool ind1, Slice k)
    %  SET_NZ(self, SX m, bool ind1, IM k)
    %
    %
      [varargout{1:nargout}] = casadiMEX(598, self, varargin{:});
    end
    function varargout = uplus(self,varargin)
    %UPLUS 
    %
    %  SX = UPLUS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(599, self, varargin{:});
    end
    function varargout = uminus(self,varargin)
    %UMINUS 
    %
    %  SX = UMINUS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(600, self, varargin{:});
    end
    function varargout = printme(self,varargin)
    %PRINTME 
    %
    %  SX = PRINTME(self, SX y)
    %
    %
      [varargout{1:nargout}] = casadiMEX(606, self, varargin{:});
    end
    function varargout = T(self,varargin)
    %T 
    %
    %  SX = T(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(607, self, varargin{:});
    end
    function varargout = print_split(self,varargin)
    %PRINT_SPLIT 
    %
    %  [[char] OUTPUT, [char] OUTPUT] = PRINT_SPLIT(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(613, self, varargin{:});
    end
    function varargout = disp(self,varargin)
    %DISP 
    %
    %  std::ostream & = DISP(self, bool more)
    %
    %
      [varargout{1:nargout}] = casadiMEX(614, self, varargin{:});
    end
    function varargout = str(self,varargin)
    %STR 
    %
    %  char = STR(self, bool more)
    %
    %
      [varargout{1:nargout}] = casadiMEX(615, self, varargin{:});
    end
    function varargout = print_scalar(self,varargin)
    %PRINT_SCALAR 
    %
    %  std::ostream & = PRINT_SCALAR(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(616, self, varargin{:});
    end
    function varargout = print_vector(self,varargin)
    %PRINT_VECTOR 
    %
    %  std::ostream & = PRINT_VECTOR(self, bool truncate)
    %
    %
      [varargout{1:nargout}] = casadiMEX(617, self, varargin{:});
    end
    function varargout = print_dense(self,varargin)
    %PRINT_DENSE 
    %
    %  std::ostream & = PRINT_DENSE(self, bool truncate)
    %
    %
      [varargout{1:nargout}] = casadiMEX(618, self, varargin{:});
    end
    function varargout = print_sparse(self,varargin)
    %PRINT_SPARSE 
    %
    %  std::ostream & = PRINT_SPARSE(self, bool truncate)
    %
    %
      [varargout{1:nargout}] = casadiMEX(619, self, varargin{:});
    end
    function varargout = clear(self,varargin)
    %CLEAR 
    %
    %  CLEAR(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(620, self, varargin{:});
    end
    function varargout = resize(self,varargin)
    %RESIZE 
    %
    %  RESIZE(self, int nrow, int ncol)
    %
    %
      [varargout{1:nargout}] = casadiMEX(621, self, varargin{:});
    end
    function varargout = reserve(self,varargin)
    %RESERVE 
    %
    %  RESERVE(self, int nnz)
    %  RESERVE(self, int nnz, int ncol)
    %
    %
      [varargout{1:nargout}] = casadiMEX(622, self, varargin{:});
    end
    function varargout = erase(self,varargin)
    %ERASE 
    %
    %  ERASE(self, [int] rr, bool ind1)
    %  ERASE(self, [int] rr, [int] cc, bool ind1)
    %
    %
      [varargout{1:nargout}] = casadiMEX(623, self, varargin{:});
    end
    function varargout = remove(self,varargin)
    %REMOVE 
    %
    %  REMOVE(self, [int] rr, [int] cc)
    %
    %
      [varargout{1:nargout}] = casadiMEX(624, self, varargin{:});
    end
    function varargout = enlarge(self,varargin)
    %ENLARGE 
    %
    %  ENLARGE(self, int nrow, int ncol, [int] rr, [int] cc, bool ind1)
    %
    %
      [varargout{1:nargout}] = casadiMEX(625, self, varargin{:});
    end
    function varargout = sparsity(self,varargin)
    %SPARSITY 
    %
    %  Sparsity = SPARSITY(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(626, self, varargin{:});
    end
    function varargout = element_hash(self,varargin)
    %ELEMENT_HASH 
    %
    %  size_t = ELEMENT_HASH(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(631, self, varargin{:});
    end
    function varargout = is_regular(self,varargin)
    %IS_REGULAR 
    %
    %  bool = IS_REGULAR(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(632, self, varargin{:});
    end
    function varargout = is_smooth(self,varargin)
    %IS_SMOOTH 
    %
    %  bool = IS_SMOOTH(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(633, self, varargin{:});
    end
    function varargout = is_leaf(self,varargin)
    %IS_LEAF 
    %
    %  bool = IS_LEAF(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(634, self, varargin{:});
    end
    function varargout = is_commutative(self,varargin)
    %IS_COMMUTATIVE 
    %
    %  bool = IS_COMMUTATIVE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(635, self, varargin{:});
    end
    function varargout = is_symbolic(self,varargin)
    %IS_SYMBOLIC 
    %
    %  bool = IS_SYMBOLIC(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(636, self, varargin{:});
    end
    function varargout = is_valid_input(self,varargin)
    %IS_VALID_INPUT 
    %
    %  bool = IS_VALID_INPUT(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(637, self, varargin{:});
    end
    function varargout = has_duplicates(self,varargin)
    %HAS_DUPLICATES 
    %
    %  bool = HAS_DUPLICATES(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(638, self, varargin{:});
    end
    function varargout = reset_input(self,varargin)
    %RESET_INPUT 
    %
    %  RESET_INPUT(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(639, self, varargin{:});
    end
    function varargout = is_constant(self,varargin)
    %IS_CONSTANT 
    %
    %  bool = IS_CONSTANT(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(640, self, varargin{:});
    end
    function varargout = is_integer(self,varargin)
    %IS_INTEGER 
    %
    %  bool = IS_INTEGER(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(641, self, varargin{:});
    end
    function varargout = is_zero(self,varargin)
    %IS_ZERO 
    %
    %  bool = IS_ZERO(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(642, self, varargin{:});
    end
    function varargout = is_one(self,varargin)
    %IS_ONE 
    %
    %  bool = IS_ONE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(643, self, varargin{:});
    end
    function varargout = is_minus_one(self,varargin)
    %IS_MINUS_ONE 
    %
    %  bool = IS_MINUS_ONE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(644, self, varargin{:});
    end
    function varargout = is_eye(self,varargin)
    %IS_EYE 
    %
    %  bool = IS_EYE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(645, self, varargin{:});
    end
    function varargout = has_zeros(self,varargin)
    %HAS_ZEROS 
    %
    %  bool = HAS_ZEROS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(646, self, varargin{:});
    end
    function varargout = nonzeros(self,varargin)
    %NONZEROS 
    %
    %  {SXElem} = NONZEROS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(647, self, varargin{:});
    end
    function varargout = elements(self,varargin)
    %ELEMENTS 
    %
    %  {SXElem} = ELEMENTS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(648, self, varargin{:});
    end
    function varargout = to_double(self,varargin)
    %TO_DOUBLE 
    %
    %  double = TO_DOUBLE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(649, self, varargin{:});
    end
    function varargout = to_int(self,varargin)
    %TO_INT 
    %
    %  int = TO_INT(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(650, self, varargin{:});
    end
    function varargout = name(self,varargin)
    %NAME 
    %
    %  char = NAME(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(651, self, varargin{:});
    end
    function varargout = dep(self,varargin)
    %DEP 
    %
    %  SX = DEP(self, int ch)
    %
    %
      [varargout{1:nargout}] = casadiMEX(652, self, varargin{:});
    end
    function varargout = n_dep(self,varargin)
    %N_DEP 
    %
    %  int = N_DEP(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(653, self, varargin{:});
    end
    function varargout = export_code(self,varargin)
    %EXPORT_CODE 
    %
    %  std::ostream & = EXPORT_CODE(self, char lang, struct options)
    %
    %
      [varargout{1:nargout}] = casadiMEX(659, self, varargin{:});
    end
    function varargout = info(self,varargin)
    %INFO 
    %
    %  struct = INFO(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(660, self, varargin{:});
    end
    function varargout = paren(self,varargin)
    %PAREN 
    %
    %  SX = PAREN(self, Sparsity sp)
    %  SX = PAREN(self, IM rr)
    %  SX = PAREN(self, char rr)
    %  SX = PAREN(self, IM rr, IM cc)
    %  SX = PAREN(self, IM rr, char cc)
    %  SX = PAREN(self, char rr, IM cc)
    %  SX = PAREN(self, char rr, char cc)
    %
    %
      [varargout{1:nargout}] = casadiMEX(662, self, varargin{:});
    end
    function varargout = paren_asgn(self,varargin)
    %PAREN_ASGN 
    %
    %  PAREN_ASGN(self, SX m, Sparsity sp)
    %  PAREN_ASGN(self, SX m, IM rr)
    %  PAREN_ASGN(self, SX m, char rr)
    %  PAREN_ASGN(self, SX m, IM rr, IM cc)
    %  PAREN_ASGN(self, SX m, IM rr, char cc)
    %  PAREN_ASGN(self, SX m, char rr, IM cc)
    %  PAREN_ASGN(self, SX m, char rr, char cc)
    %
    %
      [varargout{1:nargout}] = casadiMEX(663, self, varargin{:});
    end
    function varargout = brace(self,varargin)
    %BRACE 
    %
    %  SX = BRACE(self, IM rr)
    %  SX = BRACE(self, char rr)
    %
    %
      [varargout{1:nargout}] = casadiMEX(664, self, varargin{:});
    end
    function varargout = setbrace(self,varargin)
    %SETBRACE 
    %
    %  SETBRACE(self, SX m, IM rr)
    %  SETBRACE(self, SX m, char rr)
    %
    %
      [varargout{1:nargout}] = casadiMEX(665, self, varargin{:});
    end
    function varargout = end(self,varargin)
    %END 
    %
    %  int = END(self, int i, int n)
    %
    %
      [varargout{1:nargout}] = casadiMEX(666, self, varargin{:});
    end
    function varargout = numel(self,varargin)
    %NUMEL 
    %
    %  int = NUMEL(self)
    %  int = NUMEL(self, int k)
    %  int = NUMEL(self, [int] k)
    %  int = NUMEL(self, char rr)
    %
    %
      [varargout{1:nargout}] = casadiMEX(667, self, varargin{:});
    end
    function varargout = ctranspose(self,varargin)
    %CTRANSPOSE 
    %
    %  SX = CTRANSPOSE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(668, self, varargin{:});
    end
    function self = SX(varargin)
    %SX 
    %
    %  new_obj = SX()
    %  new_obj = SX(Sparsity sp)
    %  new_obj = SX(double val)
    %  new_obj = SX(IM x)
    %  new_obj = SX(SX m)
    %  new_obj = SX(int nrow, int ncol)
    %  new_obj = SX(Sparsity sp, SX d)
    %
    %
      self@casadi.MatrixCommon(SwigRef.Null);
      self@casadi.GenericExpressionCommon(SwigRef.Null);
      self@casadi.GenSX(SwigRef.Null);
      self@casadi.PrintableCommon(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(669, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];
      end
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(670, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
    function varargout = binary(varargin)
    %BINARY 
    %
    %  SX = BINARY(int op, SX x, SX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(601, varargin{:});
    end
    function varargout = unary(varargin)
    %UNARY 
    %
    %  SX = UNARY(int op, SX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(602, varargin{:});
    end
    function varargout = scalar_matrix(varargin)
    %SCALAR_MATRIX 
    %
    %  SX = SCALAR_MATRIX(int op, SX x, SX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(603, varargin{:});
    end
    function varargout = matrix_scalar(varargin)
    %MATRIX_SCALAR 
    %
    %  SX = MATRIX_SCALAR(int op, SX x, SX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(604, varargin{:});
    end
    function varargout = matrix_matrix(varargin)
    %MATRIX_MATRIX 
    %
    %  SX = MATRIX_MATRIX(int op, SX x, SX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(605, varargin{:});
    end
    function varargout = set_max_depth(varargin)
    %SET_MAX_DEPTH 
    %
    %  SET_MAX_DEPTH(int eq_depth)
    %
    %
     [varargout{1:nargout}] = casadiMEX(608, varargin{:});
    end
    function varargout = get_max_depth(varargin)
    %GET_MAX_DEPTH 
    %
    %  int = GET_MAX_DEPTH()
    %
    %
     [varargout{1:nargout}] = casadiMEX(609, varargin{:});
    end
    function varargout = get_input(varargin)
    %GET_INPUT 
    %
    %  {SX} = GET_INPUT(Function f)
    %
    %
     [varargout{1:nargout}] = casadiMEX(610, varargin{:});
    end
    function varargout = get_free(varargin)
    %GET_FREE 
    %
    %  {SX} = GET_FREE(Function f)
    %
    %
     [varargout{1:nargout}] = casadiMEX(611, varargin{:});
    end
    function varargout = type_name(varargin)
    %TYPE_NAME 
    %
    %  char = TYPE_NAME()
    %
    %
     [varargout{1:nargout}] = casadiMEX(612, varargin{:});
    end
    function varargout = triplet(varargin)
    %TRIPLET 
    %
    %  SX = TRIPLET([int] row, [int] col, SX d)
    %  SX = TRIPLET([int] row, [int] col, SX d, [int,int] rc)
    %  SX = TRIPLET([int] row, [int] col, SX d, int nrow, int ncol)
    %
    %
     [varargout{1:nargout}] = casadiMEX(627, varargin{:});
    end
    function varargout = inf(varargin)
    %INF 
    %
    %  SX = INF(int nrow, int ncol)
    %  SX = INF([int,int] rc)
    %  SX = INF(Sparsity sp)
    %
    %
     [varargout{1:nargout}] = casadiMEX(628, varargin{:});
    end
    function varargout = nan(varargin)
    %NAN 
    %
    %  SX = NAN(int nrow, int ncol)
    %  SX = NAN([int,int] rc)
    %  SX = NAN(Sparsity sp)
    %
    %
     [varargout{1:nargout}] = casadiMEX(629, varargin{:});
    end
    function varargout = eye(varargin)
    %EYE 
    %
    %  SX = EYE(int ncol)
    %
    %
     [varargout{1:nargout}] = casadiMEX(630, varargin{:});
    end
    function varargout = set_precision(varargin)
    %SET_PRECISION 
    %
    %  SET_PRECISION(int precision)
    %
    %
     [varargout{1:nargout}] = casadiMEX(654, varargin{:});
    end
    function varargout = set_width(varargin)
    %SET_WIDTH 
    %
    %  SET_WIDTH(int width)
    %
    %
     [varargout{1:nargout}] = casadiMEX(655, varargin{:});
    end
    function varargout = set_scientific(varargin)
    %SET_SCIENTIFIC 
    %
    %  SET_SCIENTIFIC(bool scientific)
    %
    %
     [varargout{1:nargout}] = casadiMEX(656, varargin{:});
    end
    function varargout = rng(varargin)
    %RNG 
    %
    %  RNG(int seed)
    %
    %
     [varargout{1:nargout}] = casadiMEX(657, varargin{:});
    end
    function varargout = rand(varargin)
    %RAND 
    %
    %  SX = RAND(int nrow, int ncol)
    %  SX = RAND([int,int] rc)
    %  SX = RAND(Sparsity sp)
    %
    %
     [varargout{1:nargout}] = casadiMEX(658, varargin{:});
    end
    function varargout = from_info(varargin)
    %FROM_INFO 
    %
    %  SX = FROM_INFO(struct info)
    %
    %
     [varargout{1:nargout}] = casadiMEX(661, varargin{:});
    end
  end
end
