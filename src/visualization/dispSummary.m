function [ ] = dispSummary( neddedIter, opts, iter)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
disp(['                                                                ']);
disp(['   ========================================================      ']);
disp(['   ==               This is ALADIN-M v0.1                ==      ']);
disp(['   ========================================================      ']);
%disp(['Current iteration: ', num2str(iterationIndex)]);
%disp(['                                                                ']);
%disp(['Applied solvers: ' ]);
disp(['   QP solver:        ', (opts.solveQP)]);
disp(['   Local solver:     ', (opts.locSol)]);
disp(['   Inner algorithm:  ', (opts.innerAlg)]);
disp(['                                                                ']);

if opts.term_eps == 0
    disp('   No termination criterion was specified.');
%    disp(['Remaining iterations:         ' , num2str(opts.maxiter - iterationIndex)]);
    disp(['   Consensus violation: ', num2str(iter.logg.consViol(end))]);
    if neddedIter == opts.maxiter
        disp(['                                                                ']);
        disp('   Maximum number of iterations reached.') 
    end
else
    disp(['   Given termination tolerance:', num2str(opts.term_eps)]);
    disp(['   Consensus violation:', num2str(iter.logg.consViol)]);
    if neddedIter == opts.maxiter && opts.term_eps > iter.logg.consViol(end)
        disp('   Maximum number of iterations is reached without satisfying given termination criterion.')
    elseif opts.term_eps <= iter.logg.consViol
        disp('   Success --- termination criterion satisfied.')
    end
end

end

