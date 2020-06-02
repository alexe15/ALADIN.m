function [ HQP, gQP, AQP, bQP ] = createCoordQP( sProb, iter, opts )
%CREATECOORDQP Summary of this function goes here
    % set up coordination QP including slacks 
    NsubSys = length(sProb.AA);
    Ncons   = size(sProb.AA{1},1);
    if strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none')
        % reduced space method with slacks       
        HQP =   [ blkdiag(iter.loc.sensEval.HHred{:}),   horzcat(iter.loc.sensEval.AAred{:})';
                  horzcat(iter.loc.sensEval.AAred{:}), - opts.Del];
        gQP = - [ - vertcat(iter.loc.sensEval.ggred{:});
                  - [sProb.AA{:}]*vertcat(iter.loc.xx{:}) + sProb.b  ...
                                           - opts.Del*iter.lam];


        AQP = [];
        bQP = [];
        
    elseif strcmp(opts.innerAlg, 'none')
        % full space method
        A        = [sProb.AA{:}];

        rhsQP    = -A*vertcat(iter.loc.xx{:}) + sProb.b;     

        HQP      = blkdiag(iter.loc.sensEval.HHiEval{:});

        %HQP     = blkdiag(HQP,iter.stepSizes.mu*eye(Ncons)); 
        HQP     = blkdiag(HQP, diag(1./diag(opts.Del))); 
     
        JacCon   = blkdiag(iter.loc.sensEval.JJacCon{:});

        % check condition number of constraints
        if cond(full(JacCon)) > 1e8
   %        keyboard 
        end

        Nhact    = size(JacCon,1);
        AQP      = [A -eye(Ncons);JacCon zeros(Nhact,Ncons)];
        bQP      = sparse([rhsQP;zeros(Nhact,1)]); 
        gQP      = sparse(vertcat(iter.loc.sensEval.ggiEval{:},iter.lam));  

        
        % check whether QP is feasible?
        checkFeas = false;
        if checkFeas==true
           run( checkQPfeasibility );
        end  
        
    end

end

