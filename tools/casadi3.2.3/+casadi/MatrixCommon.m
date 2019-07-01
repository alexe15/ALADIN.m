classdef  MatrixCommon < SwigRef
    %MATRIXCOMMON 
    %
    %   = MATRIXCOMMON()
    %
    %
  methods
    function this = swig_this(self)
      this = casadiMEX(3, self);
    end
    function varargout = all(varargin)
    %ALL 
    %
    %  IM = ALL(IM x)
    %  DM = ALL(DM x)
    %  SX = ALL(SX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(421, varargin{:});
    end
    function varargout = any(varargin)
    %ANY 
    %
    %  IM = ANY(IM x)
    %  DM = ANY(DM x)
    %  SX = ANY(SX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(422, varargin{:});
    end
    function varargout = adj(varargin)
    %ADJ 
    %
    %  IM = ADJ(IM A)
    %  DM = ADJ(DM A)
    %  SX = ADJ(SX A)
    %
    %
     [varargout{1:nargout}] = casadiMEX(423, varargin{:});
    end
    function varargout = getMinor(varargin)
    %GETMINOR 
    %
    %  IM = GETMINOR(IM x, int i, int j)
    %  DM = GETMINOR(DM x, int i, int j)
    %  SX = GETMINOR(SX x, int i, int j)
    %
    %
     [varargout{1:nargout}] = casadiMEX(424, varargin{:});
    end
    function varargout = cofactor(varargin)
    %COFACTOR 
    %
    %  IM = COFACTOR(IM x, int i, int j)
    %  DM = COFACTOR(DM x, int i, int j)
    %  SX = COFACTOR(SX x, int i, int j)
    %
    %
     [varargout{1:nargout}] = casadiMEX(425, varargin{:});
    end
    function varargout = qr(varargin)
    %QR 
    %
    %  [IM OUTPUT1, IM OUTPUT2] = QR(IM A)
    %  [DM OUTPUT1, DM OUTPUT2] = QR(DM A)
    %  [SX OUTPUT1, SX OUTPUT2] = QR(SX A)
    %
    %
     [varargout{1:nargout}] = casadiMEX(426, varargin{:});
    end
    function varargout = chol(varargin)
    %CHOL 
    %
    %  IM = CHOL(IM A)
    %  DM = CHOL(DM A)
    %  SX = CHOL(SX A)
    %
    %
     [varargout{1:nargout}] = casadiMEX(427, varargin{:});
    end
    function varargout = norm_inf_mul(varargin)
    %NORM_INF_MUL 
    %
    %  IM = NORM_INF_MUL(IM x, IM y)
    %  DM = NORM_INF_MUL(DM x, DM y)
    %  SX = NORM_INF_MUL(SX x, SX y)
    %
    %
     [varargout{1:nargout}] = casadiMEX(428, varargin{:});
    end
    function varargout = sparsify(varargin)
    %SPARSIFY 
    %
    %  IM = SPARSIFY(IM A, double tol)
    %  DM = SPARSIFY(DM A, double tol)
    %  SX = SPARSIFY(SX A, double tol)
    %
    %
     [varargout{1:nargout}] = casadiMEX(429, varargin{:});
    end
    function varargout = expand(varargin)
    %EXPAND 
    %
    %  [IM OUTPUT1, IM OUTPUT2] = EXPAND(IM ex)
    %  [DM OUTPUT1, DM OUTPUT2] = EXPAND(DM ex)
    %  [SX OUTPUT1, SX OUTPUT2] = EXPAND(SX ex)
    %
    %
     [varargout{1:nargout}] = casadiMEX(430, varargin{:});
    end
    function varargout = pw_const(varargin)
    %PW_CONST 
    %
    %  IM = PW_CONST(IM t, IM tval, IM val)
    %  DM = PW_CONST(DM t, DM tval, DM val)
    %  SX = PW_CONST(SX t, SX tval, SX val)
    %
    %
     [varargout{1:nargout}] = casadiMEX(431, varargin{:});
    end
    function varargout = pw_lin(varargin)
    %PW_LIN 
    %
    %  IM = PW_LIN(IM t, IM tval, IM val)
    %  DM = PW_LIN(DM t, DM tval, DM val)
    %  SX = PW_LIN(SX t, SX tval, SX val)
    %
    %
     [varargout{1:nargout}] = casadiMEX(432, varargin{:});
    end
    function varargout = heaviside(varargin)
    %HEAVISIDE 
    %
    %  IM = HEAVISIDE(IM x)
    %  DM = HEAVISIDE(DM x)
    %  SX = HEAVISIDE(SX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(433, varargin{:});
    end
    function varargout = rectangle(varargin)
    %RECTANGLE 
    %
    %  IM = RECTANGLE(IM x)
    %  DM = RECTANGLE(DM x)
    %  SX = RECTANGLE(SX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(434, varargin{:});
    end
    function varargout = triangle(varargin)
    %TRIANGLE 
    %
    %  IM = TRIANGLE(IM x)
    %  DM = TRIANGLE(DM x)
    %  SX = TRIANGLE(SX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(435, varargin{:});
    end
    function varargout = ramp(varargin)
    %RAMP 
    %
    %  IM = RAMP(IM x)
    %  DM = RAMP(DM x)
    %  SX = RAMP(SX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(436, varargin{:});
    end
    function varargout = gauss_quadrature(varargin)
    %GAUSS_QUADRATURE 
    %
    %  IM = GAUSS_QUADRATURE(IM f, IM x, IM a, IM b, int order)
    %  DM = GAUSS_QUADRATURE(DM f, DM x, DM a, DM b, int order)
    %  SX = GAUSS_QUADRATURE(SX f, SX x, SX a, SX b, int order)
    %  IM = GAUSS_QUADRATURE(IM f, IM x, IM a, IM b, int order, IM w)
    %  DM = GAUSS_QUADRATURE(DM f, DM x, DM a, DM b, int order, DM w)
    %  SX = GAUSS_QUADRATURE(SX f, SX x, SX a, SX b, int order, SX w)
    %
    %
     [varargout{1:nargout}] = casadiMEX(437, varargin{:});
    end
    function varargout = taylor(varargin)
    %TAYLOR 
    %
    %  IM = TAYLOR(IM ex, IM x, IM a, int order)
    %  DM = TAYLOR(DM ex, DM x, DM a, int order)
    %  SX = TAYLOR(SX ex, SX x, SX a, int order)
    %
    %
     [varargout{1:nargout}] = casadiMEX(438, varargin{:});
    end
    function varargout = mtaylor(varargin)
    %MTAYLOR 
    %
    %  IM = MTAYLOR(IM ex, IM x, IM a, int order)
    %  DM = MTAYLOR(DM ex, DM x, DM a, int order)
    %  SX = MTAYLOR(SX ex, SX x, SX a, int order)
    %  IM = MTAYLOR(IM ex, IM x, IM a, int order, [int] order_contributions)
    %  DM = MTAYLOR(DM ex, DM x, DM a, int order, [int] order_contributions)
    %  SX = MTAYLOR(SX ex, SX x, SX a, int order, [int] order_contributions)
    %
    %
     [varargout{1:nargout}] = casadiMEX(439, varargin{:});
    end
    function varargout = poly_coeff(varargin)
    %POLY_COEFF 
    %
    %  IM = POLY_COEFF(IM ex, IM x)
    %  DM = POLY_COEFF(DM ex, DM x)
    %  SX = POLY_COEFF(SX ex, SX x)
    %
    %
     [varargout{1:nargout}] = casadiMEX(440, varargin{:});
    end
    function varargout = poly_roots(varargin)
    %POLY_ROOTS 
    %
    %  IM = POLY_ROOTS(IM p)
    %  DM = POLY_ROOTS(DM p)
    %  SX = POLY_ROOTS(SX p)
    %
    %
     [varargout{1:nargout}] = casadiMEX(441, varargin{:});
    end
    function varargout = eig_symbolic(varargin)
    %EIG_SYMBOLIC 
    %
    %  IM = EIG_SYMBOLIC(IM m)
    %  DM = EIG_SYMBOLIC(DM m)
    %  SX = EIG_SYMBOLIC(SX m)
    %
    %
     [varargout{1:nargout}] = casadiMEX(442, varargin{:});
    end
    function self = MatrixCommon(varargin)
    %MATRIXCOMMON 
    %
    %  new_obj = MATRIXCOMMON()
    %
    %
      if nargin==1 && strcmp(class(varargin{1}),'SwigRef')
        if ~isnull(varargin{1})
          self.swigPtr = varargin{1}.swigPtr;
        end
      else
        tmp = casadiMEX(443, varargin{:});
        self.swigPtr = tmp.swigPtr;
        tmp.swigPtr = [];
      end
    end
    function delete(self)
      if self.swigPtr
        casadiMEX(444, self);
        self.swigPtr=[];
      end
    end
  end
  methods(Static)
  end
end
