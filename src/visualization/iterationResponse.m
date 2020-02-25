function [ ] = iterationResponse(iterationIndex, opts, iter)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
disp(['                                                                ']);
disp(['   ================== ALADIN response ===================    ']);
disp(['                                                                ']);
disp(['   ============== ALADIN iteration summary ==============    ']);
disp(['                                                                ']);
disp(['Current iteration: ', num2str(iterationIndex)]);
disp(['                                                                ']);
disp(['Applied solvers: ' ]);
disp(['QP solver:        ', (opts.solveQP)]);
disp(['Local solver:     ', (opts.locSol)]);
disp(['Inner algorithm:  ', (opts.innerAlg)]);
disp(['                                                                ']);

if opts.term_eps == 0
    disp('No specific termination error bound was handed over.');
    disp(['Remaining iterations:         ' , num2str(opts.maxiter - iterationIndex)]);
    disp(['Current constraint violation: ', num2str(iter.logg.consViol(end))]);
    if iterationIndex == opts.maxiter
        disp(['                                                                ']);
        disp('Maximum number of iterations is reached.') 
    end
else
    disp(['requested upper bound of constraint violation:', num2str(opts.term_eps)]);
    disp(['current constraint violation', num2str(iter.logg.consViol)]);
    if iterationIdex == maxiter && opts.term_eps > iter.logg.consViol
        disp('Maximum number of iterations is reached without satisfying the desired convergence bounds.')
    elseif opts.term_eps <= iter.logg.consViol
        disp('Optimal solution found with respect to the handed over termination criterion')
    end
end

end

