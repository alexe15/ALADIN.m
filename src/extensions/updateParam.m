function [ SSig, newStep ] = updateParam(SSig, newStep, oldStep, type)
% increase Sigma entry, if constraint violation in certain direction 
% is not decreasing     


% choose update factors depending on whether it is S\Sigma or \Delta
if strcmp(type,'Del')
   dFac = 0.25; % according to Bertsekas sec 4.2.2
   iFac = 10;
   % maximum value for individual constraint penalization
   delMax = 1e7;
elseif strcmp(type,'Sig')
   dFac = 0.5; % according to Bertsekas sec 4.2.2
   iFac = 5;
   % maximum value for individual constraint penalization
   delMax = 1e5;
end 

% get all variables with not sufficiently decreasing stepsize
decFacs = abs(newStep./oldStep);
ind     = decFacs > dFac;

inFac      = ones(size(SSig,1),1);
inFac(ind) = iFac;

% increase corresponding entries by given factor
if strcmp(type,'Del')
    % inverse scaling for \Delta matrix
    SSig    = diag(max(diag(SSig.*(1./inFac)),1/delMax));
elseif strcmp(type,'Sig')
    SSig    = min(SSig.*inFac,delMax);
end 


end

