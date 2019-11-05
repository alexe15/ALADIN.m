function varargout = integrator_in(varargin)
    %INTEGRATOR_IN Get integrator input scheme name by index.
    %
    %  {char} = INTEGRATOR_IN()
    %    Get input scheme of integrators.
    %  char = INTEGRATOR_IN(int ind)
    %
    %
    %
    %> INTEGRATOR_IN()
    %------------------------------------------------------------------------
    %
    %
    %Get input scheme of integrators.
    %
    %
    %> INTEGRATOR_IN(int ind)
    %------------------------------------------------------------------------
    %
    %
    %Get integrator input scheme name by index.
    %
    %
    %
  [varargout{1:nargout}] = casadiMEX(862, varargin{:});
end
