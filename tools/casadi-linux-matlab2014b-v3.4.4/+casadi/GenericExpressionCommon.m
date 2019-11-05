classdef  GenericExpressionCommon < SwigRef
    %GENERICEXPRESSIONCOMMON 
    %
    %   = GENERICEXPRESSIONCOMMON()
    %
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function varargout = plus(varargin)
    %PLUS 
    %
    %  double = PLUS(double x, double y)
    %  IM = PLUS(IM x, IM y)
    %  DM = PLUS(DM x, DM y)
    %  SX = PLUS(SX x, SX y)
    %  MX = PLUS(MX x, MX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(363, varargin{:});
    end
    function varargout = minus(varargin)
    %MINUS 
    %
    %  double = MINUS(double x, double y)
    %  IM = MINUS(IM x, IM y)
    %  DM = MINUS(DM x, DM y)
    %  SX = MINUS(SX x, SX y)
    %  MX = MINUS(MX x, MX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(364, varargin{:});
    end
    function varargout = times(varargin)
    %TIMES 
    %
    %  double = TIMES(double x, double y)
    %  IM = TIMES(IM x, IM y)
    %  DM = TIMES(DM x, DM y)
    %  SX = TIMES(SX x, SX y)
    %  MX = TIMES(MX x, MX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(365, varargin{:});
    end
    function varargout = rdivide(varargin)
    %RDIVIDE 
    %
    %  double = RDIVIDE(double x, double y)
    %  IM = RDIVIDE(IM x, IM y)
    %  DM = RDIVIDE(DM x, DM y)
    %  SX = RDIVIDE(SX x, SX y)
    %  MX = RDIVIDE(MX x, MX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(366, varargin{:});
    end
    function varargout = ldivide(varargin)
    %LDIVIDE 
    %
    %  double = LDIVIDE(double x, double y)
    %  IM = LDIVIDE(IM x, IM y)
    %  DM = LDIVIDE(DM x, DM y)
    %  SX = LDIVIDE(SX x, SX y)
    %  MX = LDIVIDE(MX x, MX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(367, varargin{:});
    end
    function varargout = lt(varargin)
    %LT 
    %
    %  double = LT(double x, double y)
    %  IM = LT(IM x, IM y)
    %  DM = LT(DM x, DM y)
    %  SX = LT(SX x, SX y)
    %  MX = LT(MX x, MX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(368, varargin{:});
    end
    function varargout = le(varargin)
    %LE 
    %
    %  double = LE(double x, double y)
    %  IM = LE(IM x, IM y)
    %  DM = LE(DM x, DM y)
    %  SX = LE(SX x, SX y)
    %  MX = LE(MX x, MX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(369, varargin{:});
    end
    function varargout = gt(varargin)
    %GT 
    %
    %  double = GT(double x, double y)
    %  IM = GT(IM x, IM y)
    %  DM = GT(DM x, DM y)
    %  SX = GT(SX x, SX y)
    %  MX = GT(MX x, MX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(370, varargin{:});
    end
    function varargout = ge(varargin)
    %GE 
    %
    %  double = GE(double x, double y)
    %  IM = GE(IM x, IM y)
    %  DM = GE(DM x, DM y)
    %  SX = GE(SX x, SX y)
    %  MX = GE(MX x, MX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(371, varargin{:});
    end
    function varargout = eq(varargin)
    %EQ 
    %
    %  double = EQ(double x, double y)
    %  IM = EQ(IM x, IM y)
    %  DM = EQ(DM x, DM y)
    %  SX = EQ(SX x, SX y)
    %  MX = EQ(MX x, MX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(372, varargin{:});
    end
    function varargout = ne(varargin)
    %NE 
    %
    %  double = NE(double x, double y)
    %  IM = NE(IM x, IM y)
    %  DM = NE(DM x, DM y)
    %  SX = NE(SX x, SX y)
    %  MX = NE(MX x, MX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(373, varargin{:});
    end
    function varargout = and(varargin)
    %AND 
    %
    %  double = AND(double x, double y)
    %  IM = AND(IM x, IM y)
    %  DM = AND(DM x, DM y)
    %  SX = AND(SX x, SX y)
    %  MX = AND(MX x, MX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(374, varargin{:});
    end
    function varargout = or(varargin)
    %OR 
    %
    %  double = OR(double x, double y)
    %  IM = OR(IM x, IM y)
    %  DM = OR(DM x, DM y)
    %  SX = OR(SX x, SX y)
    %  MX = OR(MX x, MX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(375, varargin{:});
    end
    function varargout = not(varargin)
    %NOT 
    %
    %  double = NOT(double x)
    %  IM = NOT(IM x)
    %  DM = NOT(DM x)
    %  SX = NOT(SX x)
    %  MX = NOT(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(376, varargin{:});
    end
    function varargout = abs(varargin)
    %ABS 
    %
    %  double = ABS(double x)
    %  IM = ABS(IM x)
    %  DM = ABS(DM x)
    %  SX = ABS(SX x)
    %  MX = ABS(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(377, varargin{:});
    end
    function varargout = sqrt(varargin)
    %SQRT 
    %
    %  double = SQRT(double x)
    %  IM = SQRT(IM x)
    %  DM = SQRT(DM x)
    %  SX = SQRT(SX x)
    %  MX = SQRT(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(378, varargin{:});
    end
    function varargout = sin(varargin)
    %SIN 
    %
    %  double = SIN(double x)
    %  IM = SIN(IM x)
    %  DM = SIN(DM x)
    %  SX = SIN(SX x)
    %  MX = SIN(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(379, varargin{:});
    end
    function varargout = cos(varargin)
    %COS 
    %
    %  double = COS(double x)
    %  IM = COS(IM x)
    %  DM = COS(DM x)
    %  SX = COS(SX x)
    %  MX = COS(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(380, varargin{:});
    end
    function varargout = tan(varargin)
    %TAN 
    %
    %  double = TAN(double x)
    %  IM = TAN(IM x)
    %  DM = TAN(DM x)
    %  SX = TAN(SX x)
    %  MX = TAN(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(381, varargin{:});
    end
    function varargout = atan(varargin)
    %ATAN 
    %
    %  double = ATAN(double x)
    %  IM = ATAN(IM x)
    %  DM = ATAN(DM x)
    %  SX = ATAN(SX x)
    %  MX = ATAN(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(382, varargin{:});
    end
    function varargout = asin(varargin)
    %ASIN 
    %
    %  double = ASIN(double x)
    %  IM = ASIN(IM x)
    %  DM = ASIN(DM x)
    %  SX = ASIN(SX x)
    %  MX = ASIN(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(383, varargin{:});
    end
    function varargout = acos(varargin)
    %ACOS 
    %
    %  double = ACOS(double x)
    %  IM = ACOS(IM x)
    %  DM = ACOS(DM x)
    %  SX = ACOS(SX x)
    %  MX = ACOS(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(384, varargin{:});
    end
    function varargout = tanh(varargin)
    %TANH 
    %
    %  double = TANH(double x)
    %  IM = TANH(IM x)
    %  DM = TANH(DM x)
    %  SX = TANH(SX x)
    %  MX = TANH(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(385, varargin{:});
    end
    function varargout = sinh(varargin)
    %SINH 
    %
    %  double = SINH(double x)
    %  IM = SINH(IM x)
    %  DM = SINH(DM x)
    %  SX = SINH(SX x)
    %  MX = SINH(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(386, varargin{:});
    end
    function varargout = cosh(varargin)
    %COSH 
    %
    %  double = COSH(double x)
    %  IM = COSH(IM x)
    %  DM = COSH(DM x)
    %  SX = COSH(SX x)
    %  MX = COSH(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(387, varargin{:});
    end
    function varargout = atanh(varargin)
    %ATANH 
    %
    %  double = ATANH(double x)
    %  IM = ATANH(IM x)
    %  DM = ATANH(DM x)
    %  SX = ATANH(SX x)
    %  MX = ATANH(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(388, varargin{:});
    end
    function varargout = asinh(varargin)
    %ASINH 
    %
    %  double = ASINH(double x)
    %  IM = ASINH(IM x)
    %  DM = ASINH(DM x)
    %  SX = ASINH(SX x)
    %  MX = ASINH(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(389, varargin{:});
    end
    function varargout = acosh(varargin)
    %ACOSH 
    %
    %  double = ACOSH(double x)
    %  IM = ACOSH(IM x)
    %  DM = ACOSH(DM x)
    %  SX = ACOSH(SX x)
    %  MX = ACOSH(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(390, varargin{:});
    end
    function varargout = exp(varargin)
    %EXP 
    %
    %  double = EXP(double x)
    %  IM = EXP(IM x)
    %  DM = EXP(DM x)
    %  SX = EXP(SX x)
    %  MX = EXP(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(391, varargin{:});
    end
    function varargout = log(varargin)
    %LOG 
    %
    %  double = LOG(double x)
    %  IM = LOG(IM x)
    %  DM = LOG(DM x)
    %  SX = LOG(SX x)
    %  MX = LOG(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(392, varargin{:});
    end
    function varargout = log10(varargin)
    %LOG10 
    %
    %  double = LOG10(double x)
    %  IM = LOG10(IM x)
    %  DM = LOG10(DM x)
    %  SX = LOG10(SX x)
    %  MX = LOG10(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(393, varargin{:});
    end
    function varargout = floor(varargin)
    %FLOOR 
    %
    %  double = FLOOR(double x)
    %  IM = FLOOR(IM x)
    %  DM = FLOOR(DM x)
    %  SX = FLOOR(SX x)
    %  MX = FLOOR(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(394, varargin{:});
    end
    function varargout = ceil(varargin)
    %CEIL 
    %
    %  double = CEIL(double x)
    %  IM = CEIL(IM x)
    %  DM = CEIL(DM x)
    %  SX = CEIL(SX x)
    %  MX = CEIL(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(395, varargin{:});
    end
    function varargout = erf(varargin)
    %ERF 
    %
    %  double = ERF(double x)
    %  IM = ERF(IM x)
    %  DM = ERF(DM x)
    %  SX = ERF(SX x)
    %  MX = ERF(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(396, varargin{:});
    end
    function varargout = erfinv(varargin)
    %ERFINV 
    %
    %  double = ERFINV(double x)
    %  IM = ERFINV(IM x)
    %  DM = ERFINV(DM x)
    %  SX = ERFINV(SX x)
    %  MX = ERFINV(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(397, varargin{:});
    end
    function varargout = sign(varargin)
    %SIGN 
    %
    %  double = SIGN(double x)
    %  IM = SIGN(IM x)
    %  DM = SIGN(DM x)
    %  SX = SIGN(SX x)
    %  MX = SIGN(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(398, varargin{:});
    end
    function varargout = power(varargin)
    %POWER 
    %
    %  double = POWER(double x, double n)
    %  IM = POWER(IM x, IM n)
    %  DM = POWER(DM x, DM n)
    %  SX = POWER(SX x, SX n)
    %  MX = POWER(MX x, MX n)
    %
    %
     [varargout{1:nargout}] = casadiMEX(399, varargin{:});
    end
    function varargout = mod(varargin)
    %MOD 
    %
    %  double = MOD(double x, double y)
    %  IM = MOD(IM x, IM y)
    %  DM = MOD(DM x, DM y)
    %  SX = MOD(SX x, SX y)
    %  MX = MOD(MX x, MX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(400, varargin{:});
    end
    function varargout = atan2(varargin)
    %ATAN2 
    %
    %  double = ATAN2(double x, double y)
    %  IM = ATAN2(IM x, IM y)
    %  DM = ATAN2(DM x, DM y)
    %  SX = ATAN2(SX x, SX y)
    %  MX = ATAN2(MX x, MX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(401, varargin{:});
    end
    function varargout = fmin(varargin)
    %FMIN 
    %
    %  double = FMIN(double x, double y)
    %  IM = FMIN(IM x, IM y)
    %  DM = FMIN(DM x, DM y)
    %  SX = FMIN(SX x, SX y)
    %  MX = FMIN(MX x, MX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(402, varargin{:});
    end
    function varargout = fmax(varargin)
    %FMAX 
    %
    %  double = FMAX(double x, double y)
    %  IM = FMAX(IM x, IM y)
    %  DM = FMAX(DM x, DM y)
    %  SX = FMAX(SX x, SX y)
    %  MX = FMAX(MX x, MX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(403, varargin{:});
    end
    function varargout = simplify(varargin)
    %SIMPLIFY 
    %
    %  double = SIMPLIFY(double x)
    %  IM = SIMPLIFY(IM x)
    %  DM = SIMPLIFY(DM x)
    %  SX = SIMPLIFY(SX x)
    %  MX = SIMPLIFY(MX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(404, varargin{:});
    end
    function varargout = is_equal(varargin)
    %IS_EQUAL 
    %
    %  bool = IS_EQUAL(double x, double y, int depth)
    %  bool = IS_EQUAL(IM x, IM y, int depth)
    %  bool = IS_EQUAL(DM x, DM y, int depth)
    %  bool = IS_EQUAL(SX x, SX y, int depth)
    %  bool = IS_EQUAL(MX x, MX y, int depth)
    %
    %
     [varargout{1:nargout}] = casadiMEX(405, varargin{:});
    end
    function varargout = copysign(varargin)
    %COPYSIGN 
    %
    %  double = COPYSIGN(double x, double y)
    %  IM = COPYSIGN(IM x, IM y)
    %  DM = COPYSIGN(DM x, DM y)
    %  SX = COPYSIGN(SX x, SX y)
    %  MX = COPYSIGN(MX x, MX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(406, varargin{:});
    end
    function varargout = constpow(varargin)
    %CONSTPOW 
    %
    %  double = CONSTPOW(double x, double y)
    %  IM = CONSTPOW(IM x, IM y)
    %  DM = CONSTPOW(DM x, DM y)
    %  SX = CONSTPOW(SX x, SX y)
    %  MX = CONSTPOW(MX x, MX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(407, varargin{:});
    end
    function self = GenericExpressionCommon(varargin)
    %GENERICEXPRESSIONCOMMON 
    %
    %  new_obj = GENERICEXPRESSIONCOMMON()
    %
    %
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(408, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.SwigClear();
      end
    end
    function delete(self)
        if self.swigPtr
          casadiMEX(409, self);
          self.SwigClear();
        end
    end
  end
  methods(Static)
  end
end
