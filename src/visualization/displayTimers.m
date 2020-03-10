function [  ] = displayTimers(timers, opts)
% Shows the timings for the major steps of ALADIN

decP    = 1;
p.setup =  round(timers.setupT/timers.totTime*100,decP);
p.iter  =  round(timers.iter.iterTime/timers.totTime*100,decP);

p.NLP  =  round(timers.iter.NLPtotTime/timers.iter.iterTime*100,decP);
p.plt  =  round(timers.iter.plotTimer/timers.iter.iterTime*100,decP);
p.QP   =  round(timers.iter.QPtotTime/timers.iter.iterTime*100,decP);
p.reg  =  round(timers.iter.RegTotTime/timers.iter.iterTime*100,decP);


disp(['                                                           '])
disp(['   -----------------   ALADIN-M timing   ------------------'])
disp(['                       t[s]        %tot         %iter'])
fprintf('   Tot time:......:    %-11.1f %-11.1f  %-11.1f\n',timers.totTime,[],[]);
fprintf('   Prob setup:....:    %-11.1f %-11.1f  %-11.1f\n',timers.setupT,p.setup,[] );
fprintf('   Iter time:.....:    %-11.1f %-11.1f  %-11.1f\n',timers.iter.iterTime,p.iter,[] );
disp('   ------')
fprintf('   NLP time:......:    %-11.1f %-11.1f  %-11.1f\n',timers.iter.NLPtotTime,[],p.NLP);
fprintf('   QP time:.......:    %-11.1f %-11.1f  %-11.1f\n',timers.iter.QPtotTime,[],p.QP );
fprintf('   Reg time:......:    %-11.1f %-11.1f  %-11.1f\n',timers.iter.RegTotTime,[],p.reg );
fprintf('   Plot time:.....:    %-11.1f %-11.1f  %-11.1f\n',timers.iter.plotTimer,[],p.plt );
disp(['                                                           '])

if strcmp(opts.commCount, 'false')
    disp('   ========================================================')
end


end

