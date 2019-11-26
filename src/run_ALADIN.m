% Solves a non-convex optimization problem in consensus form via the ALADIN
% algorithm
%
% in:  ffi:    Cell with local objective functions fi
%      hhi:    Cell with local inequality constraints hi
%      ggi:    Cell with local equality constraints gi
%      AA:     Cell with consensus matrices Ai
%
% out: xopt:   Optimal x vector
%      logg:   Struct, logging several values during the iteration process
%%------------------------------------------------------------------------
function [ xopt, logg ] = run_ALADIN( ffi,ggi,hhi,AA,zz0,...
                                    lam0,llbx,uubx,Sig,opts )
import casadi.*
opts.sym    = @SX.sym;
NsubSys     = length(AA);
Ncons       = size(AA{1},1);
A           = [AA{:}];

%% problem setup 
totTime = tic;
setupT  = tic;

% collect local functions in struct
[ locFuns.f, locFuns.g, locFuns.h ] = deal(ffi, ggi, hhi);

% convert MATLAB functions to CasADi functions 
[ locFunsCas, xxCas ]   = mFun2casFun(locFuns, zz0, opts);

% create local solvers and sensitivities
[ nnlp, sens, gBounds ] = createLocalSolvers( locFunsCas, AA, xxCas, opts );

% set up a merit function for line search
[ Mfun ]                = createMfun(locFunsCas, xxCas, AA, opts );

% lambda initialization for better convergence?
lamInit = false;
if lamInit == true
    lam0 = computeLambdaInit(locFuns);
end

disp(['Problem setup: ' num2str(toc(setupT)) ' sec'])

%% ALADIN iterations

% pre_initialization
nngi = {};
nnhi = {};
HHiEval_ = cell(NsubSys, 1);


initializeVariables

iterTime = tic;
i       = 1;
rho     = opts.rho0;
mu      = opts.mu0;
while ( (i <= opts.maxiter) & ((~logical(opts.term_eps)) | (logg.consViol >= opts.term_eps))  )
    % solve local problems
    parfor j=1:NsubSys % parfor???
        % set up parameter vector for local NLP's
        pNum = [ rho;
                 lam;
                 yy{j}];
                                 
        % solve local NLP's
        tic
        if strcmp(opts.Sig,'const')
        sol = nnlp{j}('x0' ,    xx{j},...
                      'lam_g0', KKapp{j},...
                      'lam_x0', LLam_x{j},...
                      'p',      [pNum; Sig{j}(:)],...
                      'lbx',    llbx{j},...
                      'ubx',    uubx{j},...
                      'lbg',    gBounds.lb{j}, ...
                      'ubg',    gBounds.ub{j});          
%         else
%             % compute Hessian at y for scaling
%             if i > 1
%                 tmp         = ones(nngi{j} + nnhi{j},1);
%                 tmp(~inact) = kapp;
%                 HHiEval{j}  = sens.H{j}(yy{j},tmp,rho);
%                 HHiEval{j}  = regularizeH(HHiEval{j});
%             else
%                 HHiEval = Sig;
%             end
%             
%             sol = nnlp{j}('x0', xx{j},...
%                       'lam_g0', KKapp{j},...
%                       'lam_x0', LLam_x{j},...
%                       'p',      [pNum; HHiEval{j}(:)],...
%                       'lbx',    llbx{j},...
%                       'ubx',    uubx{j},...
%                       'lbg',    gBounds.lb{j}, ...
%                       'ubg',    gBounds.ub{j});          
        end
        % collect variables 
        [ xx{j}, KKapp{j}, LLam_x{j} ] = deal(full(sol.x), full(sol.lam_g), full(sol.lam_x));
        
        NLPtotTime      = NLPtotTime + toc;            
        disp(['Solve NLP ' num2str(j) ': ' num2str(toc) ' sec'])                    
   
        % primal active set detection
        inact           = logical([false(nngi{j},1); full(locFuns.h{j}(xx{j}) < opts.actMargin)]);
        KKapp{j}(inact) = 0;
        
        % evaluate gradients and Hessians of the local problems
        tic
        HHiEval{j}      = sens.H{j}(xx{j},KKapp{j},rho);
        ggiEval{j}      = sens.g{j}(xx{j});
        disp(['Evaluate sensitivities in subproblem ' num2str(j) ': ' num2str(toc) ' sec'])

        % regularization of the local hessians
        tic
        if strcmp(opts.reg,'true')
            [HHiEval{j}, didReg ] = regularizeH(HHiEval{j});
        end
        disp(['Regularization in ' num2str(j) ': ' num2str(toc) ' sec'])
        RegTotTime      = RegTotTime + toc;
        
        % compute the Jacobian of nonlinear constraints/bounds
        JacCon          = full(sens.Jac{j}(xx{j}));    
        JacBounds       = eye(size(xx{j},1));
        
        % eliminate inactive entries  
        JJacCon{j}      = sparse(JacCon(~inact,:));      
        JacBounds       = JacBounds((llbx{j}-xx{j})> opts.actMargin | (xx{j}-uubx{j})>opts.actMargin,:);
        JJacCon{j}      = [JJacCon{j}; JacBounds];         
        
        % logg consensus violation, objective value and gradient 
        consViol        = full(sol.g);
        consViolEq      = [consViolEq; consViol(1:nngi{j})];
        iinact{j}       = inact;
        
        % maximal multiplier for inequalities
        kappaMax        = max(abs(KKapp{j}));
        
        HHiEval_{j} = HHiEval{j};
    end %end of parfor
    
     % line search on the local step
    linSloc = false;
    if linSloc == true
        alphaLoc = lineSearch(Mfun, vertcat(yy{:}), vertcat(xx{:}) - vertcat(yy{:}) );
    else
        alphaLoc = 1;
    end
    alphaLoc
    
    
    % set up coordination QP including slacks 
    x        =  vertcat(yy{:}) + alphaLoc*(vertcat(xx{:}) - vertcat(yy{:}));
    rhsQP    = -A*x;     
    
 
    % set up the Hessian of the coordination QP
    if strcmp(opts.Hess,'BFGS')
        run(BFGS_AL);
    elseif strcmp(opts.Hess,'fix')
         % fix Hessian in the beginning to improve convergence?
        if i < 100
            HQP = 1000000000*eye(size(HQP,1));
        end
    else
        HQP = blkdiag(HHiEval_{:});
    end
    HQPs     = blkdiag(HQP,mu*eye(Ncons)); 

    
    JacCon   = blkdiag(JJacCon{:});
    
    % check condition number of constraints
    if cond(full(JacCon)) > 1e8
       keyboard 
    end
    
    Nhact    = size(JacCon,1);
    AQP      = [A -eye(Ncons);JacCon zeros(Nhact,Ncons)];
    bQP      = sparse([rhsQP;zeros(Nhact,1)]); 
    
    gQPs     = sparse(vertcat(ggiEval{:},lam));  
    
    % check whether QP is feasible?
    checkFeas = false;
    if checkFeas==true
       run( checkQPfeasibility );
    end    
    
    % solve coordination QP
    tic
    if strcmp(opts.innerAlg, 'full')
        [delxs2, lamges] = solveQP(HQPs,gQPs,AQP,bQP,opts.solveQP,Nhact);    
        delx             = delxs2(1:(end-Ncons)); 
        kapp             = full(delxs2(size(HQP,1)+1:end-Ncons ));
    elseif  strcmp(opts.innerAlg, 'nonlSlack')
        KKT = [ HQP       mu*JacCon'          A' ;
                JacCon   -eye(Nhact)          zeros(Nhact, Ncons);
                A         zeros(Ncons,Nhact)  zeros(Ncons)];
            
        rhs = [ -vertcat(ggiEval{:}) - A'*lam; 
                 zeros(Nhact,1);
                 0 - A*x];
        
        solTot = KKT\rhs;
        
        delx   = full(solTot(1:size(HQP,1)));
        lamges = full(solTot(end-Ncons+1:end));
        kapp   = full(solTot(size(HQP,1)+1:end-Ncons ));
    else
        [delx, lamges, maxComS, lamRes] = solveQPdec(HHiEval_,JJacCon, ...
                    ggiEval,AA,xx,lam,mu,opts.innerIter,opts.innerAlg);
    end
    disp(['Solve QP: ' num2str(toc) ' sec'])
    QPtotTime        = QPtotTime + toc;   
   
    % do a line search?
    linS = false;
    if linS == true
        alpha = lineSearch(Mfun, x ,delx);
    else
        alpha = 1;
    end
  
    
    % compute the QP step
    ctr   = 1;
    yOld = vertcat(yy{:});
    for j=1:NsubSys
        ni    = length(yy{j});
        yy{j} = yy{j} + 1*(xx{j} - yy{j}) + alpha*delx(ctr:(ctr+ni-1)); 
        ctr   = ctr + ni;
    end
    lam     = lam + alpha*(lamges(1:Ncons) - lam);
    y = vertcat(yy{:});
    i = i+1;

   
    % rho update
    if rho < opts.rhoMax && rho > 90
        rho=rho*opts.rhoUpdate;
    end
    % mu update
    if mu < opts.muMax
       mu = mu*opts.muUpdate;
    end
    
    % logging of variables?
    loggFl = true;
    if loggFl == true
        logValues;
    end
   
    % plot iterates?
    if opts.plot == true
       plotIterates;
    end
end
xopt = vertcat(xx{:});

disp(['Total ALADIN time:   ' num2str(toc(totTime)) ' sec'])
disp(['Only iterations:     ' num2str(toc(iterTime)) ' sec'])
disp(['NLP total time:      ' num2str(NLPtotTime) ' sec'])
disp(['QP total time:       ' num2str(QPtotTime) ' sec'])
disp(['Regularization time: ' num2str(RegTotTime) ' sec'])

end