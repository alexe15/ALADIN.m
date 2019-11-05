classdef  IM < casadi.MatrixCommon & casadi.GenericExpressionCommon & casadi.GenIM & casadi.PrintableCommon
    %IM 
    %
    %
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function varargout = sanity_check(self,varargin)
    %SANITY_CHECK [DEPRECATED] Correctness is checked during construction
    %
    %  SANITY_CHECK(self, bool complete)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(525, self, varargin{:});
    end
    function varargout = has_nz(self,varargin)
    %HAS_NZ Returns true if the matrix has a non-zero at location rr, cc.
    %
    %  bool = HAS_NZ(self, int rr, int cc)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(526, self, varargin{:});
    end
    function varargout = nonzero(self,varargin)
    %NONZERO [INTERNAL] 
    %
    %  bool = NONZERO(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(527, self, varargin{:});
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
      [varargout{1:nargout}] = casadiMEX(528, self, varargin{:});
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
      [varargout{1:nargout}] = casadiMEX(529, self, varargin{:});
    end
    function varargout = get_nz(self,varargin)
    %GET_NZ 
    %
    %  IM = GET_NZ(self, bool ind1, Slice k)
    %  IM = GET_NZ(self, bool ind1, IM k)
    %
    %
      [varargout{1:nargout}] = casadiMEX(530, self, varargin{:});
    end
    function varargout = set_nz(self,varargin)
    %SET_NZ 
    %
    %  SET_NZ(self, IM m, bool ind1, Slice k)
    %  SET_NZ(self, IM m, bool ind1, IM k)
    %
    %
      [varargout{1:nargout}] = casadiMEX(531, self, varargin{:});
    end
    function varargout = uplus(self,varargin)
    %UPLUS 
    %
    %  IM = UPLUS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(532, self, varargin{:});
    end
    function varargout = uminus(self,varargin)
    %UMINUS 
    %
    %  IM = UMINUS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(533, self, varargin{:});
    end
    function varargout = printme(self,varargin)
    %PRINTME 
    %
    %  IM = PRINTME(self, IM y)
    %
    %
      [varargout{1:nargout}] = casadiMEX(539, self, varargin{:});
    end
    function varargout = T(self,varargin)
    %T Transpose the matrix.
    %
    %  IM = T(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(540, self, varargin{:});
    end
    function varargout = print_split(self,varargin)
    %PRINT_SPLIT 
    %
    %  [{char} OUTPUT, {char} OUTPUT] = PRINT_SPLIT(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(546, self, varargin{:});
    end
    function varargout = disp(self,varargin)
    %DISP Print a representation of the object.
    %
    %  std::ostream & = DISP(self, bool more)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(547, self, varargin{:});
    end
    function varargout = str(self,varargin)
    %STR Get string representation.
    %
    %  char = STR(self, bool more)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(548, self, varargin{:});
    end
    function varargout = print_scalar(self,varargin)
    %PRINT_SCALAR Print scalar.
    %
    %  std::ostream & = PRINT_SCALAR(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(549, self, varargin{:});
    end
    function varargout = print_vector(self,varargin)
    %PRINT_VECTOR Print vector-style.
    %
    %  std::ostream & = PRINT_VECTOR(self, bool truncate)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(550, self, varargin{:});
    end
    function varargout = print_dense(self,varargin)
    %PRINT_DENSE Print dense matrix-stype.
    %
    %  std::ostream & = PRINT_DENSE(self, bool truncate)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(551, self, varargin{:});
    end
    function varargout = print_sparse(self,varargin)
    %PRINT_SPARSE Print sparse matrix style.
    %
    %  std::ostream & = PRINT_SPARSE(self, bool truncate)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(552, self, varargin{:});
    end
    function varargout = clear(self,varargin)
    %CLEAR 
    %
    %  CLEAR(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(553, self, varargin{:});
    end
    function varargout = resize(self,varargin)
    %RESIZE 
    %
    %  RESIZE(self, int nrow, int ncol)
    %
    %
      [varargout{1:nargout}] = casadiMEX(554, self, varargin{:});
    end
    function varargout = reserve(self,varargin)
    %RESERVE 
    %
    %  RESERVE(self, int nnz)
    %  RESERVE(self, int nnz, int ncol)
    %
    %
      [varargout{1:nargout}] = casadiMEX(555, self, varargin{:});
    end
    function varargout = erase(self,varargin)
    %ERASE Erase a submatrix (leaving structural zeros in its place) Erase elements of
    %
    %  ERASE(self, [int] rr, bool ind1)
    %  ERASE(self, [int] rr, [int] cc, bool ind1)
    %    Erase a submatrix (leaving structural zeros in its place) Erase rows and/or
    %
    %a matrix.
    %
    %
    %> ERASE(self, [int] rr, bool ind1)
    %------------------------------------------------------------------------
    %
    %
    %Erase a submatrix (leaving structural zeros in its place) Erase elements of
    %a matrix.
    %
    %
    %> ERASE(self, [int] rr, [int] cc, bool ind1)
    %------------------------------------------------------------------------
    %
    %
    %Erase a submatrix (leaving structural zeros in its place) Erase rows and/or
    %columns of a matrix.
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(556, self, varargin{:});
    end
    function varargout = remove(self,varargin)
    %REMOVE Remove columns and rows Remove/delete rows and/or columns of a matrix.
    %
    %  REMOVE(self, [int] rr, [int] cc)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(557, self, varargin{:});
    end
    function varargout = enlarge(self,varargin)
    %ENLARGE Enlarge matrix Make the matrix larger by inserting empty rows and columns,
    %
    %  ENLARGE(self, int nrow, int ncol, [int] rr, [int] cc, bool ind1)
    %
    %keeping the existing non-zeros.
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(558, self, varargin{:});
    end
    function varargout = sparsity(self,varargin)
    %SPARSITY Get an owning reference to the sparsity pattern.
    %
    %  Sparsity = SPARSITY(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(559, self, varargin{:});
    end
    function varargout = element_hash(self,varargin)
    %ELEMENT_HASH 
    %
    %  int = ELEMENT_HASH(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(564, self, varargin{:});
    end
    function varargout = is_regular(self,varargin)
    %IS_REGULAR 
    %
    %  bool = IS_REGULAR(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(565, self, varargin{:});
    end
    function varargout = is_smooth(self,varargin)
    %IS_SMOOTH 
    %
    %  bool = IS_SMOOTH(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(566, self, varargin{:});
    end
    function varargout = is_leaf(self,varargin)
    %IS_LEAF 
    %
    %  bool = IS_LEAF(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(567, self, varargin{:});
    end
    function varargout = is_commutative(self,varargin)
    %IS_COMMUTATIVE 
    %
    %  bool = IS_COMMUTATIVE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(568, self, varargin{:});
    end
    function varargout = is_symbolic(self,varargin)
    %IS_SYMBOLIC 
    %
    %  bool = IS_SYMBOLIC(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(569, self, varargin{:});
    end
    function varargout = is_valid_input(self,varargin)
    %IS_VALID_INPUT 
    %
    %  bool = IS_VALID_INPUT(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(570, self, varargin{:});
    end
    function varargout = has_duplicates(self,varargin)
    %HAS_DUPLICATES 
    %
    %  bool = HAS_DUPLICATES(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(571, self, varargin{:});
    end
    function varargout = reset_input(self,varargin)
    %RESET_INPUT 
    %
    %  RESET_INPUT(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(572, self, varargin{:});
    end
    function varargout = is_constant(self,varargin)
    %IS_CONSTANT Check if the matrix is constant (note that false negative answers are
    %
    %  bool = IS_CONSTANT(self)
    %
    %possible)
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(573, self, varargin{:});
    end
    function varargout = is_integer(self,varargin)
    %IS_INTEGER Check if the matrix is integer-valued (note that false negative answers are
    %
    %  bool = IS_INTEGER(self)
    %
    %possible)
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(574, self, varargin{:});
    end
    function varargout = is_zero(self,varargin)
    %IS_ZERO check if the matrix is 0 (note that false negative answers are possible)
    %
    %  bool = IS_ZERO(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(575, self, varargin{:});
    end
    function varargout = is_one(self,varargin)
    %IS_ONE check if the matrix is 1 (note that false negative answers are possible)
    %
    %  bool = IS_ONE(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(576, self, varargin{:});
    end
    function varargout = is_minus_one(self,varargin)
    %IS_MINUS_ONE check if the matrix is -1 (note that false negative answers are possible)
    %
    %  bool = IS_MINUS_ONE(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(577, self, varargin{:});
    end
    function varargout = is_eye(self,varargin)
    %IS_EYE check if the matrix is an identity matrix (note that false negative answers
    %
    %  bool = IS_EYE(self)
    %
    %are possible)
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(578, self, varargin{:});
    end
    function varargout = op(self,varargin)
    %OP 
    %
    %  int = OP(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(579, self, varargin{:});
    end
    function varargout = is_op(self,varargin)
    %IS_OP 
    %
    %  bool = IS_OP(self, int op)
    %
    %
      [varargout{1:nargout}] = casadiMEX(580, self, varargin{:});
    end
    function varargout = has_zeros(self,varargin)
    %HAS_ZEROS Check if the matrix has any zero entries which are not structural zeros.
    %
    %  bool = HAS_ZEROS(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(581, self, varargin{:});
    end
    function varargout = nonzeros(self,varargin)
    %NONZEROS Get all nonzeros.
    %
    %  [int] = NONZEROS(self)
    %
    %
    %Implementation of Matrix::get_nonzeros (in public API)
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(582, self, varargin{:});
    end
    function varargout = elements(self,varargin)
    %ELEMENTS Get all elements.
    %
    %  [int] = ELEMENTS(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(583, self, varargin{:});
    end
    function varargout = to_double(self,varargin)
    %TO_DOUBLE 
    %
    %  double = TO_DOUBLE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(584, self, varargin{:});
    end
    function varargout = to_int(self,varargin)
    %TO_INT 
    %
    %  int = TO_INT(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(585, self, varargin{:});
    end
    function varargout = name(self,varargin)
    %NAME 
    %
    %  char = NAME(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(586, self, varargin{:});
    end
    function varargout = dep(self,varargin)
    %DEP 
    %
    %  IM = DEP(self, int ch)
    %
    %
      [varargout{1:nargout}] = casadiMEX(587, self, varargin{:});
    end
    function varargout = n_dep(self,varargin)
    %N_DEP 
    %
    %  int = N_DEP(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(588, self, varargin{:});
    end
    function varargout = export_code(self,varargin)
    %EXPORT_CODE Export matrix in specific language.
    %
    %  std::ostream & = EXPORT_CODE(self, char lang, struct options)
    %
    %
    %lang: only 'matlab' supported for now
    %
    %::
    %
    %  * options:
    %  *   inline: Indicates if you want everything on a single line (default: False)
    %  *   name: Name of exported variable (default: 'm')
    %  *   indent_level: Level of indentation (default: 0)
    %  *   spoof_zero: Replace numerical zero by a 1e-200 (default: false)
    %  *               might be needed for matlab sparse construct,
    %  *               which doesn't allow numerical zero
    %  * 
    %
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(594, self, varargin{:});
    end
    function varargout = info(self,varargin)
    %INFO Obtain information about sparsity
    %
    %  struct = INFO(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(595, self, varargin{:});
    end
    function varargout = to_file(self,varargin)
    %TO_FILE Export numerical matrix to file
    %
    %  TO_FILE(self, char filename, char format)
    %
    %
    %Supported formats: .mtx Matrix Market
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(597, self, varargin{:});
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
        tmp = casadiMEX(598, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.SwigClear();
      end
    end
    function varargout = assign(self,varargin)
    %ASSIGN 
    %
    %  ASSIGN(self, IM rhs)
    %
    %
      [varargout{1:nargout}] = casadiMEX(599, self, varargin{:});
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
      [varargout{1:nargout}] = casadiMEX(600, self, varargin{:});
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
      [varargout{1:nargout}] = casadiMEX(601, self, varargin{:});
    end
    function varargout = brace(self,varargin)
    %BRACE 
    %
    %  IM = BRACE(self, IM rr)
    %  IM = BRACE(self, char rr)
    %
    %
      [varargout{1:nargout}] = casadiMEX(602, self, varargin{:});
    end
    function varargout = setbrace(self,varargin)
    %SETBRACE 
    %
    %  SETBRACE(self, IM m, IM rr)
    %  SETBRACE(self, IM m, char rr)
    %
    %
      [varargout{1:nargout}] = casadiMEX(603, self, varargin{:});
    end
    function varargout = end(self,varargin)
    %END 
    %
    %  int = END(self, int i, int n)
    %
    %
      [varargout{1:nargout}] = casadiMEX(604, self, varargin{:});
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
      [varargout{1:nargout}] = casadiMEX(605, self, varargin{:});
    end
    function varargout = ctranspose(self,varargin)
    %CTRANSPOSE 
    %
    %  IM = CTRANSPOSE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(606, self, varargin{:});
    end
    function varargout = full(self,varargin)
    %FULL 
    %
    %  mxArray * = FULL(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(607, self, varargin{:});
    end
    function varargout = sparse(self,varargin)
    %SPARSE 
    %
    %  mxArray * = SPARSE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(608, self, varargin{:});
    end

     function s = saveobj(obj)
        s = obj.info();
     end
      function delete(self)
        if self.swigPtr
          casadiMEX(609, self);
          self.SwigClear();
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
     [varargout{1:nargout}] = casadiMEX(534, varargin{:});
    end
    function varargout = unary(varargin)
    %UNARY 
    %
    %  IM = UNARY(int op, IM x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(535, varargin{:});
    end
    function varargout = scalar_matrix(varargin)
    %SCALAR_MATRIX 
    %
    %  IM = SCALAR_MATRIX(int op, IM x, IM y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(536, varargin{:});
    end
    function varargout = matrix_scalar(varargin)
    %MATRIX_SCALAR 
    %
    %  IM = MATRIX_SCALAR(int op, IM x, IM y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(537, varargin{:});
    end
    function varargout = matrix_matrix(varargin)
    %MATRIX_MATRIX 
    %
    %  IM = MATRIX_MATRIX(int op, IM x, IM y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(538, varargin{:});
    end
    function varargout = set_max_depth(varargin)
    %SET_MAX_DEPTH 
    %
    %  SET_MAX_DEPTH(int eq_depth)
    %
    %
     [varargout{1:nargout}] = casadiMEX(541, varargin{:});
    end
    function varargout = get_max_depth(varargin)
    %GET_MAX_DEPTH 
    %
    %  int = GET_MAX_DEPTH()
    %
    %
     [varargout{1:nargout}] = casadiMEX(542, varargin{:});
    end
    function varargout = get_input(varargin)
    %GET_INPUT 
    %
    %  std::vector< casadi::Matrix< long long >,std::allocator< casadi::Matrix< casadi_int > > > = GET_INPUT(Function f)
    %
    %
     [varargout{1:nargout}] = casadiMEX(543, varargin{:});
    end
    function varargout = get_free(varargin)
    %GET_FREE 
    %
    %  std::vector< casadi::Matrix< long long >,std::allocator< casadi::Matrix< casadi_int > > > = GET_FREE(Function f)
    %
    %
     [varargout{1:nargout}] = casadiMEX(544, varargin{:});
    end
    function varargout = type_name(varargin)
    %TYPE_NAME 
    %
    %  char = TYPE_NAME()
    %
    %
     [varargout{1:nargout}] = casadiMEX(545, varargin{:});
    end
    function varargout = triplet(varargin)
    %TRIPLET 
    %
    %  IM = TRIPLET([int] row, [int] col, IM d)
    %  IM = TRIPLET([int] row, [int] col, IM d, [int,int] rc)
    %  IM = TRIPLET([int] row, [int] col, IM d, int nrow, int ncol)
    %
    %
     [varargout{1:nargout}] = casadiMEX(560, varargin{:});
    end
    function varargout = inf(varargin)
    %INF create a matrix with all inf
    %
    %  IM = INF(int nrow, int ncol)
    %  IM = INF([int,int] rc)
    %  IM = INF(Sparsity sp)
    %
    %
    %
    %
     [varargout{1:nargout}] = casadiMEX(561, varargin{:});
    end
    function varargout = nan(varargin)
    %NAN create a matrix with all nan
    %
    %  IM = NAN(int nrow, int ncol)
    %  IM = NAN([int,int] rc)
    %  IM = NAN(Sparsity sp)
    %
    %
    %
    %
     [varargout{1:nargout}] = casadiMEX(562, varargin{:});
    end
    function varargout = eye(varargin)
    %EYE 
    %
    %  IM = EYE(int ncol)
    %
    %
     [varargout{1:nargout}] = casadiMEX(563, varargin{:});
    end
    function varargout = set_precision(varargin)
    %SET_PRECISION Set the 'precision, width & scientific' used in printing and serializing to
    %
    %  SET_PRECISION(int precision)
    %
    %streams.
    %
    %
    %
     [varargout{1:nargout}] = casadiMEX(589, varargin{:});
    end
    function varargout = set_width(varargin)
    %SET_WIDTH Set the 'precision, width & scientific' used in printing and serializing to
    %
    %  SET_WIDTH(int width)
    %
    %streams.
    %
    %
    %
     [varargout{1:nargout}] = casadiMEX(590, varargin{:});
    end
    function varargout = set_scientific(varargin)
    %SET_SCIENTIFIC Set the 'precision, width & scientific' used in printing and serializing to
    %
    %  SET_SCIENTIFIC(bool scientific)
    %
    %streams.
    %
    %
    %
     [varargout{1:nargout}] = casadiMEX(591, varargin{:});
    end
    function varargout = rng(varargin)
    %RNG 
    %
    %  RNG(int seed)
    %
    %
     [varargout{1:nargout}] = casadiMEX(592, varargin{:});
    end
    function varargout = rand(varargin)
    %RAND Create a matrix with uniformly distributed random numbers.
    %
    %  IM = RAND(int nrow, int ncol)
    %  IM = RAND([int,int] rc)
    %  IM = RAND(Sparsity sp)
    %
    %
    %
    %
     [varargout{1:nargout}] = casadiMEX(593, varargin{:});
    end
    function varargout = from_info(varargin)
    %FROM_INFO 
    %
    %  IM = FROM_INFO(struct info)
    %
    %
     [varargout{1:nargout}] = casadiMEX(596, varargin{:});
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
