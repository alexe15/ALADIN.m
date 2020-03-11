% 2 mobile robots crossing problem
clear all;
clc;
close all;



% define robot models
ode = @(x,u) [ u(1)*cos(x(3));
               u(1)*sin(x(3));
               u(2)];   

%% set up OCP
import casadi.*
Nrobot = 2;

T   = 1;        % Time horizon
dT  = 0.1;      % sampling time
d   = 2;        % minimal distance between robots

N   = T/dT;
Nmpc = 40;

for i=1:Nrobot
    % inputs/states
    XX{i}  = SX.sym(['x' num2str(i)], [3 N]);
    % state copies
    for k=setdiff(1:Nrobot,i)
       ZZZ{i}{k} =  SX.sym(['z' num2str(i) num2str(k)], [3 N]);
    end
    UU{i}  = SX.sym(['u' num2str(i)], [2 N]);
    XX0{i} = SX.sym(['xx0' num2str(i)], [3 1]);
end
           

% starting points/destinations
%            from  to       
ppNum{1} = [ 0     10; 
             0     10
             0     0  ];
ppNum{2} = [ 10    0; 
             10    0;
             0     0  ];

% for each robot ...           
for i=1:Nrobot
    JJ{i}   = 0;
    gg{i}   = [];
    hh{i}   = [];
    llbu{i} = [];
    uubu{i} = [];

    % over horizon ...
    for j=1:N - 1
        % ode/stage cost with Heun discretization
        gg{i}      = [ gg{i}; XX{i}(:,j+1) - XX{i}(:,j) - dT*0.5*(ode(XX{i}(:,j),UU{i}(:,j))+ ode(XX{i}(:,j+1),UU{i}(:,j+1)))];
        JJ{i}      = JJ{i} + (XX{i}(:,j)-ppNum{i}(:,2))'*diag([1 1 0])*(XX{i}(:,j)-ppNum{i}(:,2)) ...
                           +  UU{i}(:,j)'*UU{i}(:,j);
        % distance constraint
        hh{i}  = [hh{i}; -(XX{i}(1:2,j)-ZZZ{i}{3-i}(1:2,j))'*(XX{i}(1:2,j)-ZZZ{i}{3-i}(1:2,j)) + d^2];
    end
    % initial condition
    gg{i} = [gg{i}; XX{i}(:,1) - XX0{i}];
end
        
for i=1:Nrobot
   ZZZ{i}{i} = XX{i};
   ZZZi      = vertcat(vertcat(ZZZ{i}{:}));
   UUi       = UU{i};
   XXU{i}    = [ ZZZi(:); UUi(:)];
end

% set up consensus constraints
Abase   = [ eye(Nrobot*N*3) zeros(Nrobot*N*3,2*N)];
zerBase = zeros(size(Abase));
for i=1:Nrobot-1
   AA{i}   =  [repmat(zerBase,i-1,1); Abase; repmat(zerBase,Nrobot-i-1,1)];
end
AA{Nrobot} = - repmat(Abase,Nrobot-1,1);

%% solve with ALADIN
% convert expressions to MATLAB functions
X0       = vertcat(XX0{:});
ppNumAll = [ppNum{1}(:,1); ppNum{2}(:,1)];

for i=1:Nrobot
    rob.locFuns.ffi{i} = Function(['f' num2str(i)],{XXU{i}},{JJ{i}});
    rob.locFuns.ggi{i} = Function(['g' num2str(i)],{[XXU{i};X0]},{gg{i}});
    rob.locFuns.hhi{i} = Function(['h' num2str(i)],{XXU{i}},{hh{i}});
    
    % set up ALADIN parameters
    rob.llbx{i}  = -inf*ones(length(XXU{i}),1);
    rob.uubx{i}  =  inf*ones(length(XXU{i}),1);
    rob.AA{i}    = AA{i};
    
    rob.zz0{i}   = [vec(DM(repmat(ppNumAll,1,N))); zeros(2*N,1)];
end

rob.lam0   = 0*ones(size(AA{1},1),1);
rob.p      = ppNumAll;
opts.plot  = 'false';
opts.reuse = 'true';
opts.maxiter  = 50;
opts.term_eps = 1e-8;

Xopt  = ppNumAll;
for i = 1:Nmpc
    sol_rob{i} = run_ALADINnew(rob,opts);
    Xopti = [];
    for j = 1:Nrobot
        Xopti = [Xopti; full(sol_rob{i}.xxOpt{j}(3*(Nrobot+j-1)+(1:3)))];
    end
    Xopt = [Xopt, Xopti];
%     xx0  = [repmat(Xopt(:,i+1),N,1); zeros(2*N,1)];
%     rob.zz0 = {xx0,xx0};
    rob.zz0 = sol_rob{i}.xxOpt;
    rob.p = Xopt(:,i+1);
    rob.reuse = sol_rob{1}.reuse;
end



%% plotting
figure();
h1 = animatedline('Color','r');
h2 = animatedline('Color','r');
grid on
box on

for k = 1:Nmpc+1
    addpoints(h1,Xopt(1,k),Xopt(2,k));
    addpoints(h2,Xopt(4,k),Xopt(5,k));

    pause(0.1)
    drawnow
end        

% draw circle for distance constraint
pos = [4 4 d d];
rectangle('Position',pos,'Curvature',[1 1])
axis equal



