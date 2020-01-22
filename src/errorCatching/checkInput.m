function [  ] = checkInput( sProb )
% script to check plausibility of input variables
[ ffifun ggifun hhifun ] =  ...
               deal(sProb.locFuns.ffi, sProb.locFuns.ggi, sProb.locFuns.hhi);


%% dimension check of number of subsystems
size_ffi = size(ffifun);
size_ggi = size(ggifun);
size_hhi = size(hhifun);

assert(all(size_ffi == size_ggi) & all(size_hhi == size_ffi), ...
    ['ERROR: Mismatching dimensions of the number of subsystems.' ...
    'The sizes of the cells respectively containing the ' ...
    'objective functions f_i, the equality contraints h_i'...
    'and the inequality constraints g_i must be equal']);

%% dimension check of matrix A
assert(all(size_ffi == size(sProb.AA)), ...
    ['ERROR: Mismatching number of coupling matrices.' ...
    'The number of coupling matrices is supposed to be equal to the' ...
    'number of subsystems']);

%% dimension check of initial value
 x_test = vertcat(sProb.zz0{:});
 A_test = [sProb.AA{:}];
 
 size_x_test = size(x_test);
 size_A_test = size(A_test);
 
 assert(size_x_test(1) == size_A_test(2), ...
    ['ERROR: please recheck the dimensions of the inital value of x' ...
    ' it should be equal to the dimension of the concatented' ...
    'coupling matrices']);

%% check rank of AA
AA_concat = horzcat(sProb.AA{:});
size_AA = size(AA_concat);

assert(rank(AA_concat) == size_AA(1), ... 
       ['ERROR: rank of AA should be equal to its number of rows.' ...
       'otherwise no full coupling is possible']);

%% dimension check of lambda
size_AA = size(sProb.AA{1},1);

assert(size_AA(1) == length(sProb.lam0), ...
    ['Mismatch of dimension of lam0.' ...
    'Dimension should be equal to number of rows of he coupling matrices']);


end