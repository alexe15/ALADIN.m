function varargout = dple_out(varargin)
    %DPLE_OUT Get DPLE output scheme name by index.
    %
    %  {char} = DPLE_OUT()
    %    Get output scheme of DPLE solvers.
    %  char = DPLE_OUT(int ind)
    %
    %
    %
    %> DPLE_OUT()
    %------------------------------------------------------------------------
    %
    %
    %Get output scheme of DPLE solvers.
    %
    %
    %> DPLE_OUT(int ind)
    %------------------------------------------------------------------------
    %
    %
    %Get DPLE output scheme name by index.
    %
    %
    %
  [varargout{1:nargout}] = casadiMEX(921, varargin{:});
end
