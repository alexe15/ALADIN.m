function [AA] = getCouplingMatrix(N, n)
% GETCOUPLINGMATRIX returns the coupling matrix of sensor network
% localization problem

I = [1, 0; 0, 1];
A0 = zeros(2*N, n);

A_1 = A0;
A_1(1:2, 3:4) = I;
A_1(2*N - 1: 2*N, 1:2) = -I;

AA(1) = mat2cell(A_1, 2 * N, n);

for i = 2 : 1 : N
    A_i = A0;
    A_i(2*(i-2) + 1 : 2*(i-2) + 2, 1:2) = -I;
    A_i(2*i - 1: 2*i, 3:4 ) = I;
    AA(i) = mat2cell(A_i, 2*N, n);
end

end