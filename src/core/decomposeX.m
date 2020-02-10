function [ ddelx ] = decomposeX(delxTot, iter)
%DECOMPOSEX Summary of this function goes here
%   Detailed explanation goes here
NsubSys = length(iter.yy);

% split up into local \Delta x_i
ctr  = 1;
ddelx   = cell(NsubSys,1);
for j=1:NsubSys
    ni       = length(iter.yy{j});
    ddelx{j} = delxTot(ctr:(ctr+ni-1)); 
    ctr      = ctr + ni;
end

end

