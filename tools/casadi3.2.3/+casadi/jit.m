function varargout = jit(varargin)
    %JIT Create a just-in-time compiled function from a C/C++ language string The
    %
    %  Function = JIT(char name, int n_in, int n_out, char body, struct opts)
    %
    %function can an arbitrary number of inputs and outputs that must all be
    %scalar-valued. Only specify the function body, assuming that the inputs are
    %stored in an array named 'arg' and the outputs stored in an array named
    %'res'. The data type used must be 'real_t', which is typically equal to
    %'double` or another data type with the same API as 'double'.
    %
    %The final generated function will have a structure similar to:
    %
    %void fname(const real_t* arg, real_t* res) { <FUNCTION_BODY> }
    %
    %
    %
  [varargout{1:nargout}] = casadiMEX(848, varargin{:});
end
