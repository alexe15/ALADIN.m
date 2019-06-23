function varargout = interpolant(varargin)
    %INTERPOLANT An interpolant function for lookup table data
    %
    %  Function = INTERPOLANT(char name, char solver, {[double]} grid, [double] values, struct opts)
    %
    %
    %Parameters:
    %-----------
    %
    %name:  label for the resulting Function
    %
    %solver:  name of the plugin
    %
    %grid:  collection of 1D grids whose outer product defines the full N-D
    %rectangular grid
    %
    %values:  flattened vector of all values for all gridpoints
    %
    %Syntax 1D
    %
    %::
    %
    %  * # Python
    %  * xgrid = np.linspace(1,6,6)
    %  * V = [-1,-1,-2,-3,0,2]
    %  * LUT = casadi.interpolant("LUT","bspline",[xgrid],V)
    %  * print(LUT(2.5))
    %  * 
    %
    %
    %
    %::
    %
    %  * % Matlab
    %  * xgrid = 1:6;
    %  * V = [-1 -1 -2 -3 0 2];
    %  * LUT = casadi.interpolant('LUT','bspline',{xgrid},V);
    %  * LUT(2.5)
    %  * 
    %
    %
    %
    %Syntax 2D
    %
    %::
    %
    %  * # Python
    %  * xgrid = np.linspace(-5,5,11)
    %  * ygrid = np.linspace(-4,4,9)
    %  * X,Y = np.meshgrid(xgrid,ygrid,indexing='ij')
    %  * R = np.sqrt(5*X**2 + Y**2)+ 1
    %  * data = np.sin(R)/R
    %  * data_flat = data.ravel(order='F')
    %  * LUT = casadi.interpolant('name','bspline',[xgrid,ygrid],data_flat)
    %  * print(LUT([0.5,1]))
    %  * \\enverbatim
    %  * \\verbatim
    %  * % Matlab
    %  * xgrid = -5:1:5;
    %  * ygrid = -4:1:4;
    %  * R = sqrt(5*X.^2 + Y.^2)+ 1;
    %  * V = sin(R)./(R);
    %  * LUT = interpolant('LUT','bspline',{xgrid, ygrid},V(:));
    %  * LUT([0.5 1])
    %  * 
    %
    %
    %
    %General information
    %===================
    %
    %
    %
    %List of plugins
    %===============
    %
    %
    %
    %- bspline
    %
    %- linear
    %
    %Note: some of the plugins in this list might not be available on your
    %system. Also, there might be extra plugins available to you that are not
    %listed here. You can obtain their documentation with
    %Interpolant.doc("myextraplugin")
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %bspline
    %-------
    %
    %
    %
    %>List of available options
    %
    %+---------------+--------------+-------------------------------------------+
    %|      Id       |     Type     |                Description                |
    %+===============+==============+===========================================+
    %| degree        | OT_INTVECTOR | Sets, for each grid dimenion, the degree  |
    %|               |              | of the spline.                            |
    %+---------------+--------------+-------------------------------------------+
    %| linear_solver | OT_STRING    | Solver used for constructing the          |
    %|               |              | coefficient tensor.                       |
    %+---------------+--------------+-------------------------------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %--------------------------------------------------------------------------------
    %
    %linear
    %------
    %
    %
    %
    %>List of available options
    %
    %+-------------+-----------------+------------------------------------------+
    %|     Id      |      Type       |               Description                |
    %+=============+=================+==========================================+
    %| lookup_mode | OT_STRINGVECTOR | Sets, for each grid dimenion, the lookup |
    %|             |                 | algorithm used to find the correct       |
    %|             |                 | index. 'linear' uses a for-loop + break; |
    %|             |                 | 'exact' uses floored division (only for  |
    %|             |                 | uniform grids).                          |
    %+-------------+-----------------+------------------------------------------+
    %
    %--------------------------------------------------------------------------------
    %
    %
    %
    %Joel Andersson
    %
    %
    %
  [varargout{1:nargout}] = casadiMEX(909, varargin{:});
end
