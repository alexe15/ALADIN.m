function varargout = matrix_expand(varargin)
    %MATRIX_EXPAND 
    %
    %  MX = MATRIX_EXPAND(MX e, {MX} boundary, struct options)
    %  {MX} = MATRIX_EXPAND({MX} e, {MX} boundary, struct options)
    %
    %
  [varargout{1:nargout}] = casadiMEX(924, varargin{:});
end
