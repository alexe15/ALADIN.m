function [ nnlp, gBounds, rhoCas, lamCas, SSig ] = createLocalSolvers( sProb, opts )
% set up solvers for local NLPs
import casadi.*
NsubSys = length(sProb.AA);
rhoCas  = opts.sym('rho',1,1);
lamCas  = opts.sym('lam',size(sProb.AA{1},1),1);

for i=1:NsubSys     
    nnxi{i} = size(sProb.AA{i},2);
    nngi{i} = size(sProb.locFunsCas.ggi{i},1);
    nnhi{i} = size(sProb.locFunsCas.hhi{i},1);    
    
    % set up bounds for equalities/inequalities
    gBounds.llb{i}  = [zeros(nngi{i},1); -inf*ones(nnhi{i},1)];
    gBounds.uub{i}  = zeros(nngi{i}+nnhi{i},1);
    
    % local Lagrange multipliers
    SSig      = opts.sym('SSig',[nnxi{i} nnxi{i}]);
 
    nx        = length(sProb.xxCas{i});
    zzCas{i}  = opts.sym('z',nx,1);

                
    % objective function for local NLP's
    ffiLocCas = sProb.locFunsCas.ffi{i} + lamCas'*sProb.AA{i}*sProb.xxCas{i} ...
                + rhoCas/2*(sProb.xxCas{i} - zzCas{i})'*SSig* ...
                (sProb.xxCas{i} - zzCas{i});

    %%% set up local solvers %%%
    % load options for local NLP solvers
    [ NLPopts, solver ]  = loadNLPopts();
    
    % set up bounds for equalities/inequalities
    lbg{i}   = [zeros(nngi{i},1); -inf*ones(nnhi{i},1)];
    ubg{i}   = zeros(nngi{i}+nnhi{i},1);
    
     % parameters for local problems
    ppCas{i} = [ rhoCas; lamCas; zzCas{i}];
    
    nlp      = struct('x',sProb.xxCas{i},'f',ffiLocCas, ...
                      'g',[sProb.locFunsCas.ggi{i}; sProb.locFunsCas.hhi{i}], ...
                      'p',[ppCas{i}; SSig(:)]);
    nnlp{i}  = nlpsol('solver', solver, nlp, NLPopts);
end
end

