function [ yy, lam ] = computeALstep( iter )
%COMPUTEALSTEP Summary of this function goes here
    NsubSys = length(iter.loc.xx);
    for j=1:NsubSys
        yy{j} = iter.yy{j} + 1*(iter.loc.xx{j} - iter.yy{j}) + ...
                                        iter.stepSizes.alpha*iter.ddelx{j}; 
    end
    lam     = iter.lamOld + 1*(iter.lam - iter.lamOld);
end