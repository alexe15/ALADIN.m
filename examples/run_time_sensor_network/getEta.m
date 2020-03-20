function [eta,eta_bar] = getEta(N, d, sigma)
% returns by sensor estimated initial position and distance to its neighbours
 
 eta     = zeros(d, N + 1);
 eta_bar = zeros(1, N);
 
 for i = 1 : N
     eta( :, i ) = [N * cos(2 * i * pi / N) + normrnd(0, sigma) ; ...
                    N * sin(2 * i * pi / N) + normrnd(0, sigma)];
     
     eta_bar(i)  = 2 * N * sin( pi / N) + normrnd(0, sigma);
 end
 
 eta(:, N + 1) = eta(:, 1);
end

