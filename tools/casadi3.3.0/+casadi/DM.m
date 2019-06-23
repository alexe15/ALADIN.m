classdef  DM < casadi.MatrixCommon & casadi.GenericExpressionCommon & casadi.GenDM & casadi.PrintableCommon
    %DM Sparse matrix class. SX and DM are specializations.
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
      [varargout{1:nargout}] = casadiMEX(426, self, varargin{:});
    end
    function varargout = has_nz(self,varargin)
    %HAS_NZ 
    %
    %  bool = HAS_NZ(self, int rr, int cc)
    %
    %
      [varargout{1:nargout}] = casadiMEX(427, self, varargin{:});
    end
    function varargout = nonzero(self,varargin)
    %NONZERO [INTERNAL] 
    %
    %  bool = NONZERO(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(428, self, varargin{:});
    end
    function varargout = get(self,varargin)
    %GET 
    %
    %  DM = GET(self, bool ind1, Sparsity sp)
    %  DM = GET(self, bool ind1, Slice rr)
    %  DM = GET(self, bool ind1, IM rr)
    %  DM = GET(self, bool ind1, Slice rr, Slice cc)
    %  DM = GET(self, bool ind1, Slice rr, IM cc)
    %  DM = GET(self, bool ind1, IM rr, Slice cc)
    %  DM = GET(self, bool ind1, IM rr, IM cc)
    %
    %
      [varargout{1:nargout}] = casadiMEX(429, self, varargin{:});
    end
    function varargout = set(self,varargin)
    %SET 
    %
    %  SET(self, DM m, bool ind1, Sparsity sp)
    %  SET(self, DM m, bool ind1, Slice rr)
    %  SET(self, DM m, bool ind1, IM rr)
    %  SET(self, DM m, bool ind1, Slice rr, Slice cc)
    %  SET(self, DM m, bool ind1, Slice rr, IM cc)
    %  SET(self, DM m, bool ind1, IM rr, Slice cc)
    %  SET(self, DM m, bool ind1, IM rr, IM cc)
    %
    %
      [varargout{1:nargout}] = casadiMEX(430, self, varargin{:});
    end
    function varargout = get_nz(self,varargin)
    %GET_NZ 
    %
    %  DM = GET_NZ(self, bool ind1, Slice k)
    %  DM = GET_NZ(self, bool ind1, IM k)
    %
    %
      [varargout{1:nargout}] = casadiMEX(431, self, varargin{:});
    end
    function varargout = set_nz(self,varargin)
    %SET_NZ 
    %
    %  SET_NZ(self, DM m, bool ind1, Slice k)
    %  SET_NZ(self, DM m, bool ind1, IM k)
    %
    %
      [varargout{1:nargout}] = casadiMEX(432, self, varargin{:});
    end
    function varargout = uplus(self,varargin)
    %UPLUS 
    %
    %  DM = UPLUS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(433, self, varargin{:});
    end
    function varargout = uminus(self,varargin)
    %UMINUS 
    %
    %  DM = UMINUS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(434, self, varargin{:});
    end
    function varargout = printme(self,varargin)
    %PRINTME 
    %
    %  DM = PRINTME(self, DM y)
    %
    %
      [varargout{1:nargout}] = casadiMEX(440, self, varargin{:});
    end
    function varargout = T(self,varargin)
    %T 
    %
    %  DM = T(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(441, self, varargin{:});
    end
    function varargout = print_split(self,varargin)
    %PRINT_SPLIT 
    %
    %  [[char] OUTPUT, [char] OUTPUT] = PRINT_SPLIT(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(447, self, varargin{:});
    end
    function varargout = disp(self,varargin)
    %DISP 
    %
    %  std::ostream & = DISP(self, bool more)
    %
    %
      [varargout{1:nargout}] = casadiMEX(448, self, varargin{:});
    end
    function varargout = str(self,varargin)
    %STR 
    %
    %  char = STR(self, bool more)
    %
    %
      [varargout{1:nargout}] = casadiMEX(449, self, varargin{:});
    end
    function varargout = print_scalar(self,varargin)
    %PRINT_SCALAR 
    %
    %  std::ostream & = PRINT_SCALAR(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(450, self, varargin{:});
    end
    function varargout = print_vector(self,varargin)
    %PRINT_VECTOR 
    %
    %  std::ostream & = PRINT_VECTOR(self, bool truncate)
    %
    %
      [varargout{1:nargout}] = casadiMEX(451, self, varargin{:});
    end
    function varargout = print_dense(self,varargin)
    %PRINT_DENSE 
    %
    %  std::ostream & = PRINT_DENSE(self, bool truncate)
    %
    %
      [varargout{1:nargout}] = casadiMEX(452, self, varargin{:});
    end
    function varargout = print_sparse(self,varargin)
    %PRINT_SPARSE 
    %
    %  std::ostream & = PRINT_SPARSE(self, bool truncate)
    %
    %
      [varargout{1:nargout}] = casadiMEX(453, self, varargin{:});
    end
    function varargout = clear(self,varargin)
    %CLEAR 
    %
    %  CLEAR(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(454, self, varargin{:});
    end
    function varargout = resize(self,varargin)
    %RESIZE 
    %
    %  RESIZE(self, int nrow, int ncol)
    %
    %
      [varargout{1:nargout}] = casadiMEX(455, self, varargin{:});
    end
    function varargout = reserve(self,varargin)
    %RESERVE 
    %
    %  RESERVE(self, int nnz)
    %  RESERVE(self, int nnz, int ncol)
    %
    %
      [varargout{1:nargout}] = casadiMEX(456, self, varargin{:});
    end
    function varargout = erase(self,varargin)
    %ERASE 
    %
    %  ERASE(self, [int] rr, bool ind1)
    %  ERASE(self, [int] rr, [int] cc, bool ind1)
    %
    %
      [varargout{1:nargout}] = casadiMEX(457, self, varargin{:});
    end
    function varargout = remove(self,varargin)
    %REMOVE 
    %
    %  REMOVE(self, [int] rr, [int] cc)
    %
    %
      [varargout{1:nargout}] = casadiMEX(458, self, varargin{:});
    end
    function varargout = enlarge(self,varargin)
    %ENLARGE 
    %
    %  ENLARGE(self, int nrow, int ncol, [int] rr, [int] cc, bool ind1)
    %
    %
      [varargout{1:nargout}] = casadiMEX(459, self, varargin{:});
    end
    function varargout = sparsity(self,varargin)
    %SPARSITY 
    %
    %  Sparsity = SPARSITY(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(460, self, varargin{:});
    end
    function varargout = element_hash(self,varargin)
    %ELEMENT_HASH 
    %
    %  size_t = ELEMENT_HASH(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(465, self, varargin{:});
    end
    function varargout = is_regular(self,varargin)
    %IS_REGULAR 
    %
    %  bool = IS_REGULAR(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(466, self, varargin{:});
    end
    function varargout = is_smooth(self,varargin)
    %IS_SMOOTH 
    %
    %  bool = IS_SMOOTH(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(467, self, varargin{:});
    end
    function varargout = is_leaf(self,varargin)
    %IS_LEAF 
    %
    %  bool = IS_LEAF(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(468, self, varargin{:});
    end
    function varargout = is_commutative(self,varargin)
    %IS_COMMUTATIVE 
    %
    %  bool = IS_COMMUTATIVE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(469, self, varargin{:});
    end
    function varargout = is_symbolic(self,varargin)
    %IS_SYMBOLIC 
    %
    %  bool = IS_SYMBOLIC(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(470, self, varargin{:});
    end
    function varargout = is_valid_input(self,varargin)
    %IS_VALID_INPUT 
    %
    %  bool = IS_VALID_INPUT(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(471, self, varargin{:});
    end
    function varargout = has_duplicates(self,varargin)
    %HAS_DUPLICATES 
    %
    %  bool = HAS_DUPLICATES(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(472, self, varargin{:});
    end
    function varargout = reset_input(self,varargin)
    %RESET_INPUT 
    %
    %  RESET_INPUT(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(473, self, varargin{:});
    end
    function varargout = is_constant(self,varargin)
    %IS_CONSTANT 
    %
    %  bool = IS_CONSTANT(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(474, self, varargin{:});
    end
    function varargout = is_integer(self,varargin)
    %IS_INTEGER 
    %
    %  bool = IS_INTEGER(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(475, self, varargin{:});
    end
    function varargout = is_zero(self,varargin)
    %IS_ZERO 
    %
    %  bool = IS_ZERO(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(476, self, varargin{:});
    end
    function varargout = is_one(self,varargin)
    %IS_ONE 
    %
    %  bool = IS_ONE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(477, self, varargin{:});
    end
    function varargout = is_minus_one(self,varargin)
    %IS_MINUS_ONE 
    %
    %  bool = IS_MINUS_ONE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(478, self, varargin{:});
    end
    function varargout = is_eye(self,varargin)
    %IS_EYE 
    %
    %  bool = IS_EYE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(479, self, varargin{:});
    end
    function varargout = has_zeros(self,varargin)
    %HAS_ZEROS 
    %
    %  bool = HAS_ZEROS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(480, self, varargin{:});
    end
    function varargout = nonzeros(self,varargin)
    %NONZEROS 
    %
    %  [double] = NONZEROS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(481, self, varargin{:});
    end
    function varargout = elements(self,varargin)
    %ELEMENTS 
    %
    %  [double] = ELEMENTS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(482, self, varargin{:});
    end
    function varargout = to_double(self,varargin)
    %TO_DOUBLE 
    %
    %  double = TO_DOUBLE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(483, self, varargin{:});
    end
    function varargout = to_int(self,varargin)
    %TO_INT 
    %
    %  int = TO_INT(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(484, self, varargin{:});
    end
    function varargout = name(self,varargin)
    %NAME 
    %
    %  char = NAME(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(485, self, varargin{:});
    end
    function varargout = dep(self,varargin)
    %DEP 
    %
    %  DM = DEP(self, int ch)
    %
    %
      [varargout{1:nargout}] = casadiMEX(486, self, varargin{:});
    end
    function varargout = n_dep(self,varargin)
    %N_DEP 
    %
    %  int = N_DEP(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(487, self, varargin{:});
    end
    function varargout = export_code(self,varargin)
    %EXPORT_CODE 
    %
    %  std::ostream & = EXPORT_CODE(self, char lang, struct options)
    %
    %
      [varargout{1:nargout}] = casadiMEX(493, self, varargin{:});
    end
    function varargout = info(self,varargin)
    %INFO 
    %
    %  struct = INFO(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(494, self, varargin{:});
    end
    function self = DM(varargin)
    %DM 
    %
    %  new_obj = DM()
    %  new_obj = DM(Sparsity sp)
    %  new_obj = DM(double val)
    %  new_obj = DM(IM x)
    %  new_obj = DM(DM m)
    %  new_obj = DM(int nrow, int ncol)
    %  new_obj = DM(Sparsity sp, DM d)
    %
    %
      self@casadi.MatrixCommon(SwigRef.Null);
      self@casadi.GenericExpressionCommon(SwigRef.Null);
      self@casadi.GenDM(SwigRef.Null);
      self@casadi.PrintableCommon(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(496, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];
      end
    end
    function varargout = assign(self,varargin)
    %ASSIGN 
    %
    %  ASSIGN(self, DM rhs)
    %
    %
      [varargout{1:nargout}] = casadiMEX(497, self, varargin{:});
    end
    function varargout = paren(self,varargin)
    %PAREN 
    %
    %  DM = PAREN(self, Sparsity sp)
    %  DM = PAREN(self, IM rr)
    %  DM = PAREN(self, char rr)
    %  DM = PAREN(self, IM rr, IM cc)
    %  DM = PAREN(self, IM rr, char cc)
    %  DM = PAREN(self, char rr, IM cc)
    %  DM = PAREN(self, char rr, char cc)
    %
    %
      [varargout{1:nargout}] = casadiMEX(498, self, varargin{:});
    end
    function varargout = paren_asgn(self,varargin)
    %PAREN_ASGN 
    %
    %  PAREN_ASGN(self, DM m, Sparsity sp)
    %  PAREN_ASGN(self, DM m, IM rr)
    %  PAREN_ASGN(self, DM m, char rr)
    %  PAREN_ASGN(self, DM m, IM rr, IM cc)
    %  PAREN_ASGN(self, DM m, IM rr, char cc)
    %  PAREN_ASGN(self, DM m, char rr, IM cc)
    %  PAREN_ASGN(self, DM m, char rr, char cc)
    %
    %
      [varargout{1:nargout}] = casadiMEX(499, self, varargin{:});
    end
    function varargout = brace(self,varargin)
    %BRACE 
    %
    %  DM = BRACE(self, IM rr)
    %  DM = BRACE(self, char rr)
    %
    %
      [varargout{1:nargout}] = casadiMEX(500, self, varargin{:});
    end
    function varargout = setbrace(self,varargin)
    %SETBRACE 
    %
    %  SETBRACE(self, DM m, IM rr)
    %  SETBRACE(self, DM m, char rr)
    %
    %
      [varargout{1:nargout}] = casadiMEX(501, self, varargin{:});
    end
    function varargout = end(self,varargin)
    %END 
    %
    %  int = END(self, int i, int n)
    %
    %
      [varargout{1:nargout}] = casadiMEX(502, self, varargin{:});
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
      [varargout{1:nargout}] = casadiMEX(503, self, varargin{:});
    end
    function varargout = ctranspose(self,varargin)
    %CTRANSPOSE 
    %
    %  DM = CTRANSPOSE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(504, self, varargin{:});
    end
    function varargout = full(self,varargin)
    %FULL 
    %
    %  mxArray * = FULL(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(505, self, varargin{:});
    end
    function varargout = sparse(self,varargin)
    %SPARSE 
    %
    %  mxArray * = SPARSE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(506, self, varargin{:});
    end

     function s = saveobj(obj)
        s = obj.info();
     end
      function delete(self)
      if self.swigPtr
        casadiMEX(507, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
    function varargout = binary(varargin)
    %BINARY 
    %
    %  DM = BINARY(int op, DM x, DM y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(435, varargin{:});
    end
    function varargout = unary(varargin)
    %UNARY 
    %
    %  DM = UNARY(int op, DM x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(436, varargin{:});
    end
    function varargout = scalar_matrix(varargin)
    %SCALAR_MATRIX 
    %
    %  DM = SCALAR_MATRIX(int op, DM x, DM y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(437, varargin{:});
    end
    function varargout = matrix_scalar(varargin)
    %MATRIX_SCALAR 
    %
    %  DM = MATRIX_SCALAR(int op, DM x, DM y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(438, varargin{:});
    end
    function varargout = matrix_matrix(varargin)
    %MATRIX_MATRIX 
    %
    %  DM = MATRIX_MATRIX(int op, DM x, DM y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(439, varargin{:});
    end
    function varargout = set_max_depth(varargin)
    %SET_MAX_DEPTH 
    %
    %  SET_MAX_DEPTH(int eq_depth)
    %
    %
     [varargout{1:nargout}] = casadiMEX(442, varargin{:});
    end
    function varargout = get_max_depth(varargin)
    %GET_MAX_DEPTH 
    %
    %  int = GET_MAX_DEPTH()
    %
    %
     [varargout{1:nargout}] = casadiMEX(443, varargin{:});
    end
    function varargout = get_input(varargin)
    %GET_INPUT 
    %
    %  {DM} = GET_INPUT(Function f)
    %
    %
     [varargout{1:nargout}] = casadiMEX(444, varargin{:});
    end
    function varargout = get_free(varargin)
    %GET_FREE 
    %
    %  {DM} = GET_FREE(Function f)
    %
    %
     [varargout{1:nargout}] = casadiMEX(445, varargin{:});
    end
    function varargout = type_name(varargin)
    %TYPE_NAME 
    %
    %  char = TYPE_NAME()
    %
    %
     [varargout{1:nargout}] = casadiMEX(446, varargin{:});
    end
    function varargout = triplet(varargin)
    %TRIPLET 
    %
    %  DM = TRIPLET([int] row, [int] col, DM d)
    %  DM = TRIPLET([int] row, [int] col, DM d, [int,int] rc)
    %  DM = TRIPLET([int] row, [int] col, DM d, int nrow, int ncol)
    %
    %
     [varargout{1:nargout}] = casadiMEX(461, varargin{:});
    end
    function varargout = inf(varargin)
    %INF 
    %
    %  DM = INF(int nrow, int ncol)
    %  DM = INF([int,int] rc)
    %  DM = INF(Sparsity sp)
    %
    %
     [varargout{1:nargout}] = casadiMEX(462, varargin{:});
    end
    function varargout = nan(varargin)
    %NAN 
    %
    %  DM = NAN(int nrow, int ncol)
    %  DM = NAN([int,int] rc)
    %  DM = NAN(Sparsity sp)
    %
    %
     [varargout{1:nargout}] = casadiMEX(463, varargin{:});
    end
    function varargout = eye(varargin)
    %EYE 
    %
    %  DM = EYE(int ncol)
    %
    %
     [varargout{1:nargout}] = casadiMEX(464, varargin{:});
    end
    function varargout = set_precision(varargin)
    %SET_PRECISION 
    %
    %  SET_PRECISION(int precision)
    %
    %
     [varargout{1:nargout}] = casadiMEX(488, varargin{:});
    end
    function varargout = set_width(varargin)
    %SET_WIDTH 
    %
    %  SET_WIDTH(int width)
    %
    %
     [varargout{1:nargout}] = casadiMEX(489, varargin{:});
    end
    function varargout = set_scientific(varargin)
    %SET_SCIENTIFIC 
    %
    %  SET_SCIENTIFIC(bool scientific)
    %
    %
     [varargout{1:nargout}] = casadiMEX(490, varargin{:});
    end
    function varargout = rng(varargin)
    %RNG 
    %
    %  RNG(int seed)
    %
    %
     [varargout{1:nargout}] = casadiMEX(491, varargin{:});
    end
    function varargout = rand(varargin)
    %RAND 
    %
    %  DM = RAND(int nrow, int ncol)
    %  DM = RAND([int,int] rc)
    %  DM = RAND(Sparsity sp)
    %
    %
     [varargout{1:nargout}] = casadiMEX(492, varargin{:});
    end
    function varargout = from_info(varargin)
    %FROM_INFO 
    %
    %  DM = FROM_INFO(struct info)
    %
    %
     [varargout{1:nargout}] = casadiMEX(495, varargin{:});
    end

     function obj = loadobj(s)
        if isstruct(s)
           obj = casadi.DM.from_info(s);
        else
           obj = s;
        end
     end
    end
end
