% initialize
clear all;
clc;
close all;

% import the parameters
par = parameters();

% number of reactors
Nunit = par.Nunit;

% sampling time and time horizon
dT   = par.dT;
N    = par.N;
H    = dT*N;
Nx   = Nunit*N*4;
Nmpc = 10; 
 
% input constraints
sc_in = par.sc_in; % scaling parameter for input
Qs = par.Qs/sc_in;
delta_Q1 = 5e4/sc_in;
delta_Q2 = 1.5e5/sc_in;
delta_Q3 = 2e5/sc_in;

Ql = [Qs(1) - delta_Q1; Qs(2) - delta_Q2; Qs(3) - delta_Q3];
Qu = [Qs(1) + delta_Q1; Qs(2) + delta_Q2; Qs(3) + delta_Q3];

% set start point
x0{1} = par.x10;
x0{2} = par.x20;
x0{3} = par.x30;

% set steady point
xs{1} = par.x1s;
xs{2} = par.x2s;
xs{3} = par.x3s;

sc_tem = par.sc_tem; % scaling parameter for temperature
for i =1:Nunit
    x0{i}(1) = x0{i}(1)/sc_tem;
    xs{i}(1) = xs{i}(1)/sc_tem;
end

% set the weight matrix of cost function
Qc = diag([20*sc_tem^2, 1000, 1000, 1000]);
Rc = 1e-10*sc_in^2;

%% distributed formulation
for i = 1:Nunit
    for k = 1:Nunit
        ZZ{i}{k} = sym(['z' num2str(i) num2str(k)], [4 N]); % states
    end
    UU{i} = sym(['u' num2str(i)], [1 N]); % inputs
    
    XX0{i} = sym(['x0' num2str(i)], [4 1]);
end

% for each reactor
for i = 1:Nunit
    JJ{i}   = 0;
    gg{i}   = [];
    llbu{i} = [];
    uubu{i} = [];
    gg{i} = [gg{i}; ZZ{i}{i}(:,1)-XX0{i}];
    state = [];
    for k = setdiff(1:Nunit,i)
        state = vertcat(state, ZZ{i}{k});
    end
    
    % over horizon
    for j = 1: N-1
        ZZij1    = rk4(@(t,x,u) ode_reactor(t,x,u,i,state(:,j)), dT, 0, ZZ{i}{i}(:,j), UU{i}(j));
        gg{i}    = [gg{i}; ZZ{i}{i}(:,j+1)-ZZij1];
        dx       = ZZ{i}{i}(:,j+1) - xs{i};
        du       = UU{i}(j) - Qs(i); 
        JJ{i}    = JJ{i} + dx.'*Qc*dx + du.'*Rc*du;
    end
end

% connect the states and inputs
for i = 1:Nunit
    ZZi      = vertcat(vertcat(ZZ{i}{:}));
    XXU{i}   = [ZZi(:); UU{i}(:)];
end

% set up consensus constraints
Abase   = [eye(Nunit*N*4) zeros(Nunit*N*4,N)];
zerbase = zeros(size(Abase));
for i = 1:Nunit-1
    AA{i} = [repmat(zerbase,i-1,1); Abase; repmat(zerbase, Nunit-i-1,1)];
end
AA{Nunit} = -repmat(Abase, Nunit-1, 1);

%% solve with ALADIN
for i = 1:Nunit
    chem.locFuns.ffi{i} = matlabFunction(JJ{i}, 'Vars', {XXU{i},XX0{i}});
    chem.locFuns.ggi{i} = matlabFunction(gg{i}, 'Vars', {XXU{i},XX0{i}});
    emptyfun = @(x,y) [];
    chem.locFuns.hhi{i} = emptyfun;
    
    % set up aladin parameters    
    chem.llbx{i} = [zeros(Nunit*N*4,1); Ql(i)*ones(N,1)];
    chem.uubx{i} = [inf*ones(Nunit*N*4,1); Qu(i)*ones(N,1)];
    chem.AA{i}   = AA{i};
    chem.zz0{i}  = [repmat(vertcat(x0{:}),N,1); Qs(i)*ones(N,1)];
    chem.p{i}    = x0{i};
    
    SSig{i} = eye(length(XXU{i}));
end

chem.lam0 = ones(size(AA{1},1),1);


% initialize the options for ALADIN
opts.rho = 1e3;
opts.mu = 1e4;
opts.maxiter = 50;
opts.term_eps = 0; % no termination criterion, stop after maxit
opts.plot = 'false';
opts.reuse = 'true';

% solve with ALADIN
sol_ALADIN{1}   = run_ALADIN(chem,opts);
% reuse problem formulation 
fNames = fieldnames(sol_ALADIN{1}.problemForm);
for j = 1:length(fNames)
   chem.(fNames{j}) = sol_ALADIN{1}.problemForm.(fNames{j});
end

Xopt = vertcat(x0{:});
Uopt = [];
for i = 2:Nmpc
    chem.zz0 = sol_ALADIN{i-1}.xxOpt;
    Xopti = [];
    Uopti = [];
    for j = 1:Nunit
        xx0{j} = sol_ALADIN{i-1}.xxOpt{j}(12+[1+(j-1)*4:j*4]);
        Xopti = [Xopti; xx0{j}];
        Uopti = [Uopti; sol_ALADIN{i-1}.xxOpt{j}(Nunit*N*4+1)];
        chem.p{j} = xx0{j};
    end
    sol_ALADIN{i} = run_ALADIN(chem, opts);
    Xopt = [Xopt, Xopti];
    Uopt = [Uopt, Uopti];
end
Uopt_last = [sol_ALADIN{Nmpc}.xxOpt{1}(Nunit*N*4+1);
             sol_ALADIN{Nmpc}.xxOpt{2}(Nunit*N*4+1);
             sol_ALADIN{Nmpc}.xxOpt{3}(Nunit*N*4+1)];

Uopt = [Uopt,Uopt_last];

plotresults([Xopt;Uopt])

%% define the fuctions 
% function: Runge-Kutte 4 Integrator
function xf = rk4(ode,h,t,x,u)
  k1 = ode(t, x,        u);
  k2 = ode(t, x+h/2*k1, u);
  k3 = ode(t, x+h/2*k2, u);
  k4 = ode(t, x+h*k3,   u);
  xf = x + h/6 * (k1 + 2*k2 + 2*k3 + k4); 
end


% function: ode of reactors
function dx = ode_reactor(t, x, u, number, state)
    % get parameters
    par  = parameters();
    Nunit = par.Nunit;
    T10  = par.T10;
    T20  = par.T20;
    F10  = par.F10;
    F20  = par.F20;
    F1   = par.F1;
    F2   = par.F2;
    Fr   = par.Fr;
    CA10 = par.CA10;
    CA20 = par.CA20;
    V1   = par.V1;
    V2   = par.V2;
    V3   = par.V3;    
    E1   = par.E1;
    E2   = par.E2;    
    k1   = par.k1;
    k2   = par.k2;
    H1   = par.H1;
    H2   = par.H2;
    Hvap = par.Hvap;
    
    alpha_a = par.alpha_a;
    alpha_b = par.alpha_b;
    alpha_c = par.alpha_c;
    alpha_d = par.alpha_d;
    MWA     = par.MWA;
    MWB     = par.MWB;
    MWC     = par.MWC;
    Cp      = par.Cp;
    R       = par.R;
    rho     = par.rho;
    xd      = par.xd;
    % scaling parameters
    sc_in   = par.sc_in;
    sc_tem  = par.sc_tem;
    
    % write the state according to their physical meanings
    T = sym('T', [Nunit 1]);
    CA = sym('CA', [Nunit 1]);
    CB = sym('CB', [Nunit 1]);
    CC = sym('CC', [Nunit 1]);

    T(number)  = x(1);
    CA(number) = x(2);
    CB(number) = x(3);
    CC(number) = x(4);
    other =setdiff(1:Nunit, number);
    T(other(1))  = state(1);
    CA(other(1)) = state(2);
    CB(other(1)) = state(3);
    CC(other(1)) = state(4);
    T(other(2))  = state(5);
    CA(other(2)) = state(6);
    CB(other(2)) = state(7);
    CC(other(2)) = state(8);
    
    Q  = sc_in*u;
    
    % give the concentration in the recycle
    K   = (alpha_a*CA(3)*MWA + alpha_b*CB(3)*MWB + alpha_c*CC(3)*MWC)/rho + alpha_d*xd*rho;
    CAr = alpha_a*CA(3)/K;
    CBr = alpha_b*CB(3)/K;
    CCr = alpha_c*CC(3)/K; 
    
    E1T1 = exp(-E1/(R*sc_tem*T(1)));
    E2T1 = exp(-E2/(R*sc_tem*T(1)));
    E1T2 = exp(-E1/(R*sc_tem*T(2)));
    E2T2 = exp(-E2/(R*sc_tem*T(2)));

    switch number
        case 1             
            dT  = F10/V1*(T10-sc_tem*T(1)) + Fr/V1*sc_tem*(T(3)-T(1)) - H1/(Cp*rho)*k1*E1T1*CA(1) - H2/(Cp*rho)*k2*E2T1*CA(1) + Q/(rho*Cp*V1);
            dCA = F10/V1*(CA10-CA(1)) + Fr/V1*(CAr-CA(1)) - k1*E1T1*CA(1) - k2*E2T1*CA(1);
            dCB = -F10/V1*CB(1) + Fr/V1*(CBr-CB(1)) + k1*E1T1*CA(1);
            dCC = -F10/V1*CC(1) + Fr/V1*(CCr-CC(1)) + k2*E2T1*CA(1);
        case 2
            dT  = F1/V2*sc_tem*(T(1)-T(2)) + F20/V2*(T20-sc_tem*T(2)) - H1/(Cp*rho)*k1*E1T2*CA(2) - H2/(Cp*rho)*k2*E2T2*CA(2) + Q/(rho*Cp*V2);
            dCA = F1/V2*(CA(1)-CA(2)) + F20/V2*(CA20-CA(2)) - k1*E1T2*CA(2) - k2*E2T2*CA(2);
            dCB = F1/V2*(CB(1)-CB(2)) - F20/V2*CB(2) + k1*E1T2*CA(2);
            dCC = F1/V2*(CC(1)-CC(2)) - F20/V2*CC(2) + k2*E2T2*CA(2);
        case 3
            dT  = F2/V3*sc_tem*(T(2)-T(3)) - Hvap*Fr/(rho*Cp*V3) + Q/(rho*Cp*V3);
            dCA = F2/V3*(CA(2)-CA(3)) - Fr/V3*(CAr-CA(3));
            dCB = F2/V3*(CB(2)-CB(3)) - Fr/V3*(CBr-CB(3));
            dCC = F2/V3*(CC(2)-CC(3)) - Fr/V3*(CCr-CC(3));
        otherwise
            disp('This type is not supported.');
    end
    
    dT = 1/sc_tem*dT;
    dx = [dT; dCA; dCB; dCC];

end

% function: plot the results
function plotresults(X)

    set(groot, 'defaultAxesTickLabelInterpreter','latex');
    set(groot, 'defaultLegendInterpreter','latex');
    par    = parameters();
    N      = size(X, 2);
    dT     = par.dT;
    sc_tem = par.sc_tem;
    sc_in  = par.sc_in;

    T1  = sc_tem*X(1,:);
    ca1 = X(2,:);
    cb1 = X(3,:);
    cc1 = X(4,:);
    T2  = sc_tem*X(5,:); 
    ca2 = X(6,:);
    cb2 = X(7,:);
    cc2 = X(8,:);
    T3  = sc_tem*X(9,:);
    ca3 = X(10,:);
    cb3 = X(11,:);
    cc3 = X(12,:);
    Q1  = sc_in*X(13,:);
    Q2  = sc_in*X(14,:);
    Q3  = sc_in*X(15,:);
    t = [0:N-1]*0.01;

    % plot the state variables

    figure();
    subplot(3,4,1);
    plot(t, T1);
    xlabel('$t \ (h)$', 'interpreter', 'latex');
    ylabel('$ T_1 \ (K)$', 'interpreter', 'latex');
    subplot(3,4,2);
    plot(t, ca1);
    xlabel('$t \ (h)$', 'interpreter', 'latex');
    ylabel('$C_{A1} \ (kmol/m^3)$', 'interpreter', 'latex');
    subplot(3,4,3);
    plot(t, cb1);
    xlabel('$t \ (h)$', 'interpreter', 'latex');
    ylabel('$C_{B1} \ (kmol/m^3)$', 'interpreter', 'latex');
    subplot(3,4,4);
    plot(t, cc1);
    xlabel('$t \ (h)$', 'interpreter', 'latex');
    ylabel('$C_{C1} \ (kmol/m^3)$', 'interpreter', 'latex');
    subplot(3,4,5);
    plot(t, T2);
    xlabel('$t \ (h)$', 'interpreter', 'latex');
    ylabel('$ T_2 \ (K)$', 'interpreter', 'latex');
    subplot(3,4,6);
    plot(t, ca2);
    xlabel('$t \ (h)$', 'interpreter', 'latex');
    ylabel('$C_{A2} \ (kmol/m^3)$', 'interpreter', 'latex');
    subplot(3,4,7);
    plot(t, cb2);
    xlabel('$t \ (h)$', 'interpreter', 'latex');
    ylabel('$C_{B2} \ (kmol/m^3)$', 'interpreter', 'latex');
    subplot(3,4,8);
    plot(t, cc2);
    xlabel('$t \ (h)$', 'interpreter', 'latex');
    ylabel('$C_{C2} \ (kmol/m^3)$', 'interpreter', 'latex');
    subplot(3,4,9);
    plot(t, T3);
    xlabel('$t \ (h)$', 'interpreter', 'latex');
    ylabel('$ T_3 \ (K)$', 'interpreter', 'latex');
    subplot(3,4,10);
    plot(t, ca3);
    xlabel('$t \ (h)$', 'interpreter', 'latex');
    ylabel('$C_{A3} \ (kmol/m^3)$', 'interpreter', 'latex');
    subplot(3,4,11);
    plot(t, cb3);
    xlabel('$t \ (h)$', 'interpreter', 'latex');
    ylabel('$C_{B3} \ (kmol/m^3)$', 'interpreter', 'latex');
    subplot(3,4,12);
    plot(t, cc3);
    xlabel('$t \ (h)$', 'interpreter', 'latex');
    ylabel('$C_{C3} \ (kmol/m^3)$', 'interpreter', 'latex');

    figure();
    subplot(3,1,1)
    plot(t,Q1);
    xlabel('$t \ (h)$', 'interpreter', 'latex');
    ylabel('$Q_1 \ (kJ/h)$', 'interpreter', 'latex');
    subplot(3,1,2)
    plot(t,Q2);
    xlabel('$t \ (h)$', 'interpreter', 'latex');
    ylabel('$Q_2 \ (kJ/h)$', 'interpreter', 'latex');
    subplot(3,1,3)
    plot(t,Q3);
    xlabel('$t \ (h)$', 'interpreter', 'latex');
    ylabel('$Q_3 \ (kJ/h)$', 'interpreter', 'latex');

end


% function: definition of system parameters
function par = parameters
    par.Nunit      = 3;
    par.N          = 10;
    par.dT         = 0.01;

    par.T10        = 300;
    par.T20        = 300;

    par.F10        = 5;
    par.F20        = 5;
    par.Fr         = 1.9;
    par.F1         = 6.883;
    par.F2         = 12.44;

    par.CA10       = 4;
    par.CA20       = 3;

    par.V1         = 1;
    par.V2         = 0.5;
    par.V3         = 1; 

    par.E1         = 5e4;
    par.E2         = 5.5e4;

    par.k1         = 3e6;
    par.k2         = 3e6;

    par.H1         = -5e4;
    par.H2         = -5.3e4;
    par.Hvap       = 5;

    par.alpha_a    = 2;
    par.alpha_b    = 1;
    par.alpha_c    = 1.5;
    par.alpha_d    = 3;

    par.MWA        = 50;
    par.MWB        = 50;
    par.MWC        = 50;

    par.Cp         = 0.231;
    par.R          = 8.314;
    par.rho        = 1000;

    par.xd         = 8.39e-4;

    % define equilibrium point
    par.x1s = [369.53; 3.31; 0.17; 0.04];
    par.x2s = [435.25; 2.75; 0.45; 0.11];
    par.x3s = [435.25; 2.88; 0.50; 0.12];

    par.Qs  = [0; 0; 0];

    % define the start point
    par.x10 = [360.69; 3.19; 0.15; 0.03];
    par.x20 = [430.91; 2.76; 0.34; 0.08];
    par.x30 = [430.42; 2.79; 0.38; 0.08];

    % define the scaling parameters
    par.sc_in  = 1e4; % input scaling
    par.sc_tem = 400; % temperature scaling
end