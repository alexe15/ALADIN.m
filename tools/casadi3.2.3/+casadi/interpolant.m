function varargout = interpolant(varargin)
    %INTERPOLANT An interpolant function for lookup table data
    %
    %  Function = INTERPOLANT(char name, char solver, [[double]] grid, [double] values, struct opts)
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
  [varargout{1:nargout}] = casadiMEX(914, varargin{:});
end
