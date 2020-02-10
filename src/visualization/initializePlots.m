visualizationFigure = figure(1);

plotMeritFunction = subplot(2, 2, 1);
hold on;
xlabel('k')
ylabel('Merit function')
xlim([0 opts.maxiter]);
%ylim([-size(hhi, 2)-size(ggi, 2) size(hhi, 2)+size(ggi,2)]);
axis manual;
grid on
box on

plotConsViol =  subplot(2, 2, 2);
hold on
xlabel('k')
ylabel('log$ _{10}(||Ax-b||_\infty)$', 'Interpreter', 'latex')
xlim([0 opts.maxiter]);
% TODO set lower bound to exponent of opts.term_eps!!!
% TODO give reasonable value to lower bound of ylim.
%      Mabye evalute counpling constraint first
ylim([-15 3]);
axis manual;
grid on
box on

plotSetChang = subplot(2, 2, 3);
hold on
xlabel('k')
ylabel('Working set changes')
xlim([0 opts.maxiter]);
%ylim([-size(hhi,2)-size(ggi,2) size(hhi,2)+size(ggi,2)]);
axis manual;
grid on
box on

plotStepSizes = subplot(2, 2, 4);
hold on
xlabel('k')
ylabel('logarithmic step sizes')
l = legend('show');
xlim([0 opts.maxiter]);
ylim([-12 2]);
axis manual;
grid on
box on