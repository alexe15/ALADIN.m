function [ NLPopts, solver] = loadNLPopts( )
% set some local solver options if desired

% specify print levels
NLPopts.print_time = 0;
NLPopts.ipopt.print_level = 5;
    
% specify tolerances
%     NLPopts.qpsol = 'qpoases';
%     NLPopts.ipopt.acceptable_tol = 1e-12;
%     NLPopts.ipopt.acceptable_compl_inf_tol = 1e-12;
%     NLPopts.ipopt.acceptable_constr_viol_tol = 1e-12;
%     NLPopts.ipopt.acceptable_iter = 0;

% specify local solver
solver = 'ipopt'; % 'sqpmethod'
end

