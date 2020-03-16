function [zz0] = getStartValue(N, sigma)
%GETSTARTVALUE returns a start value for ALADIN opimization

initial_position = zeros(2, N);

for i = 1  : N
    initial_position(1, i) = N * cos( 2 * i * pi / N ) + normrnd(0, sigma);
    initial_position(2, i) = N * sin( 2 * i * pi / N ) + normrnd(0, sigma);
end

 zz0 = cell(1, N);
for i = 1 : N-1
    zz0(i) = {[initial_position(:, i); initial_position(:, i + 1)]};
end
 zz0(N) = {[initial_position(:, N); initial_position(:, 1)]};

end

