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
[locFuns.f, locFuns.g, locFuns.h] = deal(ffi, ggi, hhi);

% convert MATLAB functions to CasADi functions 
[ locFunsCas, xxCas ]  = mFun2casFun(locFuns, zz0, opts);

% create local solvers and sensitivities
[ nnlp, sens, gBounds ] = createLocalSolvers( locFunsCas, AA, xxCas, Sig, opts );

% set up a merit function for line search
[ Mfun ]                = createMfun(locFunsCas, xxCas, AA, opts );

% lambda initialization for better convergence?
lamInit = false;
if lamInit == true
    lam0 = computeLambdaInit(locFuns);
end

disp(['Problem setup: ' num2str(toc(setupT)) ' sec'])
%% ALADIN iterations
initializeVariables


iterTime = tic;
i   = 1;
rho = opts.rho0;
mu  = opts.mu0;
while i <= opts.maxiter
    obj             = 0;
    for j=1:NsubSys
        % solve local problems
        
        % set up parameter vector for local NLP's
        pNum = [ rho;
                 lam;
                 yy{j}];
                                 
        % solve local NLP's
        tic
        sol = nnlp{j}('x0' ,    xx{j},...
                      'lam_g0', Kiopt{j},...
                      'lam_x0', LLam_x{j},...
                      'p',      pNum,...
                      'lbx',    llbx{j},...
                      'ubx',    uubx{j},...
                      'lbg',    gBounds.lb{j}, ...
                      'ubg',    gBounds.ub{j});              
        xiopt           = full(sol.x);        
        KKapp{j}        = full(sol.lam_g);
        LLam_x{j}       = full(sol.lam_x);
        
        NLPtotTime      = NLPtotTime + toc;            
        disp(['Solve NLP ' num2str(j) ': ' num2str(toc) ' sec'])                    
   
        % active set detection
        inact           = [false(nngi{j},1); locFuns.h{j}(xiopt)<opts.actMargin];
        KKapp{j}(inact) = 0;
        
        
        % evaluate gradients and hessians for the QP
        tic
        HHiEval{j}      = sens.H{j}(xiopt,KKapp{j},rho);
        ggiEval{j}      = sens.g{j}(xiopt);
        ggiLagEval{j}   = sens.gL{j}(xiopt,KKapp{j});
        if i>1
            ggiLagEvalOld{j} =  sens.gL{j}(xxOld{j},KKapp{j});
        end
        disp(['Evaluate sensitivities in subproblem ' num2str(j) ': ' num2str(toc) ' sec'])

        % regularization of the local hessians
        tic
        if strcmp(opts.reg,'true')
            HHiEval{j} = regularizeH(HHiEval{j});
        end
        disp(['Regularization in ' num2str(j) ': ' num2str(toc) ' sec'])
        RegTotTime      = RegTotTime + toc;
        
        % log the jacobians and values of hi
        % lower left component of AQP
        AQPlli          = full(sens.Jac{j}(xiopt));    

        % eliminate inactive entries  
        AAQPll{j}       = sparse(AQPlli(~inact,:));      
        % Jacobian of active bounds
        JacBounds = eye(size(xiopt,1));
        % eliminate inactive entries
        JacBounds         = JacBounds((llbx{j}-xiopt)> opts.actMargin | (xiopt-uubx{j})>opts.actMargin,:);
        AAQPllNoBounds{j} = AAQPll{j};
        AAQPll{j}         = [AAQPll{j}; JacBounds];         
        
       
        xx{j}           = xiopt;
        xxOptCas{j}     = sol.x;
        Kiopt{j}        = KKapp{j};
        KioptEq{j}      = KKapp{j}(1:nngi{j});
        KioptIneq{j}    = KKapp{j}(nngi{j}+1:end);
             
        % logg consensus violation, objective value and gradient 
        consViol        = full(sol.g);
        consViolEq      = [consViolEq; consViol(1:nngi{j})];
        iinact{j}       = inact;
        
        % maximal multiplier for inequalities
        kappaMax        = max(abs(KKapp{j}));
    end
    x = vertcat(xx{:});
    
    rhsQP1  = -A*x;      
    
    % built the QP
    AQPll   = blkdiag(AAQPll{:});
    gQPs    = sparse(vertcat(ggiEval{:},lam));

    
    % use BFGS updates insread?
    BFGS = false;
    if BFGS==true
        run(BFGS_AL);
    else
        HQP             = blkdiag(HHiEval{:});
    end

    % use fixed Hessian to improve convergence?
    fixHess = false;
    if fixHess == true
        % fix Hessian in the beginning to improve convergence?
        if i < 100
            HQP = 1000000000*eye(size(HQP,1));
        end
    end
    
    HQPs            = blkdiag(HQP,mu*eye(Ncons)); 
    xOld            = vertcat(xx{:});
%     ggiLagEvalOld   = ggiLagEval;
    xxOld           = xx;

    % number of active inequalities
    Nhact   = size(AQPll,1);
    AQP     = [A -eye(Ncons);AQPll zeros(Nhact,Ncons)];
    bQP     = sparse([rhsQP1;zeros(Nhact,1)]); 
    
    % check whether QP is feasible?
    checkFeas = false;
    if checkFeas==true
       run(checkQPfeasibility );
    end
    
    % solve global QP
    tic
    redQP = false;
    if redQP==true
        % reduced QP via Schur complement?
        [delx, lamges] = solveQPdistr2(HHiEval,AAQPll,ggiEval,AA,xx,lam,mu);
    else
        % standard ALADIN QP
        [delxs2, lamges] = solveQP(HQPs,gQPs,AQP,bQP,opts.solveQP,Nhact,i);  
         delx             = delxs2(1:(end-Ncons)); 
    end
    disp(['Solve QP: ' num2str(toc) ' sec'])
    QPtotTime        = QPtotTime + toc;   
   
    % do a line search?
    linS = false;
    if linS == true
        stepSize = lineSearch(Mfun, x, y);
    end
    
    % no line search
    ctr   = 1;
    yOld = vertcat(yy{:});
    for j=1:NsubSys
        ni    = length(yy{j});
        yy{j} = yy{j} + 1*(xx{j} - yy{j}) + 1*delx(ctr:(ctr+ni-1)); 
        ctr   = ctr + ni;
    end
    lam     = lam + 1*(lamges(1:Ncons) - lam);
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
    p = true; 
    if p == true  
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

