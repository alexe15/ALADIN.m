 % plot logged values
 
 if i == 2
     initializePlots;
     line(plotStepSizes,i-1,log10(logg.localStepS(i-1)),'Marker', '.', 'MarkerSize', 5, 'Color', 'black', 'HandleVisibility', 'on', 'DisplayName', 'local step size');
     line(plotStepSizes,i-1,log10(logg.QPstepS(i-1)),'Marker', '.', 'MarkerSize', 5, 'Color', 'red', 'HandleVisibility', 'on', 'DisplayName', 'QP step sizes');
     drawnow
 elseif i >= 2
     set(0, 'CurrentFigure', visualizationFigure);
     % line(plotMeritFunction, i-1, log10(logg.Mfun(i-1)));
     line(plotConsViol, i-1,log10(logg.consViol(i-1)), 'Marker', '.', 'MarkerSize', 5, 'Color', 'b');
     line(plotSetChang, i-2, logg.wrkSetChang(i-2), 'Marker', '.', 'MarkerSize', 5, 'Color', 'b');
     line(plotStepSizes,i-1,log10(logg.localStepS(i-1)),'Marker', '.', 'MarkerSize', 5, 'Color', 'black', 'HandleVisibility', 'off');
     line(plotStepSizes,i-1,log10(logg.QPstepS(i-1)),'Marker', '.', 'MarkerSize', 5, 'Color', 'red', 'HandleVisibility', 'off');
     drawnow  
 end