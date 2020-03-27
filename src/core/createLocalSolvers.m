function [ nnlp, gBounds, rhoCas, lamCas, SSig ] = createLocalSolvers( sProb, opts )
global use_fmincon
% set up solvers for local NLPs
import casadi.*
NsubSys = length(sProb.AA);
rhoCas  = opts.sym('rho',1,1);
lamCas  = opts.sym('lam',size(sProb.AA{1},1),1);
if isfield(sProb, 'p')
    par     = opts.sym('par',size(sProb.p,1),1);
end

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
    if ~isfield(sProb, 'p')
        ppCas{i} = [ rhoCas; lamCas; zzCas{i}];
    else
        ppCas{i} = [ rhoCas; lamCas; zzCas{i}; sProb.pCas];
    end
    
    if use_fmincon
        funs = sProb.locFuns;
        nnlp{i} = @(x, z, rho, lambda, Sigma)build_local_NLP(funs.ffi{i}, funs.ggi{i}, funs.hhi{i}, sProb.AA{i}, lambda, rho, z, Sigma, x, sProb.llbx{i}, sProb.uubx{i});   
    else
        nlp      = struct('x',sProb.xxCas{i},'f',ffiLocCas, ...
                          'g',[sProb.locFunsCas.ggi{i}; sProb.locFunsCas.hhi{i}], ...
                          'p',[ppCas{i}; SSig(:)]);
        nlp_reference = nlpsol('solver', solver, nlp, NLPopts);
        nnlp{i}  = @(x0, lam_g0, lam_x0, p, lbx, ubx, lbg, ubg)nlp_reference('x0',x0,...
                            'lam_g0', lam_g0,...
                            'lam_x0', lam_x0,...
                            'p',      p,...
                            'lbx',    lbx,...
                            'ubx',    ubx,...
                            'lbg',    lbg, ...
                            'ubg',    ubg); 
    end            
    
end
end

function res = build_local_NLP(f, g, h, A, lambda, rho, z, Sigma, x0, lbx, ubx)
    cost = build_cost_function(f, lambda, A, rho, z, Sigma);
    nonlcon = @(x)build_nonlcon(x, g, h);
    [xopt, fval, flag, out, multiplier] = fmincon(cost, x0, [], [], [], [], lbx, ubx, nonlcon);
    res.x = xopt;
    res.lam_g = [multiplier.eqnonlin; multiplier.ineqnonlin];
    res.lam_x = max(multiplier.lower, multiplier.upper);
end

function fun = build_cost_function(f, lambda, A, rho, z, Sigma)
    fun = @(x)f(x) + lambda'*A*x + 0.5*rho*(x - z)'*Sigma*(x - z);
end


function [ineq, eq] = build_nonlcon(x, g, h)
    ineq = h(x);
    eq = g(x);
end

