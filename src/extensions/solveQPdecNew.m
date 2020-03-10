function [ lam, Lam, comm ] = solveQPdecNew( cond, lamOld, opts )
NsubSys = length(cond.C);
Ncons   = size(cond.IC{1},2);

% compute consistent initialization 
s = zeros(Ncons,1);
S = zeros(Ncons,1);
for i=1:NsubSys
    s = s + cond.IC{i}'*cond.hs{i};
    S = S + cond.IC{i}'*cond.hS{i}*cond.IC{i};
end

for i=1:NsubSys
    % use warm start for speedup
    if strcmp(opts.warmStart, 'true')
        % D-CG
        lam{i}  = cond.IC{i}*lamOld;
        r{i}    = cond.IC{i}*(s - S*lamOld); 
        p{i}    = r{i};

        % D-ADMM
        gam{i}  = cond.IC{i}*zeros(Ncons,1); 
        lamB{i} = lam{i};
    else 
        % D-CG
        lam{i}  = zeros(size(cond.IC{i},1),1);
        r{i}    = cond.IC{i}*s; 
        p{i}    = r{i};

        % D-ADMM
        gam{i}  = cond.IC{i}*zeros(Ncons,1); 
        lamB{i} = zeros(size(cond.IC{i},1),1);
    end
end



%% D-CG
if strcmp(opts.innerAlg,'D-CG')
    
    % compute eta initialization
    for i=1:NsubSys
        eta{i} = r{i}'*inv(cond.GGam{i})*r{i};
        u{i}   = cond.hS{i}*p{i};
        sig{i} = p{i}'*cond.hS{i}*p{i};
    end

    etaG = sum(cell2mat(eta));

    % D-CG iter
    LamCG = [];
    for n = 1:opts.innerIter
       % global sum
       sigG = sum(cell2mat(sig));

       % n-n step
       for i=1:NsubSys
           sumr = 0;
           for j=1:NsubSys
              sumr = sumr + cond.Icc{i,j}*u{j};
           end
           r{i} = r{i} - etaG/sigG*sumr;
       end  

       % local
       for i=1:NsubSys
           etaP{i} = r{i}'*inv(cond.GGam{i})*r{i};
           lam{i}  = lam{i} + etaG/sigG*p{i};
       end

       % global sum 
       etaGP = sum(cell2mat(etaP));

       % local
       for i=1:NsubSys
           p{i}   = r{i} + etaGP/etaG*p{i};
           u{i}   = cond.hS{i}*p{i};
           sig{i} = p{i}'*cond.hS{i}*p{i};
       end
       etaG = etaGP;

       % logg
       logg = false;
       if logg == true 
           llam = zeros(Ncons,1);
           for i=1:NsubSys
              llam = llam + cond.IC{i}'*inv(cond.GGam{i})*lam{i};
           end
           LamCG = [ LamCG llam ];
       end
    end
    lamB = lam;
    
end

%% D-ADMM
% precompute inverse of (\hat S_i + \rho I)
if strcmp(opts.innerAlg,'D-ADMM')
rhoADM = opts.rhoADM;

for i=1:NsubSys
   hSinv{i} = inv(cond.hS{i} + rhoADM*eye(size(cond.IC{i},1)));
end

LamADM = [];
for n = 1:opts.innerIter
    % local minimization
    for i=1:NsubSys
        lam{i} = hSinv{i}*(cond.hs{i} - gam{i} + rhoADM*lamB{i});
    end
    
    % averaging step
    for i=1:NsubSys
        % for all neighbors
        locSum = zeros(size(cond.IC{i},1),1);
        for j=1:NsubSys
            locSum = locSum + cond.Icc{i,j}*lam{j};
        end
        lamB{i} = inv(cond.GGam{i})*locSum;
    end

    % local multiplier update
    for i=1:NsubSys
        gam{i}  = gam{i} + rhoADM*(lam{i} - lamB{i});
    end
    
    % logg
    logg = true;
    if logg == true
        llam = zeros(Ncons,1);
        for i=1:NsubSys
           llam = llam + cond.IC{i}'*inv(cond.GGam{i})*lam{i};
        end
        LamADM = [ LamADM llam ];
    end
end

%figure
%semilogy(max(abs(S*LamADM-repmat(s,[1,size(LamADM,2)]))))

end

%% combine to one big \lambda
% taking x or z makes a huge difference in bi-level AL convergence!!!
Lam = zeros(Ncons,1);
for i=1:NsubSys
  Lam = Lam + cond.IC{i}'*inv(cond.GGam{i})*lamB{i}; % *lam{i}
end


%% communication count
% count local communication by counting the 1s in Icc
for i = 1:NsubSys
    % neighbor-neighbor communication not counting self-elements
    comm.nn{i} = ones(1,opts.innerIter)* ...
                   (sum(sum([cond.Icc{i,:}])) - sum(sum([cond.Icc{i,i}])));
    if strcmp(opts.innerAlg,'D-CG')
        comm.globF.globSum{i} = ones(1,opts.innerIter)*2;
    elseif strcmp(opts.innerAlg,'D-ADMM')
        comm.globF.globSum{i} = zeros(1,opts.innerIter);
    end
end




%% C-CG
% rC   = s;
% pC   = rC;
% lamC = zeros(size(pC,1),1);
% for i=1:100
%    alphaC = rC'*rC/(pC'*S*pC);
%    lamC   = lamC + alphaC*pC;
%    roldC  = rC;
%    rC     = rC - alphaC*S*pC;
%    betaC  = rC'*rC/(roldC'*roldC);
%    pC     = rC + betaC*pC;
% end
% 


%% plotting
% s = zeros(Ncons,1);
% S = zeros(Ncons);
% for i=1:NsubSys
%     s = s + cond.IC{i}'*cond.hs{i};
%     S = S + cond.IC{i}'*cond.hS{i}*cond.IC{i};
% end
% 
% figure
% semilogy(max(abs(S*LamCG-repmat(s,[1,size(LamCG,2)]))))
% hold on
% semilogy(max(abs(S*LamADM-repmat(s,[1,size(LamADM,2)]))))
%loglog(max(abs(S*Z-rhsS)))






