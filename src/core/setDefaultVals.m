function sProb = setDefaultVals(sProb)
% set functions to emptyfunctions if not present
NsubSys = length(sProb.AA);
emptyfun      = @(x) [];

% set ggi and hhi to emptyfun if not present
if ~isfield(sProb.locFuns, 'ggi')
    [sProb.locFuns.ggi{1:NsubSys}] = deal(emptyfun);
end
if ~isfield(sProb.locFuns, 'hhi')
    [sProb.locFuns.hhi{1:NsubSys}] = deal(emptyfun);
end

% set default primal values to zero if not set
if ~isfield(sProb, 'zz0')
    for i=1:NsubSys
        nxi          = size(sProb.AA{i},2);
        sProb.zz0{i} = zeros(nxi,1);
    end
end

% set default lower/upper bounds if not present
if ~isfield(sProb, 'llbx')
    for i=1:NsubSys
        nxi           = size(sProb.AA{i},2);        
        sProb.llbx{i} = -inf*ones(nxi,1);
    end
end

% set default lower/upper bounds if not present
if ~isfield(sProb, 'uubx')
    for i=1:NsubSys
        nxi           = size(sProb.AA{i},2);        
        sProb.uubx{i} = inf*ones(nxi,1);
    end
end

% set default multipliers to zero if not present
if ~isfield(sProb, 'lam0')
    sProb.lam0 = zeros(size(sProb.AA{1},1),1);
end

end

