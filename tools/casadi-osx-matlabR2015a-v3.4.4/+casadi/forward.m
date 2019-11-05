function varargout = forward(varargin)
    %FORWARD Forward directional derivative.
    %
    %  {{IM}} = FORWARD({IM} ex, {IM} arg, {{IM}} v, struct opts)
    %  {{DM}} = FORWARD({DM} ex, {DM} arg, {{DM}} v, struct opts)
    %  {{SX}} = FORWARD({SX} ex, {SX} arg, {{SX}} v, struct opts)
    %  {{MX}} = FORWARD({MX} ex, {MX} arg, {{MX}} v, struct opts)
    %
    %
    %
    %
  [varargout{1:nargout}] = casadiMEX(943, varargin{:});
end
