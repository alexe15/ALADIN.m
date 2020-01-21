function [ yy, lam ] = computeALstep( iter )
%COMPUTEALSTEP Summary of this function goes here
    NsubSys = length(iter.loc.xx);

    ctr  = 1;
    yy   = cell(NsubSys,1);
    for j=1:NsubSys
        ni    = length(iter.yy{j});
        yy{j} = iter.yy{j} + 1*(iter.loc.xx{j} - iter.yy{j}) + ...
                            iter.stepSizes.alpha*iter.delx(ctr:(ctr+ni-1)); 
        ctr   = ctr + ni;
    end
    lam     = iter.lamOld + 1*(iter.lam - iter.lamOld);
end