function varargout = substitute_inplace(varargin)
    %SUBSTITUTE_INPLACE 
    %
    %  [{IM} INOUT1, {IM} INOUT2] = SUBSTITUTE_INPLACE({IM} v, bool reverse)
    %  [{DM} INOUT1, {DM} INOUT2] = SUBSTITUTE_INPLACE({DM} v, bool reverse)
    %  [{SX} INOUT1, {SX} INOUT2] = SUBSTITUTE_INPLACE({SX} v, bool reverse)
    %  [{MX} INOUT1, {MX} INOUT2] = SUBSTITUTE_INPLACE({MX} v, bool reverse)
    %
    %
  [varargout{1:nargout}] = casadiMEX(922, varargin{:});
end
