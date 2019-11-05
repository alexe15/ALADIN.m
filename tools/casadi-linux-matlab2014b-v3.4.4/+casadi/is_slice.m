function varargout = is_slice(varargin)
    %IS_SLICE Is the IM a Slice.
    %
    %  bool = IS_SLICE([int] v, bool ind1)
    %    Check if an index vector can be represented more efficiently as a slice.
    %  bool = IS_SLICE(IM x, bool ind1)
    %
    %
    %
    %> IS_SLICE(IM x, bool ind1)
    %------------------------------------------------------------------------
    %
    %
    %Is the IM a Slice.
    %
    %
    %> IS_SLICE([int] v, bool ind1)
    %------------------------------------------------------------------------
    %
    %
    %Check if an index vector can be represented more efficiently as a slice.
    %
    %
    %
  [varargout{1:nargout}] = casadiMEX(438, varargin{:});
end
