function [ lam0 ] = computeLambdaInit( input_args )
%COMPUTELAMBDAINIT Summary of this function goes here
%   Detailed explanation goes here

%%%%%%%%% not working yet, just a code copy! %%%%%%%%%
% has to be transfromed to a proper function

%% lambda estimation procedure by Niels
% Jacobian of equality constraints for lambda estimation
JacEqCas = jacobian(gCas,yCas);   
JacFun   = Function('EqJac',{yCas},{JacEqCas});

lambdaInit = 0;
if lambdaInit == 1
    grad0 = [];

    for i=1:NsubSys
        % gradient at initial point
        grad0 = [grad0; ggradi{i}(zz0{i},zeros(nnhi{i}+nngi{i},1))];
    end
    % compute multiplier estimate assuming zero mutlipliers for
    % nonlinear constraints bases on 1st order nec. condition
%     lam0 = -grad0'*A'*inv(A*A');
    % yields zero multipliers...
    
    % try with kappa = ones() guess
    lam0 = -((grad0' +  ones(1,size(JacEqCas,1))*JacFun(vertcat(zz0{:})))*A'*inv(A*A'))';
end
 
%% lambda initialization by SQP step
% start with SQP step to improve convergence
% (equivalent to original ALADIn as it can be considered just as a 
% different initialization...)

SQPinit = false;
if SQPinit == true   
    % kappa initialization
    for j=1:NsubSys
        kapp0{j} = ones(nnhi{j}+nngi{j},1);
    end    
    
    for j=1:NsubSys
        % active set detection
        inact           = [false(nngi{j},1); hhi{j}(zz0{j})<opts.actMargin];
        AQPlli          = full(JJhi{j}(zz0{j}));
        AAQPll{j}       = sparse(AQPlli(~inact,:)); % eliminate inactive entries       
        
        HHiEval{j}      = HHi{j}(zz0{j},kapp0{j},opts.rho0);
        ggiEval{j}      = ggradi{j}(zz0{j},zeros(length(kapp0{j}),1));
    end

    rhsQP1  = -A*vertcat(zz0{:});      
    AQPll   = blkdiag(AAQPll{:});
    gQPs    = sparse(vertcat(ggiEval{:},lam0));
    HQP     = blkdiag(HHiEval{:});
    HQPs            = blkdiag(HQP,opts.mu0*eye(Ncons)); 

    Nhact   = size(AQPll,1);
    AQP     = [A -eye(Ncons);AQPll zeros(Nhact,Ncons)];
    bQP     = sparse([rhsQP1;zeros(Nhact,1)]);
    
    % solve QP
    [delx0, lam0full] = solveQP(sparse(HQPs),gQPs,AQP,bQP,opts.solveQP,Nhact,i);    
    
    % update lambda and x
    lam0 = lam0full(1:Ncons);
    
    ctr = 1;
%     for j=1:NsubSys
%            ni    = length(yy0{j});
%            yy0{j} = yy0{j} + delx0(ctr:(ctr+ni-1)); 
%            ctr   = ctr + ni;
%     end
    % ends up with 0 initialization for multipliers...
end



end

