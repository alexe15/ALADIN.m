function [ SSig, newStep ] = computeDynSig(SSig, y, x, oldStep)
% increase Sigma entry, if constraint violation in certain direction 
% is not decreasing     

% stop if maximum Sigma reached
if max(diag(SSig)) < 1e5
    newStep = y-x;

    dFac = 0.5; % according to Bertsekas sec 4.2.2
    iFac = 2;

    % get all variables with not sufficiently decreasing stepsize
    decFacs = abs(newStep./oldStep);
    ind     = decFacs > dFac;

    inFac      = ones(size(SSig,1),1);
    inFac(ind) = iFac;
    % increase corresponding entries by given factor

        SSig    = SSig.*inFac;
else
    newStep = [];
end
end

