function varargout = blockcat(varargin)
    %BLOCKCAT 
    %
    %  IM = BLOCKCAT({{IM}} v)
    %  DM = BLOCKCAT({{DM}} v)
    %  SX = BLOCKCAT({{SX}} v)
    %  MX = BLOCKCAT({{MX}} v)
    %
    %
  [varargout{1:nargout}] = casadiMEX(948, varargin{:});
end
