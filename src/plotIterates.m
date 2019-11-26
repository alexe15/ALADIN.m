 % plot logged values
        subPltCtr = 1;
         if i > 2
             % decision variables
             figure(1);
% %            set(fig, 'Position', [1400 200 1000 1100])
%             subplot(7,1,1);
%             hold on;
%             plot(logg.X');
%             xlabel('k')
%             ylabel('x')
%             
%             % objective function
%             subplot(7,1,2);
%             hold on;
%             semilogy(logg.obj);
%             xlabel('k')
%             ylabel('f(x)')
% 
%             % merit function
%             subplot(7,1,3);
            subplot(2,2,subPltCtr)
            subPltCtr = subPltCtr + 1;
            hold on;
            semilogy(logg.Mfun);
            xlabel('k')
            ylabel('Merit function')
             
%             % consensus violation
%             subplot(7,1,4);
%             figure(2)
            subplot(2,2,subPltCtr)
            subPltCtr = subPltCtr + 1;
            hold on;
            %semilogy(logg.consViol);
            plot(1:1:size(logg.consViol,2),log10(logg.consViol));
            xlabel('k')
            ylabel('log$ _{10}(||Ax-b||_\infty)$', 'Interpreter', 'latex')
            
% 
%             % working set
%            subplot(7,1,5);
%             figure(2);
%             hold on;
%             plot(logg.wrkSet');
%             xlabel('k')
%             ylabel('Active constraints')
%             
%             figure(3);
            subplot(2,2,subPltCtr)
            subPltCtr = subPltCtr + 1;
            hold on;
            plot(logg.wrkSetChang');
            xlabel('k')
            ylabel('Working set changes')
            
%             % descent direction
%             subplot(7,1,6);
%             hold on;
%             plot(logg.desc);
%             xlabel('k')
%             ylabel('Desc. direction?')
%             
%             % alpha
%             subplot(7,1,7);
lineSSQP = false;
            if lineSSQP == true
%                 figure(4);
                subplot(2,2,subPltCtr)
                subPltCtr = subPltCtr + 1;
                hold on;
                plot(logg.alpha);
                xlabel('k')
                ylabel('\alpha')
            end
%             figure(3);
%             hold on;
%             plot(logg.alpha');
%             xlabel('k')
%             ylabel('step size')

%             figure(5);
            subplot(2,2,subPltCtr)
            subPltCtr = subPltCtr + 1;
            hold on;
            plot(1:i-1,log10(logg.localStepS'),'k');
            plot(1:i-1,log10(logg.QPstepS'),'--r');
            xlabel('k')
            ylabel('step sizes')
            legend('local stepsize', 'QP stepsize')
        end