function [ ddelx ] = expandLocally(lam, cond)
%EXPANDLOCALLY Summary of this function goes here
%   Detailed explanation goes here

NsubSys = length(cond.C);
for i=1:NsubSys
    ddelx{i} = cond.ZZ{i}*cond.HHredInv{i}* ...
                      (-cond.AAred{i}'*cond.IC{i}'*lam{i} - cond.ggred{i});
end

end

