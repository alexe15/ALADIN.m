function [H] = getInequalityConstr(N, y, eta_bar)
%GETINEQUALITYCONSTR retruns inequality constraint of sensor network
%localization probelm
 H = zeros(N, 1);
 H = sym(H);
 
 H(:) = (sqrt((y(1, :) - y(3, :)).^2 + (y(2, :) - y(4, :)).^2) - eta_bar(:)').^2;

end

