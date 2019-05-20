function [ xopt, lam, eigH, rankLEQS_ex ] = solveQP( H, g, A, b, solver,Nhact, i )
if strcmp(solver, 'ipopt')
    % regularization
%     if rank(H) ~=1
%        H =  H + 1e-6*eye(size(H,1));
%     end
    
    % check for pos. def of reduced hessian
    if min(eig(null(A)'*H*null(A))) < 1e-6
%       keyboard; 
       % eigenvalue decomposition of the hessian
       [V,D] = eig(full(H));
       
       d = diag(D);
       d(diag(D)<0) = d(diag(D)<0) + abs(min(d)) +1e-3;
       D = diag(d);
       
       % flip the eigenvalues 
       H  = V * abs(D) *transpose(V);
    end
    
    % setting of qp solver
    opts.print_time = 0;
    opts.ipopt.print_level = 0;
    
%     opts.ipopt.acceptable_tol = 1e-12;
%     opts.ipopt.acceptable_compl_inf_tol = 1e-12;
%     opts.ipopt.acceptable_constr_viol_tol = 1e-12;
%     opts.ipopt.acceptable_iter = 0;

    import casadi.*

    neq = size(A,1);
    nx  =  size(H,1);
    x   =   SX.sym('x',nx,1);
    f   =   0.5*x'*H*x+g'*x;
    gc  =   A*x-b;
    nlp =   struct('x',x,'f',f,'g',gc);
    cas =   nlpsol('solver','ipopt',nlp, opts);
    sol =   cas('lbx', -inf*ones(nx,1),...
            'ubx',  inf*ones(nx,1),...
            'lbg', zeros(neq,1), ...
            'ubg', zeros(neq,1));
    xopt =   full(sol.x);
    lam  =   full(sol.lam_g);            
end


if strcmp(solver, 'pinv')
    %SOLVEQP2 Solves a QP by 1st order necessary KKT condition
    neq = size(A,1);
    nx  = size(H,1);
%      
%     if min(eig(H))<0
%        keyboard 
%     end
%     


    LEQS_A  =   [H A';
                 A zeros(neq)];
    LEQS_B  =   [-g; b];

    LEQS_x  = pinv(LEQS_A)*LEQS_B;


    if sum(isnan(LEQS_x)) > 0 % regularization if no solution
      LEQS_A    = LEQS_A + 1*abs(min(eig(LEQS_A)))*eye(size(LEQS_A))+1e-3;

      LEQS_x  = linsolve(LEQS_A,LEQS_B);
    end


    xopt    = LEQS_x(1:nx);
    lam     = LEQS_x((nx+1):end); 
    eigH    = eig(H);
    rankLEQS_ex = rank([LEQS_A LEQS_B]);
end


if strcmp(solver, 'linsolve')
    %SOLVEQP2 Solves a QP by 1st order necessary KKT condition
    neq = size(A,1);
    nx  = size(H,1);
     
    
%     % regularization for nonregular LEQS_A's
%     if det(LEQS_A)<=1e-1
%        LEQS_A    = LEQS_A + 1*abs(min(eig(LEQS_A)))*eye(size(LEQS_A))+1e-3;
%     end
%     if min(eig(H))<0
%        keyboard 
%     end
    
    LEQS_A  =   [H A';
                 A zeros(neq)];
    LEQS_B  =   [-g; b];
    
    LEQS_x  = linsolve(LEQS_A,LEQS_B);
    
    

    if sum(isnan(LEQS_x)) > 0 % regularization if no solution
      LEQS_A    = LEQS_A + 1*abs(min(eig(LEQS_A)))*eye(size(LEQS_A))+1e-3;

      LEQS_x  = linsolve(LEQS_A,LEQS_B);
    end


    xopt    = LEQS_x(1:nx);
    lam     = LEQS_x((nx+1):end); 
    eigH    = []; %eig(H); % takes a lot of time...
    rankLEQS_ex = []; %rank([LEQS_A LEQS_B]);
end


if strcmp(solver, 'sparseBs')
    %SOLVEQP2 Solves a QP by 1st order necessary KKT condition
    neq = size(A,1);
    nx  = size(H,1);
     
    
    % sparse solution
    LEQS_As = sparse([H A';
                      A zeros(neq)]);
    LEQS_Bs = sparse([-g; b]);
    LEQS_xs = LEQS_As\LEQS_Bs;
    


    if sum(isnan(LEQS_xs)) > 0 % regularization if no solution
      LEQS_As    = LEQS_As + 1*abs(min(eig(LEQS_As)))*eye(size(LEQS_As))+1e-3;

      LEQS_xs  = linsolve(LEQS_As,LEQS_Bs);
    end


    xopt    = LEQS_xs(1:nx);
    lam     = LEQS_xs((nx+1):end); 
    eigH    = []; %eig(H); % takes a lot of time...
    rankLEQS_ex = []; %rank([LEQS_A LEQS_B]);
end



if strcmp(solver, 'MA57')
    % the MATLAB ldl() command uses MA57
    neq = size(A,1);
    nx  = size(H,1);
     
    
    % sparse solution
    LEQS_As = [H A';
                      A zeros(neq)];
    
    LEQS_Bs = [-g; b];
    
    % constraint regularization (Parameter from IPOPT paper)
    reg = false;
    if reg == true
        LEQS_As(end-Nhact+1:end,end-Nhact+1:end) = -1e-8*eye(Nhact);
    end
   
    [L, D, P] = ldl(LEQS_As);
    LEQS_xs = P*(L'\(D\(L\(P'*LEQS_Bs))));    

    xopt    = LEQS_xs(1:nx);
    lam     = LEQS_xs((nx+1):end); 
    eigH    = []; %eig(H); % takes a lot of time...
    rankLEQS_ex = []; %rank([LEQS_A LEQS_B]);
    
end



if strcmp(solver, 'MOSEK')
    [res]   = mskqpopt(H,g,A,b,b,[],[]);
    xopt    = res.sol.itr.xx;
    lam     = - res.sol.itr.y;
end





if strcmp(solver, 'quadprog')
    % introduced lb,ub, to avoid indefiniteness of H (is apprpriate,
    % because the QP is only a local approx. of the lagrangian, which can
    % lead to indefiniteness. But it not necessary means that the
    % lagrangian is unboubounded.
    nx   =  size(H,1);
%     opt = optimoptions('quadprog','Algorithm','interior-point-convex');
    opt = optimoptions('quadprog','Algorithm','active-set');
    [xopt,~,~,~,lam_str]=...
        quadprog(H,g,[],[],A,b,-10*ones(nx,1),10*ones(nx,1),[],opt);
    lam  = lam_str.eqlin;
end


    % solve QP via CasADi --> copy code to runAL as CasADi variables are
    % used!
%     HQPsCas   = blkdiag(blkdiag(HHiEval{:}),mu*eye(Ncons));
%     gQPsCas   = vertcat(ggiEval{:},lam);
%     AQPCas    = [  A -eye(Ncons);blkdiag(AAQPllCas{:}) zeros(Nhact,Ncons)];
%     bQPCas    = [ -A*vertcat(xxOptCas{:});zeros(Nhact,1)];
%     KKTcas    = [ HQPsCas  AQPCas'
%                   AQPCas   zeros(size(AQPCas,1))];
%     rhsCas    = [-gQPsCas; bQPCas];
% 
%     QPsol     = Linsol('QPsol','lapacklu',KKTcas.sparsity());
%     QPsol.solve(KKTcas,rhsCas)
%     
      


