function [F] = getObjective(N, y, eta, eta_bar, sigma)
% returns objective function for sensor network localization problem

F = zeros(N, 1);
F = sym(F);

F(:) = 1 / (4 * sigma^2) * ((y(1, :) - eta(1, 1 : N)).^2 + (y(2, :) - eta(2, 1 : N)).^2) ...
     + 1 / (4 * sigma^2) * ((y(3, :) - eta(1, 2 : end)).^2 + (y(4, :) - eta(2, 2 : end)).^2) ...
     + 1 / (2 * sigma^2) * (sqrt((y(1, :) - y(3, :)).^2 + (y(2, :) - y(4, :)).^2) - eta_bar(:)').^2;

end

