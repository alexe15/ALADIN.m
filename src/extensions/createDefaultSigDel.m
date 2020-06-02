function [SSig , Del] = createDefaultSigDel( sProb, opts )
% compute default \Sigma and \Delta  matrices. 
NsubSys = length(sProb.zz0);

for i=1:NsubSys
    if isfield(opts, 'SSig')
        SSig{i} = opts.SSig{i};
    else
        SSig{i} = eye(size(sProb.zz0{i},1));
    end
end

if strcmp(opts.alg,'ALADIN')
    Del = (1/opts.mu0)*eye(size(sProb.AA{1},1));
else
    Del = zeros(size(sProb.AA{1},1));
end
end

