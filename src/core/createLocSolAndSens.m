function [ sProb ] = createLocSolAndSens(sProb, opts)
% set up the local solvers and sensitivity functions for coord. QP

% convert MATLAB functions to CasADi functions 
if ~isfield(sProb, 'p')
    [ sProb.locFunsCas, sProb.xxCas ]             = mFun2casFun(sProb, opts);
else
    [ sProb.locFunsCas, sProb.xxCas, sProb.pCas ] = mFun2casFun(sProb, opts);
end

% create local solvers 
% [ sProb.nnlp, sProb.gBounds, sProb.rhoCas, sProb.lamCas, sProb.SSig ] = createLocalSolvers(sProb, opts);

% compute sensitivities (gradient, Jacobian, ...)
sProb.rhoCas = opts.sym('rho',1,1);
if ~isfield(sProb, 'sens')
    fprintf('Using casadi to compute sensitivities...')
    sProb.sens = createSens(sProb, opts);
    fprintf('done\n\n');
else
    fprintf('Using given sensitivities...\n');
end
pause(1)

[ sProb.nnlp, sProb.gBounds, sProb.rhoCas] = createLocalSolvers(sProb, opts);


                             
% set up a merit function for line search
sProb.Mfun          = createMfun(sProb, opts);

% optional functions
if opts.lamInit == true
    sProb.lam0 = computeLambdaInit(sProb);
end

end

