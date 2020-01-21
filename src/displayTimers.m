function [  ] = displayTimers(timers)
% Shows the timings for the major steps of ALADIN

disp(['Total ALADIN time:   ' num2str(toc(totTime)) ' sec'])
disp(['Problem setup:       ' num2str(toc(setupT)) ' sec'])
disp(['Only iterations:     ' num2str(toc(iterTime)) ' sec'])
disp(['NLP total time:      ' num2str(NLPtotTime) ' sec'])
disp(['QP total time:       ' num2str(QPtotTime) ' sec'])
disp(['Regularization time: ' num2str(RegTotTime) ' sec'])
end

