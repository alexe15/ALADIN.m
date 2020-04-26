 % plot logged values
 
 if i == 1
     initializePlots;
     line(plotStepSizes,i,log10(iter.logg.localStepS(i)),'Marker','.', ...
             'MarkerSize', 5, 'Color', 'black', 'HandleVisibility', 'on', ...
             'DisplayName', 'local step size');
     line(plotStepSizes,i,log10(iter.logg.QPstepS(i)),'Marker', '.',...
             'MarkerSize', 5, 'Color', 'red', 'HandleVisibility', 'on', ...
             'DisplayName', 'QP step size');
     drawnow

 elseif i >= 3  
          set(0, 'CurrentFigure', visualizationFigure);
     % line(plotMeritFunction, i-1, log10(logg.Mfun(i-1)));
     line(plotConsViol, i,log10(iter.logg.consViol(i)), 'Marker', '.',...
             'MarkerSize', 5, 'Color', 'b');
     line(plotStepSizes,i,log10(iter.logg.localStepS(i)),'Marker', '.',  ...
             'MarkerSize', 5, 'Color', 'black', 'HandleVisibility', 'off');
     line(plotStepSizes,i,log10(iter.logg.QPstepS(i)),'Marker', '.',...
             'MarkerSize', 5, 'Color', 'red', 'HandleVisibility', 'off');
     if strcmp(opts.alg, 'ALADIN')
         if ~isempty(iter.logg.wrkSetChang)
             line(plotSetChang, i-2, iter.logg.wrkSetChang(i-2), 'Marker', '.', ...
                     'MarkerSize', 5, 'Color', 'b');
         end
     end        
     drawnow
     
  elseif i >= 2
     set(0, 'CurrentFigure', visualizationFigure);
     % line(plotMeritFunction, i-1, log10(logg.Mfun(i-1)));
     line(plotConsViol, i,log10(iter.logg.consViol(i)), 'Marker', '.',...
             'MarkerSize', 5, 'Color', 'b');
    % line(plotSetChang, i, iter.logg.wrkSetChang(i), 'Marker', '.', ...
    %         'MarkerSize', 5, 'Color', 'b');
     line(plotStepSizes,i,log10(iter.logg.localStepS(i)),'Marker', '.',  ...
             'MarkerSize', 5, 'Color', 'black', 'HandleVisibility', 'off');
     line(plotStepSizes,i,log10(iter.logg.QPstepS(i)),'Marker', '.',...
             'MarkerSize', 5, 'Color', 'red', 'HandleVisibility', 'off');
     drawnow
 end