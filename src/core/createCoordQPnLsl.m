function [ HQP, gQP, AQP, bQP] = createCoordQPnLsl( sens, gBounds )
%CREATECOORDQPNLSL Summary of this function goes here
%   Detailed explanation goes here
KKT = [ HQP       mu*JacCon'          A' ;
        JacCon   -eye(Nhact)          zeros(Nhact, Ncons);
        A         zeros(Ncons,Nhact)  zeros(Ncons)];

rhs = [ -vertcat(ggiEval{:}) - A'*lam; 
         zeros(Nhact,1);
         0 - A*x];
end

