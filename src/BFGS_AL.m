%     gQPLag  = full(vertcat(ggiLagEval{:}));
    
%     gQPLagOld = []; % gradient at old point with new multiplier
%     if i > 1
%         for j=1:NsubSys
%             gQPLagOld   =  [gQPLagOld; full(ggradi{j}(xxOld{j},Kiopt{j}))];
%         end
%     end
    
%     % BFGS update without slack vars
%     if i==1
% %        HQP  = eye(length(x));
%        HQP     = full(blkdiag(HHiEval{:}));  
%     else
%         % slack variables have to be checked in update
% %         HQP  = BFGS(HQP,gQPLag,gQPLagOld,vertcat(xx{:}),xOld,'DAMPED'); 
%             % BFGS after centralized step
%             HQP  = BFGS(HQP,gQPLag,gQPLagOld,vertcat(xx{:}),xOld,'DAMPED'); 
%     end
%     


    % Block BFGS (BFGS for each subsystem)
%     if i==1
%         for j=1:NsubSys
%             HHQP{j} = full(HHiEval{j});
%         end
%     else
%         for j=1:NsubSys
%             HHQP{j} = BFGS(HHQP{j},ggiLagEval{j},ggiLagEvalOld{j},xx{j},xxOld{j},'DAMPED');
%         end
%     end
%     % Hessian including slacks
%     HQP  = blkdiag(HHQP{:});