function varargout = substitute(varargin)
    %SUBSTITUTE 
    %
    %  IM = SUBSTITUTE(IM ex, IM v, IM vdef)
    %  {IM} = SUBSTITUTE({IM} ex, {IM} v, {IM} vdef)
    %  DM = SUBSTITUTE(DM ex, DM v, DM vdef)
    %  {DM} = SUBSTITUTE({DM} ex, {DM} v, {DM} vdef)
    %  SX = SUBSTITUTE(SX ex, SX v, SX vdef)
    %  {SX} = SUBSTITUTE({SX} ex, {SX} v, {SX} vdef)
    %  MX = SUBSTITUTE(MX ex, MX v, MX vdef)
    %  {MX} = SUBSTITUTE({MX} ex, {MX} v, {MX} vdef)
    %
    %
  [varargout{1:nargout}] = casadiMEX(921, varargin{:});
end
