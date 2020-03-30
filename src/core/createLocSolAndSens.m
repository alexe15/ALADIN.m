function [ sProb ] = createLocSolAndSens(sProb, opts)
% set up the local solvers and sensitivity functions for coord. QP

% convert MATLAB functions to CasADi functions 
if ~isfield(sProb, 'p')
    [ sProb.locFunsCas, sProb.xxCas ]             = mFun2casFun(sProb, opts);
else
    [ sProb.locFunsCas, sProb.xxCas, sProb.pCas ] = mFun2casFun(sProb, opts);
end

% create local solvers 
% [ sProb.nnlp, sProb.gBounds, sProb.rhoCas, sProb.lamCas, sProb.SSig ] = ...
%                                            createLocalSolvers(sProb, opts);

[ sProb.nnlp, sProb.gBounds, sProb.rhoCas] = createLocalSolvers(sProb, opts);

% compute sensitivities (gradient, Jacobian, ...)
sProb.sens          = createSens(sProb, opts);
                             
% set up a merit function for line search
sProb.Mfun          = createMfun(sProb, opts);

% optional functions
if opts.lamInit == true
    sProb.lam0 = computeLambdaInit(sProb);
end

end

