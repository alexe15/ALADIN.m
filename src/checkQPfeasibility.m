
    
    % check wether QP is infeasible    
    [res]   = mskqpopt(HQPs,gQPs,AQP,bQP,bQP,[vertcat(llbx{:}); -inf*ones(Ncons,1)],[vertcat(uubx{:}); inf*ones(Ncons,1)]);
    X = quadprog(HQPs,gQPs,[],[],AQP,bQP,[vertcat(llbx{:}); -inf*ones(Ncons,1)],[vertcat(uubx{:}); inf*ones(Ncons,1)])
    
    xopt    = res.sol.itr.xx;
    lam     = - res.sol.itr.y;
    
    
    % solve via inequality constrained QP solver to avoid active set
    % detection/inconsistent linearization issues
    
    [res]   = mskqpopt(HQPs,gQPs,AQP,bQP,bQP,[vertcat(llbx{:}); -inf*ones(Ncons,1)],[vertcat(uubx{:}); inf*ones(Ncons,1)]);
    xopt    = res.sol.itr.xx;
    lam     = - res.sol.itr.y;
    

  