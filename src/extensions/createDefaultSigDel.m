function [SSig , Del] = createDefaultSigDel( sProb )
% compute default \Sigma and \Delta  matrices. 
NsubSys = length(sProb.zz0);

for i=1:NsubSys
    SSig{i} = eye(size(sProb.zz0{i},1));
end

Del = 100*eye(size(sProb.AA{1},1));

end

