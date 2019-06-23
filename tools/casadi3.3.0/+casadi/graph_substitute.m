function varargout = graph_substitute(varargin)
    %GRAPH_SUBSTITUTE 
    %
    %  MX = GRAPH_SUBSTITUTE(MX ex, {MX} v, {MX} vdef)
    %  {MX} = GRAPH_SUBSTITUTE({MX} ex, {MX} v, {MX} vdef)
    %
    %
  [varargout{1:nargout}] = casadiMEX(925, varargin{:});
end
