function [ SSig, newStep ] = computeDynSig(SSig, newStep, oldStep)
% increase Sigma entry, if constraint violation in certain direction 
% is not decreasing     

% maximum value for individual constraint penalization
delMax = 1e7;

% stop if maximum Sigma reached
if max(diag(SSig)) < 1e5

    dFac = 0.25; % according to Bertsekas sec 4.2.2
    iFac = 5;

    % get all variables with not sufficiently decreasing stepsize
    decFacs = abs(newStep./oldStep);
    ind     = decFacs > dFac;

    inFac      = ones(size(SSig,1),1);
    inFac(ind) = iFac;
    
    % increase corresponding entries by given factor
    
    SSig    = min(SSig.*inFac,delMax);
else
    newStep = [];
end
end

