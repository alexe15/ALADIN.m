function [ alphaSQP ] = lineSearch( Mfun, x, delx)

 alphaSQP = 1;

% From central solution multipliers
muMeritMin  = 1e4;
% SQP like line search, not really working...
lineSSQP = true;
% ALADIN line search
ALADINLs = false;


%LINESEARCH Summary of this function goes here
%   Detailed explanation goes here

    % line search
if lineSSQP == true
%         % evaluate constraint violations for local problems
%         ctr = 1;
%         for j=1:NsubSys
%            ni    = length(yy{j});
%            xxFullS{j} = xx{j} + delx(ctr:(ctr+ni-1));
%            ctr   = ctr + ni;
%         end
%         
        % compute new \mu according to Nocedal eq. 18.36
        % sigma = 1 since HQP is always pos. def.
 %      muMeritMin = (vertcat(ggiEval{:})'*delx + 1/2*delx'*HQP*delx)/ ...
  %            ((1-0.05)*(norm(consViolIneq(consViol>0),1)+norm(consViolEq,1)));

        % compute new \mu according to multiplier, cf. Nocedal eq. 18.32       
%         if lamMeritNum < max(abs(lam))
%             lamMeritNum = max(abs(lam))*1.2;
%         end
%         if kappMeritNum < kappaMax
%             kappMeritNum = kappaMax*1.2;
%         end
    %     kappMeritNum
    %     lamMeritNum

        % plot merit function
    %     a = 0:0.01:1;
    %     f = zeros(length(a),1);
    %     for k=1:length(f)
    %         f(k)=full(Mfun(x + a(k)*delx,muMeritMin));
    %     end
    %     figure
    %     plot(a,f);
        % line search
      %  y = vertcat(yy{:});
        while full(Mfun(x,muMeritMin*1.1)) < full(Mfun(x + alphaSQP*delx,muMeritMin*1.1))
            % try 2nd order correction if no suff. decrease (Nocedal p.443)
%             if alphaSQP == 1
%                 constrLin     = [blkdiag(AAQPll{:}); A];
%                 constrFunEval = full(constrFun(x+delx));
%                 constrFunEval = [constrFunEval(~vertcat(iinact{:})); A*(x+delx)];
%                 delxHat       = sparse(-constrLin'*inv(constrLin*constrLin')*constrFunEval);
%                 a=full(Mfun(y,muMeritMin*1.1)) < full(Mfun(x + delx + delxHat,muMeritMin*1.1))
%             end
%             
            
            alphaSQP = alphaSQP*0.8;
            if alphaSQP < 1e-9;
                break;
            end
        end
        
            % lambda only for cons. constr,
  %      lam     = lam + alphaSQP*(lamges(1:Ncons) - lam);
    
        % lambda update for SQP like this?
    %       lam     = alphaM*lamges(1:Ncons);

        % lambda for linearized nonlinear constraints
    %     kapp    = lamges(Ncons+1:end); 
    %     temp    = 0;
    %     for j = 1:NsubSys
    %         Kiopt{j} = kapp(temp+1:temp+nngi{j});
    %         temp     = temp + size(AAQPll{j},1);
    %     end
    
        % update the local states
%         yyOld = yy;
%         ctr   = 1;
%         for j=1:NsubSys
%             ni    = length(yy{j});
%             yy{j} = xx{j} + alphaSQP*delx(ctr:(ctr+ni-1)); 
%             ctr   = ctr + ni;
%         end
%     elseif ALADINLs == true
%         gamma       = 1e-8;
%         % line search
%         x = vertcat(xx{:}); % local solutions
%         
%         % sufficient decrease by full step?
%         if full(Mfun(y,muMeritMin*1.1)) - full(Mfun(x + delx,muMeritMin*1.1)) > ...
%                 gamma*(rho/2*(x-y)'*blkdiag(Sig{:})*(x-y) + muMeritMin*1.1*norm(A*x,1))
%             
%             alpha1 = 1;
%             alpha2 = 1;
%             alpha3 = 1;
%             
%             % reset non-monotone counter
%             nonMonSteps = 0;
%             
%         % sufficient decrease only local step?
%         elseif full(Mfun(y,muMeritMin*1.1)) - full(Mfun(x,muMeritMin*1.1)) > ...
%                 gamma*(rho/2*(x-y)'*blkdiag(Sig{:})*(x-y) + muMeritMin*1.1*norm(A*x,1))
%             
%             % non-monotone strategy
%             if nonMonSteps == 0
%                 % save current iterate
%                 yySave   = yy;
%                 xxSave   = xx;
%                 delxSave = delx;
%                 lamSave  = lam;
%                 rhoSave  = rho;
%                 muSave   = mu;
%             end
%             
%             if nonMonSteps < 2
%                 alpha1 = 1;
%                 alpha2 = 1;
%                 alpha3 = 1;
%             else
%                 alpha1 = 1;
%                 alpha2 = 0;
%                 alpha3 = 0;
%                 
%                 nonMonSteps = -1;
%                 yy       = yySave;
%                 xx       = xxSave;
%                 delx     = delxSave;
%                 lam      = lamSave;
%                 rho      = rhoSave;
%                 mu       = muSave;
%             end
% 
%             nonMonSteps = nonMonSteps + 1;  
%         else
%              if nonMonSteps == 0
%             % save current iterate
%                 yySave   = yy;
%                 lamSave  = lam;
%                 rhoSave  = rho;
%                 muSave   = mu;
%              end
%             
%             if nonMonSteps < 2
%                 alpha1 = 1;
%                 alpha2 = 1;
%                 alpha3 = 1;
%             else
%                 alpha1 = 0;
%                 alpha2 = 0;
%                 alpha3 = 0;
%                 
%                  nonMonSteps = -1;
% %                 yy       = yySave;
% %                 xx       = xxSave;
% %                 delx     = delxSave;
% %                 lam      = lamSave;
% %                 rho      = rhoSave;
% %                 mu       = muSave;
%             end
%             nonMonSteps = nonMonSteps + 1;      
% 
%             %keyboard;
%             % increase rho?
% %             rho = rho*2;
%             
end
  
        % update
%         ctr   = 1;
%         for j=1:NsubSys
%             ni    = length(yy{j});
%             yy{j} = yy{j} + alpha1*(xx{j} - yy{j}) + alpha2*delx(ctr:(ctr+ni-1)); 
%             ctr   = ctr + ni;
%         end
%               
%         % lambda only for cons. constr,
%         lam     = lam + alpha3*(lamges(1:Ncons) - lam);
%     

end

