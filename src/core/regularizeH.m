% Eigenvalue modification of the Hessian in case of negative curvature 
% (cf. chapter 3.4 of Nocedal and Wright)

function [ Hreg, didReg ] = regularizeH( H, opts )        
            % eigenvalue decomposition of the hessian
%             [V,D]       = eig(full(H));
%             e           = diag(D);
%             
% %             % alternative approach: add smalles eigenvalue
% %             e           = e + max(0,-min(e)) + 1e-6; 
%             didReg = false;
%             if min(e) < 0
%                didReg = true; 
%             end
%             
%             % flip the eigenvalues 
%             e           = abs(e);            
%  
%             % modify zero and too large eigenvalues (regularization)
%             reg         = opts.regParam;
%             e(e<=reg)   = reg; % 1e-4
%           
%             % Regularization for small stepsize
%             Hreg  = real(V*diag(e)*V');
%% modified symmetric indefinite factorization
%  (cf. chapter 3.4 of Nocedal and Wright)
%
            [L,B,P,S]   = ldl(H);
            [V,D]     = eig(full(B));
            lambda    = diag(D);
            reg       = opts.regParam;
            if min(lambda)<reg
                didReg    = true;
                s         = diag(S);
                R         = diag(1./s);
                f         = zeros(size(lambda));                       
%                 E         = sparse(size(H));
                f(lambda<reg)  = reg - lambda(lambda<reg);   
                F         = V*diag(f)*V';
                E         = R*P*L*F*L'*P'*R;
            else
                didReg = false;
                E         = zeros(size(H));
            end
            Hreg =H+E;
end

