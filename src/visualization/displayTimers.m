function [  ] = displayTimers(timers)
% Shows the timings for the major steps of ALADIN

decP    = 1;
p.setup =  round(timers.setupT/timers.totTime*100,decP);
p.iter  =  round(timers.iter.iterTime/timers.totTime*100,decP);

p.NLP  =  round(timers.iter.NLPtotTime/timers.iter.iterTime*100,decP);
p.plt  =  round(timers.iter.plotTimer/timers.iter.iterTime*100,decP);
p.QP   =  round(timers.iter.QPtotTime/timers.iter.iterTime*100,decP);
p.reg  =  round(timers.iter.RegTotTime/timers.iter.iterTime*100,decP);

dec =  2;

disp(['                                                          '])
disp(['   ==================   ALADIN timing   =================='])
%disp(['                                                          '])
disp(['                t[s]    %tot    %iter'])
disp(['Tot time:       ' num2str(round(timers.totTime,dec))])
disp(['Prob setup:     ' num2str(round(timers.setupT,dec)) '     ' ...
                                                         num2str(p.setup)])
disp(['Iter time:      ' num2str(round(timers.iter.iterTime,dec)) ...
                                                  '     ' num2str(p.iter)])
disp(['  ------'])
disp(['NLP time:       ' num2str(round(timers.iter.NLPtotTime,dec)) ...
                                      '            '  num2str(p.NLP)])
disp(['QP time:        ' num2str(round(timers.iter.QPtotTime,dec))...
                                      '            '  num2str(p.QP)])
disp(['Reg time:       ' num2str(round(timers.iter.RegTotTime,dec))...
                                      '            '  num2str(p.reg)])
disp(['Plot time:      ' num2str(round(timers.iter.plotTimer,dec))...
                                      '            '  num2str(p.plt)])
                                 
end

