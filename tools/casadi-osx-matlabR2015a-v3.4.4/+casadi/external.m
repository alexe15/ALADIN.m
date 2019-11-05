function varargout = external(varargin)
    %EXTERNAL Load a just-in-time compiled external function File name given.
    %
    %  Function = EXTERNAL(char name, struct opts)
    %    Load an external function File name is assumed to be ./<f_name>.so.
    %  Function = EXTERNAL(char name, Importer compiler, struct opts)
    %  Function = EXTERNAL(char name, char bin_name, struct opts)
    %    Load an external function File name given.
    %
    %
    %
    %> EXTERNAL(char name, char bin_name, struct opts)
    %------------------------------------------------------------------------
    %
    %
    %Load an external function File name given.
    %
    %
    %> EXTERNAL(char name, struct opts)
    %------------------------------------------------------------------------
    %
    %
    %Load an external function File name is assumed to be ./<f_name>.so.
    %
    %
    %> EXTERNAL(char name, Importer compiler, struct opts)
    %------------------------------------------------------------------------
    %
    %
    %Load a just-in-time compiled external function File name given.
    %
    %
    %
  [varargout{1:nargout}] = casadiMEX(857, varargin{:});
end
