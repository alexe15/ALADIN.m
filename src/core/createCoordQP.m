function [ HQPs, gQPs, AQP, bQP] = createCoordQP( sProb, iter )
%CREATECOORDQP Summary of this function goes here
    % set up coordination QP including slacks 
    Ncons    = size(sProb.AA{1},1);
    
    A        = [sProb.AA{:}];
    
    rhsQP    = -A*vertcat(iter.loc.xx{:});     
    
    HQP      = blkdiag(iter.loc.sensEval.HHiEval{:});
    
    HQPs     = blkdiag(HQP,iter.stepSizes.mu*eye(Ncons)); 
    JacCon   = blkdiag(iter.loc.sensEval.JJacCon{:});
    
    % check condition number of constraints
    if cond(full(JacCon)) > 1e8
       keyboard 
    end
    
    Nhact    = size(JacCon,1);
    AQP      = [A -eye(Ncons);JacCon zeros(Nhact,Ncons)];
    bQP      = sparse([rhsQP;zeros(Nhact,1)]); 
    
    gQPs     = sparse(vertcat(iter.loc.sensEval.ggiEval{:},iter.lam));  
    
    % check whether QP is feasible?
    checkFeas = false;
    if checkFeas==true
       run( checkQPfeasibility );
    end  
end

