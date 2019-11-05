classdef  MX < casadi.GenericExpressionCommon & casadi.PrintableCommon & casadi.GenMX & casadi.SharedObject
    %MX MX - Matrix expression.
    %
    %
    %
    %The MX class is used to build up trees made up from MXNodes. It is a more
    %general graph representation than the scalar expression, SX, and much less
    %efficient for small objects. On the other hand, the class allows much more
    %general operations than does SX, in particular matrix valued operations and
    %calls to arbitrary differentiable functions.
    %
    %The MX class is designed to have identical syntax with the Matrix<> template
    %class, and uses DM (i.e. Matrix<double>) as its internal representation of
    %the values at a node. By keeping the syntaxes identical, it is possible to
    %switch from one class to the other, as well as inlining MX functions to
    %SXElem functions.
    %
    %Note that an operation is always "lazy", making a matrix multiplication
    %will create a matrix multiplication node, not perform the actual
    %multiplication.
    %
    %Joel Andersson
    %
    %C++ includes: mx.hpp 
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function self = MX(varargin)
    %MX 
    %
    %  new_obj = MX()
    %    Default constructor.
    %  new_obj = MX(Sparsity sp)
    %    Create a sparse matrix from a sparsity pattern. Same as MX::ones(sparsity)
    %  new_obj = MX(double x)
    %    Create scalar constant (also implicit type conversion)
    %  new_obj = MX([double] x)
    %    Create vector constant (also implicit type conversion)
    %  new_obj = MX(MX x)
    %    Copy constructor.
    %  new_obj = MX(int nrow, int ncol)
    %    Create a sparse matrix with all structural zeros.
    %  new_obj = MX(Sparsity sp, MX val)
    %    Construct matrix with a given sparsity and nonzeros.
    %
    %> MX(Sparsity sp)
    %------------------------------------------------------------------------
    %
    %
    %Create a sparse matrix from a sparsity pattern. Same as MX::ones(sparsity)
    %
    %
    %> MX(Sparsity sp, MX val)
    %------------------------------------------------------------------------
    %
    %
    %Construct matrix with a given sparsity and nonzeros.
    %
    %
    %> MX()
    %------------------------------------------------------------------------
    %
    %
    %Default constructor.
    %
    %
    %> MX(double x)
    %------------------------------------------------------------------------
    %
    %
    %Create scalar constant (also implicit type conversion)
    %
    %
    %> MX([double] x)
    %------------------------------------------------------------------------
    %
    %
    %Create vector constant (also implicit type conversion)
    %
    %
    %> MX(MX x)
    %------------------------------------------------------------------------
    %
    %
    %Copy constructor.
    %
    %
    %> MX(int nrow, int ncol)
    %------------------------------------------------------------------------
    %
    %
    %Create a sparse matrix with all structural zeros.
    %
    %
    %
      self@casadi.GenericExpressionCommon(SwigRef.Null);
      self@casadi.PrintableCommon(SwigRef.Null);
      self@casadi.GenMX(SwigRef.Null);
      self@casadi.SharedObject(SwigRef.Null);
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(695, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.SwigClear();
      end
    end
    function delete(self)
        if self.swigPtr
          casadiMEX(696, self);
          self.SwigClear();
        end
    end
    function varargout = nonzero(self,varargin)
    %NONZERO Returns the truth value of an MX expression.
    %
    %  bool = NONZERO(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(697, self, varargin{:});
    end
    function varargout = sparsity(self,varargin)
    %SPARSITY Get an owning reference to the sparsity pattern.
    %
    %  Sparsity = SPARSITY(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(698, self, varargin{:});
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
      [varargout{1:nargout}] = casadiMEX(699, self, varargin{:});
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
      [varargout{1:nargout}] = casadiMEX(700, self, varargin{:});
    end
    function varargout = uminus(self,varargin)
    %UMINUS 
    %
    %  MX = UMINUS(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(701, self, varargin{:});
    end
    function varargout = dep(self,varargin)
    %DEP Get the nth dependency as MX.
    %
    %  MX = DEP(self, int ch)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(702, self, varargin{:});
    end
    function varargout = n_out(self,varargin)
    %N_OUT Number of outputs.
    %
    %  int = N_OUT(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(703, self, varargin{:});
    end
    function varargout = get_output(self,varargin)
    %GET_OUTPUT Get an output.
    %
    %  MX = GET_OUTPUT(self, int oind)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(704, self, varargin{:});
    end
    function varargout = n_dep(self,varargin)
    %N_DEP Get the number of dependencies of a binary SXElem.
    %
    %  int = N_DEP(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(705, self, varargin{:});
    end
    function varargout = name(self,varargin)
    %NAME Get the name.
    %
    %  char = NAME(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(706, self, varargin{:});
    end
    function varargout = to_double(self,varargin)
    %TO_DOUBLE 
    %
    %  double = TO_DOUBLE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(707, self, varargin{:});
    end
    function varargout = to_DM(self,varargin)
    %TO_DM 
    %
    %  DM = TO_DM(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(708, self, varargin{:});
    end
    function varargout = is_symbolic(self,varargin)
    %IS_SYMBOLIC Check if symbolic.
    %
    %  bool = IS_SYMBOLIC(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(709, self, varargin{:});
    end
    function varargout = is_constant(self,varargin)
    %IS_CONSTANT Check if constant.
    %
    %  bool = IS_CONSTANT(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(710, self, varargin{:});
    end
    function varargout = is_call(self,varargin)
    %IS_CALL Check if evaluation.
    %
    %  bool = IS_CALL(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(711, self, varargin{:});
    end
    function varargout = which_function(self,varargin)
    %WHICH_FUNCTION Get function - only valid when is_call() is true.
    %
    %  Function = WHICH_FUNCTION(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(712, self, varargin{:});
    end
    function varargout = is_output(self,varargin)
    %IS_OUTPUT Check if evaluation output.
    %
    %  bool = IS_OUTPUT(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(713, self, varargin{:});
    end
    function varargout = which_output(self,varargin)
    %WHICH_OUTPUT Get the index of evaluation output - only valid when is_output() is true.
    %
    %  int = WHICH_OUTPUT(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(714, self, varargin{:});
    end
    function varargout = is_op(self,varargin)
    %IS_OP Is it a certain operation.
    %
    %  bool = IS_OP(self, int op)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(715, self, varargin{:});
    end
    function varargout = is_multiplication(self,varargin)
    %IS_MULTIPLICATION Check if multiplication.
    %
    %  bool = IS_MULTIPLICATION(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(716, self, varargin{:});
    end
    function varargout = is_commutative(self,varargin)
    %IS_COMMUTATIVE Check if commutative operation.
    %
    %  bool = IS_COMMUTATIVE(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(717, self, varargin{:});
    end
    function varargout = is_norm(self,varargin)
    %IS_NORM Check if norm.
    %
    %  bool = IS_NORM(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(718, self, varargin{:});
    end
    function varargout = is_valid_input(self,varargin)
    %IS_VALID_INPUT Check if matrix can be used to define function inputs. Valid inputs for
    %
    %  bool = IS_VALID_INPUT(self)
    %
    %MXFunctions are combinations of Reshape, concatenations and SymbolicMX.
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(719, self, varargin{:});
    end
    function varargout = n_primitives(self,varargin)
    %N_PRIMITIVES Get the number of primitives for MXFunction inputs/outputs.
    %
    %  int = N_PRIMITIVES(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(720, self, varargin{:});
    end
    function varargout = primitives(self,varargin)
    %PRIMITIVES Get primitives.
    %
    %  {MX} = PRIMITIVES(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(721, self, varargin{:});
    end
    function varargout = split_primitives(self,varargin)
    %SPLIT_PRIMITIVES Split up an expression along symbolic primitives.
    %
    %  {MX} = SPLIT_PRIMITIVES(self, MX x)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(722, self, varargin{:});
    end
    function varargout = join_primitives(self,varargin)
    %JOIN_PRIMITIVES Join an expression along symbolic primitives.
    %
    %  MX = JOIN_PRIMITIVES(self, {MX} v)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(723, self, varargin{:});
    end
    function varargout = has_duplicates(self,varargin)
    %HAS_DUPLICATES [INTERNAL]  Detect duplicate symbolic expressions If there are symbolic
    %
    %  bool = HAS_DUPLICATES(self)
    %
    %primitives appearing more than once, the function will return true and the
    %names of the duplicate expressions will be passed to casadi_warning. Note:
    %Will mark the node using MX::set_temp. Make sure to call reset_input() after
    %usage.
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(724, self, varargin{:});
    end
    function varargout = reset_input(self,varargin)
    %RESET_INPUT [INTERNAL]  Reset the marker for an input expression.
    %
    %  RESET_INPUT(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(725, self, varargin{:});
    end
    function varargout = is_eye(self,varargin)
    %IS_EYE check if identity
    %
    %  bool = IS_EYE(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(726, self, varargin{:});
    end
    function varargout = is_zero(self,varargin)
    %IS_ZERO check if zero (note that false negative answers are possible)
    %
    %  bool = IS_ZERO(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(727, self, varargin{:});
    end
    function varargout = is_one(self,varargin)
    %IS_ONE check if zero (note that false negative answers are possible)
    %
    %  bool = IS_ONE(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(728, self, varargin{:});
    end
    function varargout = is_minus_one(self,varargin)
    %IS_MINUS_ONE check if zero (note that false negative answers are possible)
    %
    %  bool = IS_MINUS_ONE(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(729, self, varargin{:});
    end
    function varargout = is_transpose(self,varargin)
    %IS_TRANSPOSE Is the expression a transpose?
    %
    %  bool = IS_TRANSPOSE(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(730, self, varargin{:});
    end
    function varargout = is_regular(self,varargin)
    %IS_REGULAR Checks if expression does not contain NaN or Inf.
    %
    %  bool = IS_REGULAR(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(731, self, varargin{:});
    end
    function varargout = is_binary(self,varargin)
    %IS_BINARY Is binary operation.
    %
    %  bool = IS_BINARY(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(732, self, varargin{:});
    end
    function varargout = is_unary(self,varargin)
    %IS_UNARY Is unary operation.
    %
    %  bool = IS_UNARY(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(733, self, varargin{:});
    end
    function varargout = op(self,varargin)
    %OP Get operation type.
    %
    %  int = OP(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(734, self, varargin{:});
    end
    function varargout = info(self,varargin)
    %INFO Obtain information about node
    %
    %  struct = INFO(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(735, self, varargin{:});
    end
    function varargout = get_temp(self,varargin)
    %GET_TEMP [INTERNAL]  Get the temporary variable
    %
    %  int = GET_TEMP(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(736, self, varargin{:});
    end
    function varargout = set_temp(self,varargin)
    %SET_TEMP [INTERNAL]  Set the temporary variable.
    %
    %  SET_TEMP(self, int t)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(737, self, varargin{:});
    end
    function varargout = get(self,varargin)
    %GET 
    %
    %  MX = GET(self, bool ind1, Sparsity sp)
    %    Get a submatrix, single argument
    %  MX = GET(self, bool ind1, Slice rr)
    %    Get a submatrix, single argument
    %  MX = GET(self, bool ind1, IM rr)
    %  MX = GET(self, bool ind1, Slice rr, Slice cc)
    %    Get a submatrix, two arguments
    %  MX = GET(self, bool ind1, Slice rr, IM cc)
    %  MX = GET(self, bool ind1, IM rr, Slice cc)
    %  MX = GET(self, bool ind1, IM rr, IM cc)
    %
    %> GET(self, bool ind1, IM rr)
    %> GET(self, bool ind1, Slice rr, IM cc)
    %> GET(self, bool ind1, IM rr, Slice cc)
    %> GET(self, bool ind1, IM rr, IM cc)
    %------------------------------------------------------------------------
    %
    %> GET(self, bool ind1, Sparsity sp)
    %> GET(self, bool ind1, Slice rr)
    %------------------------------------------------------------------------
    %
    %
    %Get a submatrix, single argument
    %
    %
    %> GET(self, bool ind1, Slice rr, Slice cc)
    %------------------------------------------------------------------------
    %
    %
    %Get a submatrix, two arguments
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(743, self, varargin{:});
    end
    function varargout = set(self,varargin)
    %SET 
    %
    %  SET(self, MX m, bool ind1, Sparsity sp)
    %    Set a submatrix, single argument
    %  SET(self, MX m, bool ind1, Slice rr)
    %    Set a submatrix, single argument
    %  SET(self, MX m, bool ind1, IM rr)
    %  SET(self, MX m, bool ind1, Slice rr, Slice cc)
    %  SET(self, MX m, bool ind1, Slice rr, IM cc)
    %  SET(self, MX m, bool ind1, IM rr, Slice cc)
    %  SET(self, MX m, bool ind1, IM rr, IM cc)
    %
    %> SET(self, MX m, bool ind1, IM rr)
    %> SET(self, MX m, bool ind1, Slice rr, Slice cc)
    %> SET(self, MX m, bool ind1, Slice rr, IM cc)
    %> SET(self, MX m, bool ind1, IM rr, Slice cc)
    %> SET(self, MX m, bool ind1, IM rr, IM cc)
    %------------------------------------------------------------------------
    %
    %> SET(self, MX m, bool ind1, Sparsity sp)
    %> SET(self, MX m, bool ind1, Slice rr)
    %------------------------------------------------------------------------
    %
    %
    %Set a submatrix, single argument
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(744, self, varargin{:});
    end
    function varargout = get_nz(self,varargin)
    %GET_NZ 
    %
    %  MX = GET_NZ(self, bool ind1, Slice kk)
    %    Get a set of nonzeros
    %  MX = GET_NZ(self, bool ind1, IM kk)
    %
    %> GET_NZ(self, bool ind1, IM kk)
    %------------------------------------------------------------------------
    %
    %> GET_NZ(self, bool ind1, Slice kk)
    %------------------------------------------------------------------------
    %
    %
    %Get a set of nonzeros
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(745, self, varargin{:});
    end
    function varargout = set_nz(self,varargin)
    %SET_NZ 
    %
    %  SET_NZ(self, MX m, bool ind1, Slice kk)
    %    Set a set of nonzeros
    %  SET_NZ(self, MX m, bool ind1, IM kk)
    %
    %> SET_NZ(self, MX m, bool ind1, IM kk)
    %------------------------------------------------------------------------
    %
    %> SET_NZ(self, MX m, bool ind1, Slice kk)
    %------------------------------------------------------------------------
    %
    %
    %Set a set of nonzeros
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(746, self, varargin{:});
    end
    function varargout = printme(self,varargin)
    %PRINTME 
    %
    %  MX = PRINTME(self, MX y)
    %
    %
      [varargout{1:nargout}] = casadiMEX(748, self, varargin{:});
    end
    function varargout = attachAssert(self,varargin)
    %ATTACHASSERT returns itself, but with an assertion attached
    %
    %  MX = ATTACHASSERT(self, MX y, char fail_message)
    %
    %
    %If y does not evaluate to 1, a runtime error is raised
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(749, self, varargin{:});
    end
    function varargout = monitor(self,varargin)
    %MONITOR Monitor an expression Returns itself, but with the side effect of printing
    %
    %  MX = MONITOR(self, char comment)
    %
    %the nonzeros along with a comment.
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(750, self, varargin{:});
    end
    function varargout = T(self,varargin)
    %T Transpose the matrix.
    %
    %  MX = T(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(751, self, varargin{:});
    end
    function varargout = mapping(self,varargin)
    %MAPPING Get an IM representation of a GetNonzeros or SetNonzeros node.
    %
    %  IM = MAPPING(self)
    %
    %
    %
    %
      [varargout{1:nargout}] = casadiMEX(752, self, varargin{:});
    end
    function varargout = paren(self,varargin)
    %PAREN 
    %
    %  MX = PAREN(self, Sparsity sp)
    %  MX = PAREN(self, IM rr)
    %  MX = PAREN(self, char rr)
    %  MX = PAREN(self, IM rr, IM cc)
    %  MX = PAREN(self, IM rr, char cc)
    %  MX = PAREN(self, char rr, IM cc)
    %  MX = PAREN(self, char rr, char cc)
    %
    %
      [varargout{1:nargout}] = casadiMEX(758, self, varargin{:});
    end
    function varargout = paren_asgn(self,varargin)
    %PAREN_ASGN 
    %
    %  PAREN_ASGN(self, MX m, Sparsity sp)
    %  PAREN_ASGN(self, MX m, IM rr)
    %  PAREN_ASGN(self, MX m, char rr)
    %  PAREN_ASGN(self, MX m, IM rr, IM cc)
    %  PAREN_ASGN(self, MX m, IM rr, char cc)
    %  PAREN_ASGN(self, MX m, char rr, IM cc)
    %  PAREN_ASGN(self, MX m, char rr, char cc)
    %
    %
      [varargout{1:nargout}] = casadiMEX(759, self, varargin{:});
    end
    function varargout = brace(self,varargin)
    %BRACE 
    %
    %  MX = BRACE(self, IM rr)
    %  MX = BRACE(self, char rr)
    %
    %
      [varargout{1:nargout}] = casadiMEX(760, self, varargin{:});
    end
    function varargout = setbrace(self,varargin)
    %SETBRACE 
    %
    %  SETBRACE(self, MX m, IM rr)
    %  SETBRACE(self, MX m, char rr)
    %
    %
      [varargout{1:nargout}] = casadiMEX(761, self, varargin{:});
    end
    function varargout = end(self,varargin)
    %END 
    %
    %  int = END(self, int i, int n)
    %
    %
      [varargout{1:nargout}] = casadiMEX(762, self, varargin{:});
    end
    function varargout = numel(self,varargin)
    %NUMEL Get the number of elements.
    %
    %  int = NUMEL(self)
    %  int = NUMEL(self, int k)
    %    
    %  int = NUMEL(self, [int] k)
    %    
    %  int = NUMEL(self, char rr)
    %    
    %
    %
    %
    %> NUMEL(self)
    %------------------------------------------------------------------------
    %
    %
    %Get the number of elements.
    %
    %
    %> NUMEL(self, int k)
    %> NUMEL(self, [int] k)
    %> NUMEL(self, char rr)
    %------------------------------------------------------------------------
    %
    %
      [varargout{1:nargout}] = casadiMEX(763, self, varargin{:});
    end
    function varargout = ctranspose(self,varargin)
    %CTRANSPOSE 
    %
    %  MX = CTRANSPOSE(self)
    %
    %
      [varargout{1:nargout}] = casadiMEX(764, self, varargin{:});
    end
    function varargout = find(varargin)
    %FIND Find first nonzero If failed, returns the number of rows.
    %
    %  MX = FIND(MX x)
    %
    %
    %
    %
     [varargout{1:nargout}] = casadiMEX(765, varargin{:});
    end
    function varargout = inv_node(varargin)
    %INV_NODE Inverse node.
    %
    %  MX = INV_NODE(MX x)
    %
    %
    %
    %
     [varargout{1:nargout}] = casadiMEX(766, varargin{:});
    end
  end
  methods(Static)
    function varargout = type_name(varargin)
    %TYPE_NAME 
    %
    %  char = TYPE_NAME()
    %
    %
     [varargout{1:nargout}] = casadiMEX(694, varargin{:});
    end
    function varargout = binary(varargin)
    %BINARY Create nodes by their ID.
    %
    %  MX = BINARY(int op, MX x, MX y)
    %
    %
    %
    %
     [varargout{1:nargout}] = casadiMEX(738, varargin{:});
    end
    function varargout = unary(varargin)
    %UNARY Create nodes by their ID.
    %
    %  MX = UNARY(int op, MX x)
    %
    %
    %
    %
     [varargout{1:nargout}] = casadiMEX(739, varargin{:});
    end
    function varargout = inf(varargin)
    %INF create a matrix with all inf
    %
    %  MX = INF(int nrow, int ncol)
    %  MX = INF([int,int] rc)
    %  MX = INF(Sparsity sp)
    %
    %
    %
    %
     [varargout{1:nargout}] = casadiMEX(740, varargin{:});
    end
    function varargout = nan(varargin)
    %NAN create a matrix with all nan
    %
    %  MX = NAN(int nrow, int ncol)
    %  MX = NAN([int,int] rc)
    %  MX = NAN(Sparsity sp)
    %
    %
    %
    %
     [varargout{1:nargout}] = casadiMEX(741, varargin{:});
    end
    function varargout = eye(varargin)
    %EYE 
    %
    %  MX = EYE(int ncol)
    %
    %
     [varargout{1:nargout}] = casadiMEX(742, varargin{:});
    end
    function varargout = einstein(varargin)
    %EINSTEIN Computes an einstein dense tensor contraction.
    %
    %  MX = EINSTEIN(MX A, MX B, [int] dim_a, [int] dim_b, [int] dim_c, [int] a, [int] b, [int] c)
    %  MX = EINSTEIN(MX A, MX B, MX C, [int] dim_a, [int] dim_b, [int] dim_c, [int] a, [int] b, [int] c)
    %
    %
    %Computes the product: C_c = A_a + B_b where a b c are index/einstein
    %notation in an encoded form
    %
    %For example, an matrix-matrix product may be written as: C_ij = A_ik B_kj
    %
    %The encoded form uses strictly negative numbers to indicate labels. For the
    %above example, we would have: a {-1, -3} b {-3, -2} c {-1 -2}
    %
    %
    %
     [varargout{1:nargout}] = casadiMEX(747, varargin{:});
    end
    function varargout = set_max_depth(varargin)
    %SET_MAX_DEPTH 
    %
    %  SET_MAX_DEPTH(int eq_depth)
    %
    %
     [varargout{1:nargout}] = casadiMEX(753, varargin{:});
    end
    function varargout = get_max_depth(varargin)
    %GET_MAX_DEPTH 
    %
    %  int = GET_MAX_DEPTH()
    %
    %
     [varargout{1:nargout}] = casadiMEX(754, varargin{:});
    end
    function varargout = test_cast(varargin)
    %TEST_CAST 
    %
    %  bool = TEST_CAST(casadi::SharedObjectInternal const * ptr)
    %
    %
     [varargout{1:nargout}] = casadiMEX(755, varargin{:});
    end
    function varargout = get_input(varargin)
    %GET_INPUT 
    %
    %  {MX} = GET_INPUT(Function f)
    %
    %
     [varargout{1:nargout}] = casadiMEX(756, varargin{:});
    end
    function varargout = get_free(varargin)
    %GET_FREE 
    %
    %  {MX} = GET_FREE(Function f)
    %
    %
     [varargout{1:nargout}] = casadiMEX(757, varargin{:});
    end
  end
end
