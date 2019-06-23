% Eigenvalue modification of the Hessian in case of negative curvature 
% (cf. chapter 3.4 of Nocedal and Wright)

function [ Hreg ] = regularizeH( H )        
            % eigenvalue decomposition of the hessian
            [V,D]       = eig(full(H));
            e           = diag(D);
            
%             % alternative approach: add smalles eigenvalue
%             e           = e + max(0,-min(e)) + 1e-6; 
            
            % flip the eigenvalues 
            e           = abs(e);            
            
 
            % modify zero and too large eigenvalues (regularization)
            reg         = 1e-4;
            e(e<=reg)   = reg; % 1e-4
          
%             alternative Moritz approach: not flipping but small constant
%             reg         = 1e-2;
%             e(e<reg)    = reg; % 1e-4

            % Regularization for small stepsize
            Hreg  = V*diag(e)*transpose(V);% + 1e-1*(0.2^i)*blkdiag(Sig{j})%;eye(length(e));

end

