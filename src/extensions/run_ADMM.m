
function [ xopt, logg ] = run_ADMM( ffi,ggi,hhi,AA,yy0,llam0,llbx,...
                                                uubx,rho,Sig,opts )

NsubSys = length(ffi);
Ncons   = size(AA{1},1);


%% built local subproblems and CasADi functions
import casadi.*
rhoCas      = SX.sym('rho',1,1);
for i=1:NsubSys
    nx       = length(yy0{i});
    yyCas    = SX.sym('z',nx,1);
    xxCas    = SX.sym('x',nx,1);
    
    % local inequality constraints
    ggiCas  = ggi{i}(yyCas);
    hhiCas  = hhi{i}(yyCas);
    
    % output dimensions of local constraints
    nngi{i} = size(ggiCas,1);
    nnhi{i} = size(hhiCas,1);
                
    
    % set up bounds for equalities/inequalities
    lbg{i} = [zeros(nngi{i},1); -inf*ones(nnhi{i},1)];
    ubg{i} = zeros(nngi{i}+nnhi{i},1);
    
    % symbolic multipliers
    lamCas   = SX.sym('lam',Ncons,1);
    
    % parameter vector of CasADi
    pCas        = [ rhoCas;
                    lamCas;
                    xxCas];
                
    if opts.scaling == true
        % scaled version for consensus
        ffiLocCas = ffi{i}(yyCas) + lamCas'*AA{i}*yyCas ...
            + rhoCas/2*(yyCas - xxCas)'*Sig{i}*AA{i}'*AA{i}*(yyCas - xxCas);
    else
            % objective function for local NLP's
        ffiLocCas = ffi{i}(yyCas) + lamCas'*AA{i}*yyCas ...
                + rhoCas/2*(AA{i}*(yyCas - xxCas))'*(AA{i}*(yyCas - xxCas));
    end

    % set up local solvers
    nlp     = struct('x',yyCas,'f',ffiLocCas,'g',[ggiCas; hhiCas],'p',pCas);
    nnlp{i} = nlpsol('solver','ipopt',nlp);

end

%% build H and A for ctr. QP
A   = horzcat(AA{:});

HQP = [];
for i=1:NsubSys
   HQP = blkdiag(HQP, rho*AA{i}'*AA{i});
   % scaled version
  % HQP = blkdiag(HQP, rho*AA{i}'*Sig{i}*AA{i});
end
% regularization only for components not involved in consensus and
% project them back on x_k
gam   = 1e-3;
L     = diag(double(~sum(abs(A))));
HQP   = HQP + gam*L'*L;



% replacement with Identity matrix should also gain ADMM according to Yuning
% 
nx  = size(horzcat(AA{:}),2);
% HQP = eye(nx);

%% ALADIN iterations
logg            = struct();
logg.X          = [];
logg.Z          = [];
logg.lambda     = [];
logg.Kappa      = [];
logg.KappaEq    = [];
logg.KappaIneq  = [];
 logg.maxNLPt   = 0;

% initialization
i       = 1;
yy      = yy0;
xx      = yy0;
x       = vertcat(xx{:});
llam    = llam0;

while i<=opts.maxIter% && norm(delx,inf)>eps   
    for j=1:NsubSys
        % set up parameter vector for local NLP's
        pNum = [ rho;
                 llam{j};
                 xx{j}];
                                   
        tic     
        % solve local NLP's
        sol = nnlp{j}('x0' , yy{j},...
                      'p',   pNum,...
                      'lbx', llbx{j},...
                      'ubx', uubx{j},...
                      'lbg', lbg{j}, ...
                      'ubg', ubg{j});           
        logg.maxNLPt    = max(logg.maxNLPt, toc );          
        
                                    
        yy{j}           = full(sol.x);
        kapp{j}         = full(sol.lam_g);
        
        % multiplier update
%              llam{j} = llam{j} + 1e3*AA{j}*(yy{j}-xx{j}); 
  %      llam{j} = llam{j} + rho*AA{j}*(yy{j}-xx{j});
              
        KioptEq{j}      = kapp{j}(1:nngi{j});
        KioptIneq{j}    = kapp{j}(nngi{j}+1:end);
    end
    % gloabl x vector
    y = vertcat(yy{:});

         
    % Solve ctr. QP
    hQP_T=[];
    for j=1:NsubSys
       hQP_T  = [hQP_T -rho*yy{j}'*AA{j}'*AA{j}-llam{j}'*AA{j}];
    end
    hQP   = hQP_T';
    AQP   = A;
    bQP   = zeros(size(A,1),1);
    
%     % regularization, because some states aren't involved in the solution
%     HQP   = HQP + eye(size(HQP,1))*1e-9;    
%     

    % advanced regularization to avoid changing solution 
    % eigenvalue decomposition of the hessian
%     [V,D]       = eig(full(HQP));
%     e           = diag(D);              
%     % modify zero eigenvalues (regularization)
%     % (large regularization doesn't matter here since these entries do not enter the
%     % local problems anyway due to multiplication with Ai)
%     e(e<=1e-3)   = 1e-3; % 1e-4
%     HQP  = V*diag(e)*transpose(V);
%     xOld = x;
    
    
    % regularization only for components not involved in consensus and
    % project them back on x_k
    hQP   = hQP - gam*L'*L*y;
    
    % solve QP
    [x, ~] = solveQP(HQP,hQP,AQP,bQP,'linsolve');
    
    % solve by identity replacement, no ill-condiiotning for large rho
%    [x, ~] = solveQP(eye(nx),y,A,zeros(size(A,1),1),'linsolve');
    % alternatively solve by averaging
%    x2 = (x+y)/2;


    
    % divide into subvectors
    ctr = 1;
    for j=1:NsubSys
        ni          = length(xx{j});
        xx{j}       = x(ctr:(ctr+ni-1)); 
        ctr = ctr + ni;
    end
    
    % lambda update after z update
    for j = 1:NsubSys
         llam{j} = llam{j} + rho*AA{j}*(yy{j}-xx{j}); 
    end
    
        
    % rho update rule for ISEO paper

    % Erseghe update parameter is 1.025 and starts with 2 fort IEEE 57?
    if opts.rhoUpdate == true
        %rho = rho*1.01;
        
        % update rule according to Guo 17 from remote point
        if norm(A*x,inf) > 0.9*norm(A*xOld,inf) && i > 1
            rho = rho*1.025;
        end
    end
    
    i = i+1;
    
    % logging
    logg.X          = [logg.X y];
    logg.Z          = [logg.Z x];
    logg.lambda     = [logg.lambda vertcat(llam{:})];
    logg.Kappa      = [logg.Kappa vertcat(kapp{:})];
    logg.KappaEq    = [logg.KappaEq vertcat(KioptEq{:})];
    logg.KappaIneq  = [logg.KappaIneq vertcat(KioptIneq{:})];
end
% Comment: The solution y of the local NLP's is used, because not all
% decision variables are considered in the global QP. Because of the
% regualrization step, they are set to zero what makes the solution
% unusable.
xopt = y;

disp(['Max NLP time:            ' num2str(logg.maxNLPt) ' sec'])

end

