function varargout = collocation_points(varargin)
    %COLLOCATION_POINTS Obtain collocation points of specific order and scheme.
    %
    %  [double] = COLLOCATION_POINTS(int order, char scheme)
    %
    %
    %Parameters:
    %-----------
    %
    %scheme:  'radau' or 'legendre'
    %
    %
    %
  [varargout{1:nargout}] = casadiMEX(998, varargin{:});
end
