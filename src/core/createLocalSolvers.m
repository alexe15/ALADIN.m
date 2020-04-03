function [ nnlp, gBounds, rhoCas ] = createLocalSolvers( sProb, opts )
global use_fmincon
% set up solvers for local NLPs
import casadi.*
NsubSys = length(sProb.AA);
rhoCas  = opts.sym('rho',1,1);
lamCas  = opts.sym('lam',size(sProb.AA{1},1),1);
if isfield(sProb, 'p')
    par     = opts.sym('par',size(sProb.p,1),1);
    error('currently not supported.');
end

funs = sProb.locFuns;
z0 = sProb.zz0;

for i=1:NsubSys     
    nnxi{i} = size(sProb.AA{i},2);
    nngi{i} = size(funs.ggi{i}(z0{i}), 1);
    nnhi{i} = size(funs.hhi{i}(z0{i}), 1);    
    
    % set up bounds for equalities/inequalities
    gBounds.llb{i}  = [zeros(nngi{i},1); -inf*ones(nnhi{i},1)];
    gBounds.uub{i}  = zeros(nngi{i}+nnhi{i},1);
    
    [solve_nlp, pars] = deal([]);
    
    if use_fmincon
        pars = [];
        funs = sProb.locFuns;
        jacs = sProb.locSens;
        solve_nlp = @(x, z, rho, lambda, Sigma, pars)build_local_NLP(funs.ffi{i}, funs.ggi{i}, funs.hhi{i}, sProb.AA{i}, lambda, rho, z, Sigma, x, sProb.llbx{i}, sProb.uubx{i}, jacs.ggi{i});   
    else
        assert(isfield(sProb, 'locFunsCas'), 'locFunsCas field is missing')
        nlp_reference = build_nlp_reference(sProb.xxCas{i},...
                                            sProb.locFunsCas.ffi{i},...
                                            sProb.locFunsCas.ggi{i},...
                                            sProb.locFunsCas.hhi{i},...
                                            sProb.AA{i},...
                                            lamCas,...
                                            rhoCas,...
                                            opts);
        pars = struct('lam_g0', [], 'lam_x0', []);
        solve_nlp  = @(x, z, rho, lambda, Sigma, pars)build_nlp_with_casadi(x, z, rho, lambda, Sigma, pars, nlp_reference, sProb.llbx{i}, sProb.uubx{i}, gBounds.llb{i}, gBounds.uub{i});
    end    
    
    nnlp{i} = struct('solve_nlp', solve_nlp, 'pars', pars); 
end
end

function nlp_reference = build_nlp_reference(x, f, g, h, A, lambda, rho, opts)
    import casadi.*
    nx = length(x);
    Sigma = opts.sym('SSig',[nx nx]);
    z  = opts.sym('z',nx,1);

    cost = f + lambda'*A*x + rho/2*(x - z)'*Sigma*(x - z);

    [NLPopts, solver]  = loadNLPopts();

    nlp      = struct('x',x,'f',cost, ...
                      'g',[g; h], ...
                      'p',[rho; lambda; z; Sigma(:)]);
    nlp_reference = nlpsol('solver', solver, nlp, NLPopts);
end

function res = build_nlp_with_casadi(x, z, rho, lambda, Sigma, pars, nlp, lbx, ubx, lbg, ubg)
    sol  = nlp( 'x0', x,...
                'lam_g0', pars.lam_g0,...
                'lam_x0', pars.lam_x0,...
                'p',      [rho; lambda; z; Sigma(:)],...
                'lbx',    lbx,...
                'ubx',    ubx,...
                'lbg',    lbg, ...
                'ubg',    ubg); 
    res.x = sol.x;
    res.lam_g = sol.lam_g;
    res.lam_x = sol.lam_x;
    res.pars.lam_g0 = res.lam_g;
    res.pars.lam_x = res.lam_x;
end

function res = build_local_NLP(f, g, h, A, lambda, rho, z, Sigma, x0, lbx, ubx, dgdx)
    opts = optimoptions('fmincon');
    opts.Algorithm = 'trust-region-reflective';
    opts.CheckGradients = false;
    opts.SpecifyConstraintGradient = true;
    opts.SpecifyObjectiveGradient = true;

    cost = @(x)build_cost_function(x, f(x), lambda, A, rho, z, Sigma);
    nonlcon = @(x)build_nonlcon(x, g, h, dgdx);
    [xopt, fval, flag, out, multiplier] = fmincon(cost, x0, [], [], [], [], lbx, ubx, nonlcon);
    res.x = xopt;
    res.lam_g = [multiplier.eqnonlin; multiplier.ineqnonlin];
    res.lam_x = max(multiplier.lower, multiplier.upper);
    res.pars = [];
end

function [fun, grad] = build_cost_function(x, f, lambda, A, rho, z, Sigma)
%     try chol(Sigma)
%         disp('Matrix is symmetric positive definite.')
%     catch ME
%         disp('Matrix is not symmetric positive definite')
%     end
    fun = f + lambda'*A*x + 0.5*rho*(x - z)'*Sigma*(x - z);
    if nargout > 1
        grad = A'*lambda + 0.5*rho*Sigma*(x - z);
    end
end

function [ineq, eq, jac_ineq, jac_eq] = build_nonlcon(x, g, h, dgdx)
    ineq = h(x);
    eq = g(x);
    jac_ineq = [];
    iac_eq = dgdx(x);
end

