function [ Hreg ] = regularizeH( H )
%REGULARIZEH Summary of this function goes here
%   Detailed explanation goes here
        
            % eigenvalue decomposition of the hessian
            [V,D]       = eig(full(H));
            e           = diag(D);
            
%             % alternative approach: add smalles eigenvalue
%             e           = e + max(0,-min(e)) + 1e-6; 
%            
%             
            
            % flip the eigenvalues 
            e           = abs(e);            
            
 
            % modify zero and too large eigenvalues (regularization)
            reg         = 1e-4;
            e(e<=reg)   = reg; % 1e-4
          
%             alternative Moritz approach: not flipping but small constrant
%             reg         = 1e-2;
%             e(e<reg)    = reg; % 1e-4

  
                        
            % e = e + 1e-4*ones(size(HHiEval{j},1),1))            
%             HHiEval{j}  = V*diag(e)*transpose(V);
            % Regularization for small stepsize
            Hreg  = V*diag(e)*transpose(V);% + 1e-1*(0.2^i)*blkdiag(Sig{j})%;eye(length(e));
            
            
            % Q and V ragularouzation in centralized step?
            if j < 100
%                nxj         = size(Sig{j},1);
%                  HHiEval{j}  = sparse(HHiEval{j} + 1*0.5^i*blkdiag(zeros(nxj/4),eye(nxj/4),zeros(nxj/4),10*eye(nxj/4)));
%                  HHiEval{j}  = sparse(HHiEval{j} + 1/(1.1^i)*2*blkdiag(zeros(nxj/4),0*eye(nxj/4),zeros(nxj/4),10*eye(nxj/4)));

%                 HHiEval{j}  = sparse(HHiEval{j} + blkdiag(1/(1.1^i)*10*zeros(3*nxj/4),1/(1.1^i)*20*eye(nxj/4)));
%               HHiEval{j}  = HHiEval{j} + 1/(1.05^i)*100*Sig{j};
            end

end

