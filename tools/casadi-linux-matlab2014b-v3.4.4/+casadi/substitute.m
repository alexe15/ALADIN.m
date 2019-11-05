function varargout = substitute(varargin)
    %SUBSTITUTE Substitute variable var with expression expr in multiple expressions.
    %
    %  IM = SUBSTITUTE(IM ex, IM v, IM vdef)
    %  std::vector< casadi::Matrix< casadi_int >,std::allocator< casadi::Matrix< casadi_int > > > = SUBSTITUTE({IM} ex, {IM} v, {IM} vdef)
    %  DM = SUBSTITUTE(DM ex, DM v, DM vdef)
    %  {DM} = SUBSTITUTE({DM} ex, {DM} v, {DM} vdef)
    %  SX = SUBSTITUTE(SX ex, SX v, SX vdef)
    %  {SX} = SUBSTITUTE({SX} ex, {SX} v, {SX} vdef)
    %  MX = SUBSTITUTE(MX ex, MX v, MX vdef)
    %  {MX} = SUBSTITUTE({MX} ex, {MX} v, {MX} vdef)
    %
    %
    %
    %
  [varargout{1:nargout}] = casadiMEX(945, varargin{:});
end
