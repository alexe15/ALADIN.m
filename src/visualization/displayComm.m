function [ ] = displayComm( comm, innerAlg )
%DISPLAYCOMM 
NsubSys   = length(comm.nn);
globN     = fieldnames(comm.globF);
nIter     = size(comm.globF.(globN{1}){1},2);

globCommTot = 0;
for i = 1:length(globN)
    for j=1:NsubSys
        globCommTot = globCommTot + sum(comm.globF.(globN{i}){j});
    end
end
globCommAvg = globCommTot/nIter;

nnCommTot = 0;
for i=1:NsubSys
    nnCommTot = nnCommTot + sum(comm.nn{i});
end
nnCommAvg = nnCommTot/nIter;

disp(['   --------------  Communication analysis  ----------------'])
disp(['   floats                   tot              avg ']);
fprintf('   Global forward:....:     %-16.0f %-10.0f \n',globCommTot,globCommAvg);
fprintf('   Neighbor-neighbor:.:     %-16.0f %-10.0f \n',nnCommTot,nnCommAvg);
disp(['   ========================================================      ']);



end

