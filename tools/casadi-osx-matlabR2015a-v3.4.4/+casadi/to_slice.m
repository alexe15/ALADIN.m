function varargout = to_slice(varargin)
    %TO_SLICE Convert IM to Slice.
    %
    %  Slice = TO_SLICE([int] v, bool ind1)
    %    Construct from an index vector (requires is_slice(v) to be true)
    %  Slice = TO_SLICE(IM x, bool ind1)
    %
    %
    %
    %> TO_SLICE(IM x, bool ind1)
    %------------------------------------------------------------------------
    %
    %
    %Convert IM to Slice.
    %
    %
    %> TO_SLICE([int] v, bool ind1)
    %------------------------------------------------------------------------
    %
    %
    %Construct from an index vector (requires is_slice(v) to be true)
    %
    %
    %
  [varargout{1:nargout}] = casadiMEX(439, varargin{:});
end
