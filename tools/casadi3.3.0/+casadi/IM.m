classdef  IM < casadi.MatrixCommon & casadi.GenericExpressionCommon & casadi.GenIM & casadi.PrintableCommon
    %IM Sparse matrix class. SX and DM are specializations.
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
      [varargout{1:nargout}] = casadiMEX(508, self, varargin{:});
    end
    function varargout = has_nz(self,varargin)
    %HAS_NZ 
    %
    %  bool = HAS_NZ(self, int rr, int cc)
    %
    %
      [varargout{1:nargout}] = casadiMEX(509, self, varargin{:});
    end
    function varargout = nonzero(self,varargin)
    %NONZERO [INTERNAL] 
    %
    %  bool = NONZERO(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(510, self, varargin{:});
    end
    function varargout = get(self,varargin)
    %GET 
    %
    %  IM = GET(self, bool ind1, Sparsity sp)
    %  IM = GET(self, bool ind1, Slice rr)
    %  IM = GET(self, bool ind1, IM rr)
    %  IM = GET(self, bool ind1, Slice rr, Slice cc)
    %  IM = GET(self, bool ind1, Slice rr, IM cc)
    %  IM = GET(self, bool ind1, IM rr, Slice cc)
    %  IM = GET(self, bool ind1, IM rr, IM cc)
    %
    %
      [varargout{1:nargout}] = casadiMEX(511, self, varargin{:});
    end
    function varargout = set(self,varargin)
    %SET 
    %
    %  SET(self, IM m, bool ind1, Sparsity sp)
    %  SET(self, IM m, bool ind1, Slice rr)
    %  SET(self, IM m, bool ind1, IM rr)
    %  SET(self, IM m, bool ind1, Slice rr, Slice cc)
    %  SET(self, IM m, bool ind1, Slice rr, IM cc)
    %  SET(self, IM m, bool ind1, IM rr, Slice cc)
    %  SET(self, IM m, bool ind1, IM rr, IM cc)
    %
    %
      [varargout{1:nargout}] = casadiMEX(512, self, varargin{:});
    end
    function varargout = get_nz(self,varargin)
    %GET_NZ 
    %
    %  IM = GET_NZ(self, bool ind1, Slice k)
    %  IM = GET_NZ(self, bool ind1, IM k)
    %
    %
      [varargout{1:nargout}] = casadiMEX(513, self, varargin{:});
    end
    function varargout = set_nz(self,varargin)
    %SET_NZ 
    %
    %  SET_NZ(self, IM m, bool ind1, Slice k)
    %  SET_NZ(self, IM m, bool ind1, IM k)
    %
    %
      [varargout{1:nargout}] = casadiMEX(514, self, varargin{:});
    end
    function varargout = uplus(self,varargin)
    %UPLUS 
    %
    %  IM = UPLUS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(515, self, varargin{:});
    end
    function varargout = uminus(self,varargin)
    %UMINUS 
    %
    %  IM = UMINUS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(516, self, varargin{:});
    end
    function varargout = printme(self,varargin)
    %PRINTME 
    %
    %  IM = PRINTME(self, IM y)
    %
    %
      [varargout{1:nargout}] = casadiMEX(522, self, varargin{:});
    end
    function varargout = T(self,varargin)
    %T 
    %
    %  IM = T(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(523, self, varargin{:});
    end
    function varargout = print_split(self,varargin)
    %PRINT_SPLIT 
    %
    %  [[char] OUTPUT, [char] OUTPUT] = PRINT_SPLIT(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(529, self, varargin{:});
    end
    function varargout = disp(self,varargin)
    %DISP 
    %
    %  std::ostream & = DISP(self, bool more)
    %
    %
      [varargout{1:nargout}] = casadiMEX(530, self, varargin{:});
    end
    function varargout = str(self,varargin)
    %STR 
    %
    %  char = STR(self, bool more)
    %
    %
      [varargout{1:nargout}] = casadiMEX(531, self, varargin{:});
    end
    function varargout = print_scalar(self,varargin)
    %PRINT_SCALAR 
    %
    %  std::ostream & = PRINT_SCALAR(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(532, self, varargin{:});
    end
    function varargout = print_vector(self,varargin)
    %PRINT_VECTOR 
    %
    %  std::ostream & = PRINT_VECTOR(self, bool truncate)
    %
    %
      [varargout{1:nargout}] = casadiMEX(533, self, varargin{:});
    end
    function varargout = print_dense(self,varargin)
    %PRINT_DENSE 
    %
    %  std::ostream & = PRINT_DENSE(self, bool truncate)
    %
    %
      [varargout{1:nargout}] = casadiMEX(534, self, varargin{:});
    end
    function varargout = print_sparse(self,varargin)
    %PRINT_SPARSE 
    %
    %  std::ostream & = PRINT_SPARSE(self, bool truncate)
    %
    %
      [varargout{1:nargout}] = casadiMEX(535, self, varargin{:});
    end
    function varargout = clear(self,varargin)
    %CLEAR 
    %
    %  CLEAR(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(536, self, varargin{:});
    end
    function varargout = resize(self,varargin)
    %RESIZE 
    %
    %  RESIZE(self, int nrow, int ncol)
    %
    %
      [varargout{1:nargout}] = casadiMEX(537, self, varargin{:});
    end
    function varargout = reserve(self,varargin)
    %RESERVE 
    %
    %  RESERVE(self, int nnz)
    %  RESERVE(self, int nnz, int ncol)
    %
    %
      [varargout{1:nargout}] = casadiMEX(538, self, varargin{:});
    end
    function varargout = erase(self,varargin)
    %ERASE 
    %
    %  ERASE(self, [int] rr, bool ind1)
    %  ERASE(self, [int] rr, [int] cc, bool ind1)
    %
    %
      [varargout{1:nargout}] = casadiMEX(539, self, varargin{:});
    end
    function varargout = remove(self,varargin)
    %REMOVE 
    %
    %  REMOVE(self, [int] rr, [int] cc)
    %
    %
      [varargout{1:nargout}] = casadiMEX(540, self, varargin{:});
    end
    function varargout = enlarge(self,varargin)
    %ENLARGE 
    %
    %  ENLARGE(self, int nrow, int ncol, [int] rr, [int] cc, bool ind1)
    %
    %
      [varargout{1:nargout}] = casadiMEX(541, self, varargin{:});
    end
    function varargout = sparsity(self,varargin)
    %SPARSITY 
    %
    %  Sparsity = SPARSITY(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(542, self, varargin{:});
    end
    function varargout = element_hash(self,varargin)
    %ELEMENT_HASH 
    %
    %  size_t = ELEMENT_HASH(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(547, self, varargin{:});
    end
    function varargout = is_regular(self,varargin)
    %IS_REGULAR 
    %
    %  bool = IS_REGULAR(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(548, self, varargin{:});
    end
    function varargout = is_smooth(self,varargin)
    %IS_SMOOTH 
    %
    %  bool = IS_SMOOTH(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(549, self, varargin{:});
    end
    function varargout = is_leaf(self,varargin)
    %IS_LEAF 
    %
    %  bool = IS_LEAF(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(550, self, varargin{:});
    end
    function varargout = is_commutative(self,varargin)
    %IS_COMMUTATIVE 
    %
    %  bool = IS_COMMUTATIVE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(551, self, varargin{:});
    end
    function varargout = is_symbolic(self,varargin)
    %IS_SYMBOLIC 
    %
    %  bool = IS_SYMBOLIC(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(552, self, varargin{:});
    end
    function varargout = is_valid_input(self,varargin)
    %IS_VALID_INPUT 
    %
    %  bool = IS_VALID_INPUT(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(553, self, varargin{:});
    end
    function varargout = has_duplicates(self,varargin)
    %HAS_DUPLICATES 
    %
    %  bool = HAS_DUPLICATES(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(554, self, varargin{:});
    end
    function varargout = reset_input(self,varargin)
    %RESET_INPUT 
    %
    %  RESET_INPUT(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(555, self, varargin{:});
    end
    function varargout = is_constant(self,varargin)
    %IS_CONSTANT 
    %
    %  bool = IS_CONSTANT(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(556, self, varargin{:});
    end
    function varargout = is_integer(self,varargin)
    %IS_INTEGER 
    %
    %  bool = IS_INTEGER(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(557, self, varargin{:});
    end
    function varargout = is_zero(self,varargin)
    %IS_ZERO 
    %
    %  bool = IS_ZERO(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(558, self, varargin{:});
    end
    function varargout = is_one(self,varargin)
    %IS_ONE 
    %
    %  bool = IS_ONE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(559, self, varargin{:});
    end
    function varargout = is_minus_one(self,varargin)
    %IS_MINUS_ONE 
    %
    %  bool = IS_MINUS_ONE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(560, self, varargin{:});
    end
    function varargout = is_eye(self,varargin)
    %IS_EYE 
    %
    %  bool = IS_EYE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(561, self, varargin{:});
    end
    function varargout = has_zeros(self,varargin)
    %HAS_ZEROS 
    %
    %  bool = HAS_ZEROS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(562, self, varargin{:});
    end
    function varargout = nonzeros(self,varargin)
    %NONZEROS 
    %
    %  [int] = NONZEROS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(563, self, varargin{:});
    end
    function varargout = elements(self,varargin)
    %ELEMENTS 
    %
    %  [int] = ELEMENTS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(564, self, varargin{:});
    end
    function varargout = to_double(self,varargin)
    %TO_DOUBLE 
    %
    %  double = TO_DOUBLE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(565, self, varargin{:});
    end
    function varargout = to_int(self,varargin)
    %TO_INT 
    %
    %  int = TO_INT(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(566, self, varargin{:});
    end
    function varargout = name(self,varargin)
    %NAME 
    %
    %  char = NAME(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(567, self, varargin{:});
    end
    function varargout = dep(self,varargin)
    %DEP 
    %
    %  IM = DEP(self, int ch)
    %
    %
      [varargout{1:nargout}] = casadiMEX(568, self, varargin{:});
    end
    function varargout = n_dep(self,varargin)
    %N_DEP 
    %
    %  int = N_DEP(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(569, self, varargin{:});
    end
    function varargout = export_code(self,varargin)
    %EXPORT_CODE 
    %
    %  std::ostream & = EXPORT_CODE(self, char lang, struct options)
    %
    %
      [varargout{1:nargout}] = casadiMEX(575, self, varargin{:});
    end
    function varargout = info(self,varargin)
    %INFO 
    %
    %  struct = INFO(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(576, self, varargin{:});
    end
    function self = IM(varargin)
    %IM 
    %
    %  new_obj = IM()
    %  new_obj = IM(Sparsity sp)
    %  new_obj = IM(double val)
    %  new_obj = IM(IM m)
    %  new_obj = IM(DM x)
    %  new_obj = IM(int nrow, int ncol)
    %  new_obj = IM(Sparsity sp, IM d)
    %
    %
      self@casadi.MatrixCommon(SwigRef.Null);
      self@casadi.GenericExpressionCommon(SwigRef.Null);
      self@casadi.GenIM(SwigRef.Null);
      self@casadi.PrintableCommon(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(578, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];
      end
    end
    function varargout = assign(self,varargin)
    %ASSIGN 
    %
    %  ASSIGN(self, IM rhs)
    %
    %
      [varargout{1:nargout}] = casadiMEX(579, self, varargin{:});
    end
    function varargout = paren(self,varargin)
    %PAREN 
    %
    %  IM = PAREN(self, Sparsity sp)
    %  IM = PAREN(self, IM rr)
    %  IM = PAREN(self, char rr)
    %  IM = PAREN(self, IM rr, IM cc)
    %  IM = PAREN(self, IM rr, char cc)
    %  IM = PAREN(self, char rr, IM cc)
    %  IM = PAREN(self, char rr, char cc)
    %
    %
      [varargout{1:nargout}] = casadiMEX(580, self, varargin{:});
    end
    function varargout = paren_asgn(self,varargin)
    %PAREN_ASGN 
    %
    %  PAREN_ASGN(self, IM m, Sparsity sp)
    %  PAREN_ASGN(self, IM m, IM rr)
    %  PAREN_ASGN(self, IM m, char rr)
    %  PAREN_ASGN(self, IM m, IM rr, IM cc)
    %  PAREN_ASGN(self, IM m, IM rr, char cc)
    %  PAREN_ASGN(self, IM m, char rr, IM cc)
    %  PAREN_ASGN(self, IM m, char rr, char cc)
    %
    %
      [varargout{1:nargout}] = casadiMEX(581, self, varargin{:});
    end
    function varargout = brace(self,varargin)
    %BRACE 
    %
    %  IM = BRACE(self, IM rr)
    %  IM = BRACE(self, char rr)
    %
    %
      [varargout{1:nargout}] = casadiMEX(582, self, varargin{:});
    end
    function varargout = setbrace(self,varargin)
    %SETBRACE 
    %
    %  SETBRACE(self, IM m, IM rr)
    %  SETBRACE(self, IM m, char rr)
    %
    %
      [varargout{1:nargout}] = casadiMEX(583, self, varargin{:});
    end
    function varargout = end(self,varargin)
    %END 
    %
    %  int = END(self, int i, int n)
    %
    %
      [varargout{1:nargout}] = casadiMEX(584, self, varargin{:});
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
      [varargout{1:nargout}] = casadiMEX(585, self, varargin{:});
    end
    function varargout = ctranspose(self,varargin)
    %CTRANSPOSE 
    %
    %  IM = CTRANSPOSE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(586, self, varargin{:});
    end
    function varargout = full(self,varargin)
    %FULL 
    %
    %  mxArray * = FULL(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(587, self, varargin{:});
    end
    function varargout = sparse(self,varargin)
    %SPARSE 
    %
    %  mxArray * = SPARSE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(588, self, varargin{:});
    end

     function s = saveobj(obj)
        s = obj.info();
     end
      function delete(self)
      if self.swigPtr
        casadiMEX(589, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
    function varargout = binary(varargin)
    %BINARY 
    %
    %  IM = BINARY(int op, IM x, IM y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(517, varargin{:});
    end
    function varargout = unary(varargin)
    %UNARY 
    %
    %  IM = UNARY(int op, IM x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(518, varargin{:});
    end
    function varargout = scalar_matrix(varargin)
    %SCALAR_MATRIX 
    %
    %  IM = SCALAR_MATRIX(int op, IM x, IM y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(519, varargin{:});
    end
    function varargout = matrix_scalar(varargin)
    %MATRIX_SCALAR 
    %
    %  IM = MATRIX_SCALAR(int op, IM x, IM y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(520, varargin{:});
    end
    function varargout = matrix_matrix(varargin)
    %MATRIX_MATRIX 
    %
    %  IM = MATRIX_MATRIX(int op, IM x, IM y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(521, varargin{:});
    end
    function varargout = set_max_depth(varargin)
    %SET_MAX_DEPTH 
    %
    %  SET_MAX_DEPTH(int eq_depth)
    %
    %
     [varargout{1:nargout}] = casadiMEX(524, varargin{:});
    end
    function varargout = get_max_depth(varargin)
    %GET_MAX_DEPTH 
    %
    %  int = GET_MAX_DEPTH()
    %
    %
     [varargout{1:nargout}] = casadiMEX(525, varargin{:});
    end
    function varargout = get_input(varargin)
    %GET_INPUT 
    %
    %  {IM} = GET_INPUT(Function f)
    %
    %
     [varargout{1:nargout}] = casadiMEX(526, varargin{:});
    end
    function varargout = get_free(varargin)
    %GET_FREE 
    %
    %  {IM} = GET_FREE(Function f)
    %
    %
     [varargout{1:nargout}] = casadiMEX(527, varargin{:});
    end
    function varargout = type_name(varargin)
    %TYPE_NAME 
    %
    %  char = TYPE_NAME()
    %
    %
     [varargout{1:nargout}] = casadiMEX(528, varargin{:});
    end
    function varargout = triplet(varargin)
    %TRIPLET 
    %
    %  IM = TRIPLET([int] row, [int] col, IM d)
    %  IM = TRIPLET([int] row, [int] col, IM d, [int,int] rc)
    %  IM = TRIPLET([int] row, [int] col, IM d, int nrow, int ncol)
    %
    %
     [varargout{1:nargout}] = casadiMEX(543, varargin{:});
    end
    function varargout = inf(varargin)
    %INF 
    %
    %  IM = INF(int nrow, int ncol)
    %  IM = INF([int,int] rc)
    %  IM = INF(Sparsity sp)
    %
    %
     [varargout{1:nargout}] = casadiMEX(544, varargin{:});
    end
    function varargout = nan(varargin)
    %NAN 
    %
    %  IM = NAN(int nrow, int ncol)
    %  IM = NAN([int,int] rc)
    %  IM = NAN(Sparsity sp)
    %
    %
     [varargout{1:nargout}] = casadiMEX(545, varargin{:});
    end
    function varargout = eye(varargin)
    %EYE 
    %
    %  IM = EYE(int ncol)
    %
    %
     [varargout{1:nargout}] = casadiMEX(546, varargin{:});
    end
    function varargout = set_precision(varargin)
    %SET_PRECISION 
    %
    %  SET_PRECISION(int precision)
    %
    %
     [varargout{1:nargout}] = casadiMEX(570, varargin{:});
    end
    function varargout = set_width(varargin)
    %SET_WIDTH 
    %
    %  SET_WIDTH(int width)
    %
    %
     [varargout{1:nargout}] = casadiMEX(571, varargin{:});
    end
    function varargout = set_scientific(varargin)
    %SET_SCIENTIFIC 
    %
    %  SET_SCIENTIFIC(bool scientific)
    %
    %
     [varargout{1:nargout}] = casadiMEX(572, varargin{:});
    end
    function varargout = rng(varargin)
    %RNG 
    %
    %  RNG(int seed)
    %
    %
     [varargout{1:nargout}] = casadiMEX(573, varargin{:});
    end
    function varargout = rand(varargin)
    %RAND 
    %
    %  IM = RAND(int nrow, int ncol)
    %  IM = RAND([int,int] rc)
    %  IM = RAND(Sparsity sp)
    %
    %
     [varargout{1:nargout}] = casadiMEX(574, varargin{:});
    end
    function varargout = from_info(varargin)
    %FROM_INFO 
    %
    %  IM = FROM_INFO(struct info)
    %
    %
     [varargout{1:nargout}] = casadiMEX(577, varargin{:});
    end

     function obj = loadobj(s)
        if isstruct(s)
           obj = casadi.IM.from_info(s);
        else
           obj = s;
        end
     end
    end
end
