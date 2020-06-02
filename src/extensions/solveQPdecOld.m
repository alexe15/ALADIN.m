function [ x, lam, maxComm, lamRes ] = solveQPdecOld( HH, CC, gg, AA, xx, lam, mu, iter, alg )
NsubSys = size(HH,2);
Ncons   = size(AA{1},1);

maxComm = 0;
%% local precomputation
for i=1:NsubSys
   % augmented Lagrangian approach for C and A (to avoid regularization)
   aug = 'false';
   if strcmp(aug,'true')  
        HH{i} = HH{i} + AA{i}'*AA{i};
        gg{i} = gg{i} - AA{i}'*AA{i}*xx{i};
   end
   % local nullspace method   
   ZZ{i}    = null(full(CC{i}));
   HHred{i} = ZZ{i}'*(full(HH{i}))*ZZ{i};
   
   % regularization if needed
   [V,D]            = eig(full(HHred{i}));
   e                = diag(D);
    
   if min(e) < 1e-6
       e(abs(e)<1e-4)   = 1e-4;
       % flip the eigenvalues 
       HHred{i} = V*diag(e)*transpose(V);
       keyboard
   end

   AAred{i} = AA{i}*ZZ{i};
   ggred{i} = ZZ{i}'*full(gg{i});
   
   % Schur-complement
   HHredInv{i} = inv(HHred{i});
   SS{i}       = AAred{i}*HHredInv{i}*AAred{i}';
   
   rrhs{i}     = AAred{i}*HHredInv{i}*ggred{i};
   rrhsNoSl{i} = AA{i}*xx{i} - AAred{i}*HHredInv{i}*(ggred{i});
   AAx{i}      = AA{i}*xx{i};

   % maximum communication overhead
   maxComm = maxComm + nnz(diag(SS{i})) + nnz(SS{i}-diag(diag(SS{i})))/2 + nnz(rrhs{i});
   
end
SSslack     = (1/mu)*eye(Ncons);

%% solution of LES
S0      = zeros(Ncons);
Ax      = zeros(Ncons,1);
rhs0    = zeros(Ncons,1);
rhsNoSl = zeros(Ncons,1);
for i=1:NsubSys
    S0      = S0   + SS{i};
    Ax      = Ax   + AAx{i};
    rhs0    = rhs0 + rrhs{i};
    rhsNoSl = rhsNoSl + rrhsNoSl{i};
end
S = - S0 - SSslack;
rhs = rhs0 - (1/mu)*lam;

rhsS =  -Ax + rhs;

% solve LES
u = S\rhsS;
% 
% %% solve via ADMM without slack
% % solution without slack 
% uNoSl  = (S0+SSslack)\(rhsNoSl + (1/mu)*lam); % uNoSl
% 

%% run with default ADMM
% for i=1:NsubSys
%    ff{i} = @(x)0.5*x'*(SS{i} + 1/(NsubSys)*SSslack)*x - x'*(rrhsNoSl{i} +1/(NsubSys*mu)*lam);
%    AAadm{i} = zeros(Ncons*(NsubSys-1),Ncons);
%    if i==1
%        AAadm{i}(1:Ncons,1:Ncons)                  =   eye(Ncons);
%    elseif i==NsubSys
%        AAadm{i}(end-Ncons+1:end,end-Ncons+1:end)  =  -eye(Ncons);
%    else
%        AAadm{i}((i-2)*Ncons+1:i*Ncons,:)          = [-eye(Ncons); eye(Ncons)];     
%    end
%    Sig{i} = eye(Ncons);
%    yy0{i} = zeros(Ncons,1);
%    ll0{i} = zeros(Ncons*(NsubSys-1),1);
%    ggAdm{i}  = @(x) [];
%    hhAdm{i}  = @(x) [];
%    llbx{i}= -inf*ones(Ncons,1);
%    uubx{i}= inf*ones(Ncons,1);
% end
% 
% [lamADM, loggADM] = run_ADMM(ff,ggAdm,hhAdm,AAadm,yy0,ll0,llbx,uubx,0.001,Sig,100)
% 
% [lamADM(1:Ncons) u]

%% distributed ADMM

% find zero rows of Ai (check assignement)
Jc = cell(Ncons,1);
for i=1:NsubSys
    J{i} = find(~all(AA{i}==0,2));
    
    for j=1:Ncons
       if sum(J{i}==j)
          Jc{j} = [Jc{j} i];
       end
    end

    % set up slack matrices for LES
    ss{i}       = zeros(Ncons,1);
    ss{i}(J{i}) = 1/2;
end



if  strcmp(alg,'ADMM')
% initialize z_i and y_i
% rhoADM = 2e-2; %no preconditioning




prec = false;
if prec == true
    % SPAI preconditioning --> not working because non-symmetric...
%     [C{1:Ncons}] = deal(S);
%     E            = eye(Ncons);
%     Mcol         = linsolve(blkdiag(C{:}),E(:));
%     M            = reshape(Mcol,Ncons,Ncons); 
    
    % Jacobi preconditioner
    T = diag((1./diag(-S)).^0.5);
    
    % norm equilibration
    % U=inv(diag(sqrt(diag(S^2))))*S
else
    T = eye(Ncons);
end

% distributed
z = zeros(Ncons,1);
z = lam; %warmstart
[yy{1:NsubSys,1}] = deal(zeros(Ncons,1));
Z = [];
Rho=[];
rhoADM = 1e-1; % for robot example
for j = 1:iter
    zOld = z;
    
    for i=1:NsubSys
        xx{i} = inv(T'*(SS{i} + 1/mu*diag(ss{i}))*T + rhoADM*eye(Ncons))*(-yy{i} + rhoADM*z + T'*rrhsNoSl{i} + T'*1/mu*ss{i}.*lam );  
    end
%    z = 1/NsubSys*(sum([xx{:}]')');% + 1/rhoADM*sum([yy{:}]')');
    z = sum(([ss{:}].*[xx{:}])')';   
    for i=1:NsubSys
        yy{i} = yy{i} + rhoADM*(xx{i} - z);
    end
    
%     % rho update according to Boyd paper
%     r = norm(vertcat(xx{:}) - repmat(eye(Ncons),NsubSys,1)*z);
%     s = norm(rhoADM*repmat(eye(Ncons),NsubSys,1)*(z-zOld));
%     if r > muADM*s
%         rhoADM = rhoADM*tauADM;
%     elseif s > muADM*r
%         rhoADM = 1/tauADM*rhoADM;
%     end
%     
    Rho = [Rho rhoADM];
    Z   = [Z z];
end
u=z;
% 
%  figure
%  semilogy(max(abs(S*Z-repmat(rhsS,[1,size(Z,2)]))))
%loglog(max(abs(S*Z-rhsS)))

end








% %% conjugate gradient
% zC = lam;%zeros(Ncons,1); % warm start
% Zcg = [];
% rC = rhsS - S*zC;
% pC = rC;
% for j=1:1000
%     alphaC = rC'*rC/(pC'*S*pC);
%     zC    = zC + alphaC*pC;
%     rOld  = rC;
%     rC    = rOld - alphaC*S*pC;
%     betaC  = rC'*rC/(rOld'*rOld);
%     pC     = rC + betaC*pC;
%     % logg
%     Zcg = [Zcg zC];
% end
% 
% semilogy(max(abs(S*Zcg-rhsS)))

% sparsity figures
% figure
% for i=1:NsubSys
%     subplot(2,2,i)
%     spy(SS{i});
%     
%     set(gca,'xticklabel',{[]})
%     set(gca,'yticklabel',{[]})
%     delete(findall(findall(gcf,'Type','axe'),'Type','text'))
% end

%% distributed CG
if strcmp(alg,'CG')

C=J;

% check assignements an neighborhood
ass       = [];
[Neig{1:NsubSys}] = deal([]);
for i=1:NsubSys
    ass = [ass; sum(abs(AA{i}'))];
    
%     for j=1:NsubSys
%         if sum((abs(sum(abs(AA{1}'))~=0) + abs(sum(abs(AA{4}'))~=0))>1)>0
%             Neig{i} = [Neig{i} j];
%         end
%     end
end
for i=1:Ncons
    R{i} = find(ass(:,i));
end


% new local Schurs including slack
for i=1:NsubSys
    SSn{i} = - SS{i} - 1/mu*diag(ss{i});
    ssn{i} = - rrhsNoSl{i} - 1/mu*ss{i};
end


% distributed CG iterations

ZcgD = [];
zDistr  = lam;%zeros(Ncons,1); % warm start
rNew    = rhsS - S*zDistr; 
p       = rNew;
for j=1:iter
    ptSp = zeros(Ncons,1);
    rTr  = zeros(Ncons,1);
    % compute alpha components locally
    for i=1:Ncons
        Ss{i}   = [sparse(1,i,1,1,Ncons)*cellPlus({SSn{R{i}}})]';
        ptSp(i) = sparse(1,union(C{R{i}}),p(union(C{R{i}})),1,Ncons)*Ss{i}*p(i);
        rTr(i)  = rNew(i)^2;
    end
    % global sums
    ptSp  = sum(ptSp);
    rTr   = sum(rTr);
    alpha = rTr/ptSp;

    % local z and r updates
    rTr2  = zeros(Ncons,1);
    r     = rNew;
    for i=1:Ncons 
       zDistr(i) = zDistr(i) + alpha*p(i);
       rNew(i)   = r(i) - alpha*sparse(1,union(C{R{i}}),p(union(C{R{i}})),1,Ncons)*Ss{i};
       rTr2(i)   = rNew(i)^2;
    end
    % global sum
    rTr2   = sum(rTr2);
    beta   = rTr2/rTr;

    for i=1:Ncons
       p(i) = rNew(i) + beta*p(i);
    end
    
    % logg
    ZcgD = [ZcgD zDistr];
    
    % find NaNs in solution
    if sum(isnan(zDistr)) ~=0
        zDistr = ZcgD(:,end-1);
        break
        keyboard;
    end
end
% 
% figure
% semilogy(max(abs(S*ZcgD-repmat(rhsS,[1 size(ZcgD,2)]))))

u = zDistr;

end


% % compare with D-ADMM
%  nPlot = 100; 
% % set(0,'defaultTextInterpreter','latex');
%  figure 
%  resCG = max(abs(S*ZcgD-repmat(rhsS,[1 size(ZcgD,2)])));
%  semilogy(1:nPlot,resCG(:,1:nPlot))
% hold on
% resADM = max(abs(S*Z-repmat(rhsS,[1,size(Z,2)])));
% semilogy(1:nPlot,resADM(:,1:nPlot))
% legend('D-CG','D-ADMM')
% ylabel('$\|\tilde S\lambda^k-\tilde s\|_\infty$')
% xlabel('k')
% ylim([1e-15 1e3])
% xlim([1 100])


%% expand again locally
for i=1:NsubSys
    xxRed{i} = -HHredInv{i}*(ggred{i} + AAred{i}'*u);
    xx{i}    = ZZ{i}*xxRed{i};
    kkapp{i} = linsolve(full(CC{i})',full(gg{i}-HH{i}*ZZ{i}*xxRed{i} - AA{i}'*u(1:Ncons)));
    
    xxges{i} = [xx{i};kkapp{i}];
end

x   = vertcat(xx{:});
lam = u;


lamRes = S*u - rhsS;
% 
% %% distributed regularized ADMM
% for i=1:NsubSys
%    SSreg{i} = SS{i} + 1e-6*eye(Ncons);
% end
% 
% z = zeros(Ncons,1);
% [yy{1:NsubSys,1}] = deal(zeros(Ncons,1));
% Zreg = [];
% Rho=[];
% rhoADM = 1e0;
% for j = 1:1000
%     zOld = z;
%     
%     for i=1:NsubSys
%         xx{i} = inv(T'*(SS{i} + 0.11/j*eye(Ncons) + 1/mu*diag(ss{i}))*T + rhoADM*eye(Ncons))*(-yy{i} + rhoADM*z + T'*rrhsNoSl{i} + T'*1/mu*ss{i}.*lam );  
%     end
% %    z = 1/NsubSys*(sum([xx{:}]')');% + 1/rhoADM*sum([yy{:}]')');
%     z = sum(([ss{:}].*[xx{:}])')';   
%     for i=1:NsubSys
%         yy{i} = yy{i} + rhoADM*(xx{i} - z);
%     end
%     
% %     % rho update according to Boyd paper
% %     r = norm(vertcat(xx{:}) - repmat(eye(Ncons),NsubSys,1)*z);
% %     s = norm(rhoADM*repmat(eye(Ncons),NsubSys,1)*(z-zOld));
% %     if r > muADM*s
% %         rhoADM = rhoADM*tauADM;
% %     elseif s > muADM*r
% %         rhoADM = 1/tauADM*rhoADM;
% %     end
% %     
%     Rho    = [Rho rhoADM];
%     Zreg   = [Zreg z];
% end
% 
% 
% semilogy(max(abs(S*Z-rhsS)))
% hold on
% semilogy(max(abs(S*Zreg-rhsS)))
% legend('noReg','reg')
% 
% u=z;






%% centralized ADMM
% z = zeros(Ncons,1);
% [yy{1:NsubSys,1}] = deal(zeros(Ncons,1));
% 
% Z = [];
% for j = 1:1000
%     for i=1:NsubSys
%         xx{i} = inv(SS{i} + SSslack/(NsubSys) + rhoADM*eye(Ncons))*(-yy{i}+rhoADM*z + rrhsNoSl{i} +1/(NsubSys*mu)*lam );  
%     end
%     z = 1/NsubSys*(sum([xx{:}]')' + 1/rhoADM*sum([yy{:}]')');
%     for i=1:NsubSys
%         yy{i} = yy{i} + rhoADM*(xx{i} - z);
%     end
%     Z = [Z z];
% end
% 
% [u z lamADM(1:Ncons)]

%% gradient method
% stepS = 0.0001;
% 
% uGrad = rhsNoSl + (1/mu)*lam;
% for i=1:10000000
%     uGrad = uGrad - stepS*((S0+SSslack)*uGrad - (rhsNoSl + (1/mu)*lam));
% end
% % without stepsize control super shitty.... needs 100 million iters
% 
% 
% % with stepsize control
% uGrad = zeros(Ncons,1);
% for i=1:10000000
%     r = rhsNoSl + (1/mu)*lam -(S0+SSslack)*uGrad;
%     stepS = r'*r/(r'*(S0+SSslack)*r);
%     uGrad = uGrad + stepS*r;
% end

%[u uGrad]






%% MATLAB CG with different precondiitoners
% non-overlapping Jacobi preconditioning
% M = zeros (Ncons, Ncons); k = 8;
% for i = 1 : k : Ncons % form 1-D Laplacian matrix
% M(i:i+k-1, i:i+k-1) = S(i:i+k-1, i:i+k-1);
% end
% [x, flag, relres, iter, resvec] = pcg (S, rhsS,[],100,M);
% hold on
% semilogy (1:length(resvec), resvec./resvec(1));
% [x, flag, relres, iter, resvec] = pcg (S, rhsS,[],100,diag(diag(S)));
% hold on
% semilogy (1:length(resvec), resvec./resvec(1));



%%


    % solve QP blockwise via Schur complement (cf. Boyd p. 674)
    % regularization by A^\top*A for singular H
%     for i=1:NsubSys
%         % regularization with A and max value of 
%         
%         invHHi{i} = inv(sparse(HHiEval{i}+AA{i}'*AA{i}+eye(size(HHiEval{i},1))*norm(HHiEval{i},inf)*1e-6));
%         SS{i}     = -AA{i}*invHHi{i}*AA{i}';
%         rhsS{i}   = AA{i}*invHHi{i}*ggiEval{i};
%     end



