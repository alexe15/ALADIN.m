function [ cond ] = condenseLocally(sProb, iter)
%CONDENSELOCALLY Summary of this function goes here
%   Detailed explanation goes here
NsubSys = length(sProb.llbx);
Ncons   = size(sProb.AA{1},1);

% reducespace/Schur complement locally
Gam = zeros(Ncons);
for i=1:NsubSys
   % local nullspace method   
   ZZ{i}    = null(full(iter.loc.sensEval.JJacCon{i}));
   HHred{i} = ZZ{i}'*full(iter.loc.sensEval.HHiEval{i})*ZZ{i};
   
   % regularization if needed
   [V,D]            = eig(full(HHred{i}));
   e                = diag(D);
    
   if min(e) < 1e-6
       e(abs(e)<1e-4)   = 1e-4;
       % flip the eigenvalues 
       HHred{i} = V*diag(e)*transpose(V);
       keyboard
   end

   AAred{i} = sProb.AA{i}*ZZ{i};
   ggred{i} = ZZ{i}'*full(iter.loc.sensEval.ggiEval{i});
   
   % Schur-complement
   HHredInv{i} = inv(HHred{i});
   SS{i}       = AAred{i}*HHredInv{i}*AAred{i}';
   
   rrhs{i}     = AAred{i}*HHredInv{i}*ggred{i};
   %rrhsNoSl{i} = sProb.AA{i}*iter.yy{i} - AAred{i}*HHredInv{i}*(ggred{i});
   % wrong version!!! 
   rrhsNoSl{i} = sProb.AA{i}*iter.loc.xx{i} - AAred{i}*HHredInv{i}*(ggred{i});
   
   
   rrhs{i}     = AAred{i}*HHredInv{i}*ggred{i};
   
   
   %AAx{i}      = sProb.AA{i}*iter.yy{i};   
   % wrong version!!! 
 %  AAx{i}      = sProb.AA{i}*iter.loc.xx{i};   
   
   % compute sets \mathcal C(i)
   cond.C{i} = find(~all(sProb.AA{i}==0,2));

   % set up matric I_\mathcal{C}
   IC{i} = [];
   for j=1:length(cond.C{i})
       rw = zeros(1,Ncons);
       rw(cond.C{i}(j)) = 1;
       IC{i} = [IC{i}; rw];
   end
   
   % set up \Gamma
   Gam = Gam + IC{i}'*IC{i};
end

for i=1:NsubSys
    % set up coupling matrices I_\mathcal{C}*I_\mathcal{C}^\top
    for j=1:NsubSys
        Icc{i,j} = IC{i}*IC{j}';
    end 
    % compute \Gamma_i
    GGam{i} = IC{i}*Gam*IC{i}';
  
    % new local Schurs including slack
    SSn{i} = SS{i} + 1/iter.stepSizes.mu*IC{i}'*inv(GGam{i})*IC{i};
    ssn{i} = rrhsNoSl{i} + 1/iter.stepSizes.mu*IC{i}'*inv(GGam{i})*IC{i}*iter.lam; 
    
    % compute reduced Schur \hat S_i
    hS{i}  = IC{i}*SSn{i}*IC{i}'; 
    hs{i}  = IC{i}*ssn{i}; 
end

cond.IC    = IC;
cond.Icc   = Icc;
cond.GGam  = GGam;
cond.hS    = hS;
cond.hs    = hs;


cond.AAred    = AAred;
cond.HHredInv = HHredInv;
cond.ZZ       = ZZ;
cond.ggred    = ggred;

end

