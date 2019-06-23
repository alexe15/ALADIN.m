function varargout = collocation_interpolators(varargin)
    %COLLOCATION_INTERPOLATORS Obtain collocation interpolating matrices.
    %
    %  [{[double]} OUTPUT, [double] OUTPUT] = COLLOCATION_INTERPOLATORS([double] tau_root)
    %
    %
    %Parameters:
    %-----------
    %
    %tau_root:  location of collocation points, as obtained from
    %collocation_points
    %
    %output_C:  interpolating coefficients to obtain derivatives Length: order+1,
    %order + 1
    %
    %
    %
    %::
    %
    %dX/dt @collPoint(j) ~ Sum_i C[j][i]*X@collPoint(i)
    %
    %
    %
    %Parameters:
    %-----------
    %
    %output_D:  interpolating coefficients to obtain end state Length: order+1
    %
    %
    %
  [varargout{1:nargout}] = casadiMEX(987, varargin{:});
end
