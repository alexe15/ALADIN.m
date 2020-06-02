% Eigenvalue modification of the Hessian in case of negative curvature 
% (cf. chapter 3.4 of Nocedal and Wright)

function [ Hreg, didReg ] = regularizeH( H, opts )        
            % eigenvalue decomposition of the hessian
            [V,D]       = eig(full(H));
            e           = diag(D);
            
%             % alternative approach: add smalles eigenvalue
%             e           = e + max(0,-min(e)) + 1e-6; 
            didReg = false;
            if min(e) < 0
               didReg = true; 
            end
            
            % flip the eigenvalues 
            e           = abs(e);            
 
            % modify zero and too large eigenvalues (regularization)
            reg         = opts.regParam;
            e(e<=reg)   = reg; % 1e-4
          
            % Regularization for small stepsize
            Hreg  = real(V * diag(e) * V');

end

