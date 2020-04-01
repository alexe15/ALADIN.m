function [loc, timers, opts ]= parforVars2globalVars(parforTmpVar, loc, iter, opts, NsubSys, timers)
% Copy temporary data from parforTmpVar to global variables

%% universal variables
for i = 1 : NsubSys
    loc.xx{i}               = parforTmpVar(i).loc.xx;
    loc.KKapp{i}            = parforTmpVar(i).loc.KKapp;
    loc.LLam_x{i}           = parforTmpVar(i).loc.LLam_x;
    loc.inact{i}            = parforTmpVar(i).loc.inact;
    loc.sensEval.ggiEval{i} = parforTmpVar(i).loc.sensEval.ggiEval;
    loc.sensEval.HHiEval{i} = parforTmpVar(i).loc.sensEval.HHiEval;
    loc.sensEval.JJacCon{i} = parforTmpVar(i).loc.sensEval.JJacCon;
end

%% variables sensitive to chosen opts
% dynamically changing sigma
if strcmp(opts.Sig, 'dyn')
    for i = 1 : NsubSys
        loc.locStep{i}      = parforTmpVar(i).loc.locStep;
    end
    if iter.i > 1
        for i = 1 : NsubSys
            opts.SSig{i}    = parforTmpVar(i).opts_SSig;
        end
    end
end

% BFGS || DBFGS
if strcmp(opts.Hess, 'BFGS') || strcmp(opts.Hess, 'DBFGS')
    for i = 1 : NsubSys
        loc.sensEval.gLiEval{i} = parforTmpVar(i).loc.sensEval.gLiEval;
    end
end

% communication for xx and the gradient of the Lagrangian and the objective
if strcmp(opts.commCount, 'true') && ~strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none')
    for i = 1 : NsubSys
        iter.comm.globF.Hess{i}     = parforTmpVar(i).comm.globF.Hess;
        iter.comm.globF.grad{i}     = parforTmpVar(i).comm.globF.grad;
        iter.comm.globF.primVal{i}  = parforTmpVar(i).comm.globF.primVal;
    end
end

% for reduced-space method, compute reduced QP
if strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none')
    for j = 1 : NsubSys
        loc.sensEval.ZZ{j}      = parforTmpVar(j).loc.sensEval.ZZ;
        loc.sensEval.HHred{j}   = parforTmpVar(j).loc.sensEval.HHred;
        loc.sensEval.AAred{j}   = parforTmpVar(j).loc.sensEval.AAred;
        loc.sensEval.ggred{j}   = parforTmpVar(j).loc.sensEval.ggred;
    end
    
    if strcmp(opts.commCount, 'true') && strcmp(opts.innerAlg, 'none')
        for j = 1 : NsubSys
            % number of floats for the reduce-space method (no sparsity ex.)
            iter.comm.globF.AAred{j}   = parforTmpVar(j).comm.globF.AAred;
            iter.comm.globF.Hess{j}    = parforTmpVar(j).comm.globF.Hess;
            iter.comm.globF.grad{j}    = parforTmpVar(j).comm.globF.grad;
            iter.comm.globF.Jac{j}     = parforTmpVar(j).comm.globF.Jac;
            % reduced primal values
            iter.comm.globF.primVal{j} = parforTmpVar(j).comm.globF.primVal;
        end
    end
else
    %  full Hessian
    if strcmp(opts.commCount, 'true') && strcmp(opts.innerAlg, 'none')
        for j = 1 : NsubSys
            iter.comm.globF.Jac{j}     =  parforTmpVar(j).comm.globF.Jac;
        end
    end
end

for j = 1:NsubSys
    timers.RegTotTime = timers.RegTotTime + parforTmpVar(j).timers.RegTotTime;
    timers.sensEvalT  = timers.sensEvalT  + parforTmpVar(j).timers.sensEvalT;
    timers.NLPtotTime = timers.NLPtotTime + parforTmpVar(j).timers.NLPtotTime;
end

end