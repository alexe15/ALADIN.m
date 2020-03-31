function [sProbCas, sProbValues, parforTmpVar] = getParforVars(sProb, iter, opts)
%GETPARFORVARS To be able to use parfor option from matlab library, the 
% variables need to handed over in an aproriate way. SX variables and
% functions are not allowed in parfor. Further, Casadi functions are not
% supposed to be handed over through a cell, i.e in the form of
% sProb.loc.fun{j}. Therefore, a struct array is constructed, that is
% compatible to matlab parfor compiler. Even, if Sy variables or casadi
% functions are handed over in the wrong formate and not used, this highly
% slows down parfor.

NsubSys = length(sProb.AA);

%% initialize sProbCas 
sProbCas = cell2struct(cell(7, NsubSys), {'locFunsCas_ggi', ... 
                                          'locFunsCas_hhi', ...
                                          'locFuns_hhi', ...
                                          'sens_gg', ...
                                          'loc_sensEval', ...
                                          'sens_JJac', ...
                                          'nnlp'}, 1);
for i = 1 : NsubSys
    sProbCas(i).locFunsCas_ggi = sProb.locFunsCas.ggi{i};
    sProbCas(i).locFuns_hhi = sProb.locFuns.hhi{i};
    sProbCas(i).sens_gg = sProb.sens.gg{i};
    sProbCas(i).nnlp = sProb.nnlp{i};
    sProbCas(i).sens_JJac = sProb.sens.JJac{i};
end

if strcmp(opts.Hess, 'BFGS') || strcmp(opts.Hess, 'DBFGS')
    for i = 1 : NsubSys
        sProbCas(i).sens_gL = sProb.sens.gL{i};
    end
end

if strcmp(opts.Hess, 'BFGS') || strcmp(opts.Hess, 'DBFGS')
    if strcmp(opts.BFGSinit, 'exact')
        for i = 1 : NsubSys
         sProbCas(i).sens_HH = sProb.sens.HH{i};
        end
    end
end


%% initialize sProbValues
sProbValues.llbx = sProb.llbx;
sProbValues.uubx = sProb.uubx;
sProbValues.gBounds.llb = sProb.gBounds.llb;
sProbValues.gBounds.uub = sProb.gBounds.uub;
sProbValues.zz0 = sProb.zz0;

if isfield(sProb, 'p')
    sProbValues.p = sProb.p;
end

if strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none')
    sProbValues.AA = sProb.AA;
end

%% initialize temporary parfor variables
parforTmpVar = cell2struct(cell(2, NsubSys), {'timers', ...
                                              'loc'}, 1);
if strcmp(opts.Sig,'dyn')
    for i = 1 : NsubSys
        parforTmpVar(i).opts_SSig = opts.SSig{i};
    end
end

if strcmp(opts.commCount, 'true')
    for i = 1 : NsubSys
        parforTmpVar(i).comm.globF.Hess = iter.comm.globF.Hess{i};
        parforTmpVar(i).comm.globF.grad = iter.comm.globF.grad{i};
        parforTmpVar(i).comm.globF.primVal = iter.comm.globF.primVal{i};
    end
end

for i = 1 : NsubSys
   parforTmpVar(i).loc.xx =iter.loc.xx{i}; 
end

 if ~(strcmp(opts.Hess, 'BFGS') || strcmp(opts.Hess, 'DBFGS'))
    for i = 1 : NsubSys
        sProbCas(i).sens_HH = sProb.sens.HH{i};
    end
 end

end

