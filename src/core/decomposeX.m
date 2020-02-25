function [ ddelx, lam ] = decomposeX(delxTot, lamTot, iter, opts)
%DECOMPOSEX Summary of this function goes here
%   Detailed explanation goes here
NsubSys = length(iter.yy);
Ncons   = length(iter.lam);
if strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none')
        %lamTot empty in this case
        delV = delxTot(1:end-Ncons);
        lam  = delxTot(end-Ncons+1:end);
        
        delx = blkdiag(iter.loc.sensEval.ZZ{:})*delV;

        % split up into local \Delta x_i
        ctr  = 1;
        ddelx   = cell(NsubSys,1);
        for j=1:NsubSys
            ni       = length(iter.yy{j});
            ddelx{j} = delx(ctr:(ctr+ni-1)); 
            ctr      = ctr + ni;
        end

    elseif strcmp(opts.innerAlg, 'none')
        % split up into local \Delta x_i
        ctr  = 1;
        ddelx   = cell(NsubSys,1);
        for j=1:NsubSys
            ni       = length(iter.yy{j});
            ddelx{j} = delxTot(ctr:(ctr+ni-1)); 
            ctr      = ctr + ni;
        end
        lam = lamTot(1:Ncons);
 end

end

