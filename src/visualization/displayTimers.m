function [  ] = displayTimers(timers, opts)
% Shows the timings for the major steps of ALADIN

decP    = 1;
p.setup =  round(timers.setupT/timers.totTime*100,decP);
p.iter  =  round(timers.iterTime/timers.totTime*100,decP);

p.NLP  =  round(timers.NLPtotTime/timers.iterTime*100,decP);
p.plt  =  round(timers.plotTimer/timers.iterTime*100,decP);
p.QP   =  round(timers.QPtotTime/timers.iterTime*100,decP);
p.reg  =  round(timers.RegTotTime/timers.iterTime*100,decP);


disp(['                                                           '])
disp(['   ---------------   ALADIN-alpha timing   ----------------'])
disp(['                       t[s]        %tot         %iter'])
fprintf('   Tot time:......:    %-11.1f %-11.1f  %-11.1f\n',timers.totTime,[],[]);
fprintf('   Prob setup:....:    %-11.1f %-11.1f  %-11.1f\n',timers.setupT,p.setup,[] );
fprintf('   Iter time:.....:    %-11.1f %-11.1f  %-11.1f\n',timers.iterTime,p.iter,[] );
disp('   ------')
fprintf('   NLP time:......:    %-11.1f %-11.1f  %-11.1f\n',timers.NLPtotTime,[],p.NLP);
fprintf('   QP time:.......:    %-11.1f %-11.1f  %-11.1f\n',timers.QPtotTime,[],p.QP );
fprintf('   Reg time:......:    %-11.1f %-11.1f  %-11.1f\n',timers.RegTotTime,[],p.reg );
fprintf('   Plot time:.....:    %-11.1f %-11.1f  %-11.1f\n',timers.plotTimer,[],p.plt );
disp(['                                                           '])

if strcmp(opts.commCount, 'false')
    disp('   ========================================================')
end


end

