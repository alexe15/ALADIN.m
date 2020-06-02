% Solves an optimization problem via ADMM
%
% in:  sProb and opts struct containing a problem formulation in 
%      affinely-coupled separable form and solver options
% out: Struct containig optimal primal/dual solution and logging
%      information
%
% Checkout https://alexe15.github.io/ALADIN.m/ for detailed information.
% We use the ADMM variant  from 
%
% Houska, B., Frasch, J., & Diehl, M. (2016). An augmented Lagrangian 
% based algorithm for distributed nonconvex optimization. SIAM Journal 
% on Optimization, 26(2), 1101-1127.
function [ solADM ] = run_ADMM(sProb, opts)

import casadi.*
opts.alg   = 'ADMM';

NsubSys = length(sProb.AA);
AA      = sProb.AA;
Ncons   = size(AA{1},1);


% set constraints to empty functions/default initial guess
sProb      = setDefaultVals(sProb);

% set default options
opts       = setDefaultOpts(sProb, opts);

%% built local subproblems and CasADi functions
% timers
totTimer   = tic;
setupTimer = tic;

rhoCas      = SX.sym('rho',1,1);
for i=1:NsubSys
    nx       = length(sProb.zz0{i});
    iter.yyCas    = SX.sym('z',nx,1);
    iter.loc.xxCas    = SX.sym('x',nx,1);
    
    % local inequality constraints
    sProb.locFunsCas.ggi{i}  = sProb.locFuns.ggi{i}(iter.yyCas);
    sProb.locFunsCas.hhi{i}  = sProb.locFuns.hhi{i}(iter.yyCas);
    
    % output dimensions of local constraints
    nngi{i} = size(sProb.locFunsCas.ggi{i},1);
    nnhi{i} = size(sProb.locFunsCas.hhi{i},1);
                
    
    % set up bounds for equalities/inequalities
    lbg{i} = [zeros(nngi{i},1); -inf*ones(nnhi{i},1)];
    ubg{i} = zeros(nngi{i}+nnhi{i},1);
    
    % symbolic multipliers
    lamCas   = SX.sym('lam',Ncons,1);
    
    % parameter vector of CasADi
    pCas        = [ rhoCas;
                    lamCas;
                    iter.loc.xxCas];
                
    if opts.scaling == true
        % scaled version for consensus
        ffiLocCas = sProb.locFuns.ffi{i}(iter.yyCas) + lamCas'*AA{i}*iter.yyCas ...
            + rhoCas/2*(iter.yyCas - iter.loc.xxCas)'*Sig{i}*AA{i}'*AA{i}*(iter.yyCas - iter.loc.xxCas);
    else
            % objective function for local NLP's
        ffiLocCas = sProb.locFuns.ffi{i}(iter.yyCas) + lamCas'*AA{i}*iter.yyCas ...
                + rhoCas/2*(AA{i}*(iter.yyCas - iter.loc.xxCas))'*(AA{i}*(iter.yyCas - iter.loc.xxCas));
    end

    % set up local solvers
    nlp       = struct('x',iter.yyCas,'f',ffiLocCas,'g',[sProb.locFunsCas.ggi{i}; sProb.locFunsCas.hhi{i}],'p',pCas);
    nnlp{i}   = nlpsol('solver',opts.locSol,nlp);

end
timers.setupT = toc(setupTimer);


%% build H and A for ctr. QP
A   = horzcat(AA{:});

HQP = [];
for i=1:NsubSys
   HQP = blkdiag(HQP, opts.rho0*AA{i}'*AA{i});
   % scaled version
  % HQP = blkdiag(HQP, rho*AA{i}'*Sig{i}*AA{i});
end
% regularization only for components not involved in consensus and
% project them back on x_k
gam   = 1e-3;
L     = diag(double(~sum(abs(A),1)));
HQP   = HQP + gam*L'*L;

% replacement with Identity matrix should also gain ADMM according to Yuning
nx  = size(horzcat(AA{:}),2);
% HQP = eye(nx);

%% ADMM iterations
% initialization
initializeVariables

i                   = 1;
iter.yy             = sProb.zz0;
[llam{1:NsubSys}]   = deal(sProb.lam0);
iterTimer           = tic;
while i <= opts.maxiter% && norm(delx,inf)>eps   
    for j = 1:NsubSys
        % set up parameter vector for local NLP's
        pNum = [ opts.rho0;
                 llam{j};
                 iter.yy{j}];
                                   
        tic     
        % solve local NLP's
        sol = nnlp{j}('x0' , iter.yy{j},...
                      'p',   pNum,...
                      'lbx', sProb.llbx{j},...
                      'ubx', sProb.uubx{j},...
                      'lbg', lbg{j}, ...
                      'ubg', ubg{j});           
        timers.NLPtotTime = timers.NLPtotTime + toc;   
                                    
        iter.loc.xx{j}  = full(sol.x);
        kapp{j}         = full(sol.lam_g);
        
        % multiplier update
  %      llam{j} = llam{j} + rho*AA{j}*(iter.yy{j}-iter.loc.xx{j});
              
        KioptEq{j}      = kapp{j}(1:nngi{j});
        KioptIneq{j}    = kapp{j}(nngi{j}+1:end);
    end
    % gloabl x vector
    x = vertcat(iter.loc.xx{:});

         
    % Solve ctr. QP
    hQP_T=[];
    for j=1:NsubSys
       hQP_T  = [hQP_T -opts.rho0*iter.loc.xx{j}'*AA{j}'*AA{j}-llam{j}'*AA{j}];
    end
    hQP   = hQP_T';
    AQP   = A;
    bQP   = zeros(size(A,1),1);    
    
    % regularization only for components not involved in consensus and
    % project them back on x_k
    hQP   = hQP - gam*L'*L*x;
    
    % solve QP
    tic
    [y, ~] = solveQP(HQP,hQP,AQP,bQP,opts.solveQP);
    timers.QPtotTime      = timers.QPtotTime + toc; 
    
    % divide into subvectors
    ctr   = 1;
    iter.yyOld = iter.yy;
    for j=1:NsubSys
        ni          = length(iter.yy{j});
        iter.yy{j}       = y(ctr:(ctr+ni-1)); 
        ctr = ctr + ni;
    end
    
    % lambda update after z update
    for j = 1:NsubSys
         llam{j} = llam{j} + opts.rho0*AA{j}*(iter.loc.xx{j}-iter.yy{j}); 
    end
    

    % Erseghe update parameter is 1.025 and starts with 2 fort IEEE 57?
    if strcmp(opts.rhoUpdate,'true')
        %rho = rho*1.01;
        
        % update rule according to Guo 17 from remote point
        if norm(A*x,inf) > 0.9*norm(A*xOld,inf) && i > 1
            rho = rho*1.025;
        end
    end
    
    % logging of variables?
    loggFl = true;
    if loggFl == true
        logValues;
    end
            
    % plot iterates?
    if strcmp(opts.plot,'true') 
        tic
        plotIterates;
        timers.plotTimer = timers.plotTimer + toc;
    end
    
    i = i+1;
end
timers.iterTime = toc(iterTimer);

% total time
timers.totTime  = toc(totTimer);
sol.timers = timers;

% display solver output and timing
dispSummary(opts.maxiter, opts, iter);
displayTimers(timers, opts);

solADM.logg   = iter.logg;
solADM.xxOpt  = iter.loc.xx;
solADM.lamOpt = llam;

end

