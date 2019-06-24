function [ nnlp, sens, gBounds ] = createLocalSolvers( locFunsCas, AA, xxCas, Sig, opts )
%CREATELOCALSOLVERS Summary of this function goes here
%   Detailed explanation goes here
import casadi.*

NsubSys     = length(AA);
rhoCas      = opts.sym('rho',1,1);
lamCas      = opts.sym('lam',size(AA{1},1),1);


for i=1:NsubSys     
    nngi{i} = size(locFunsCas.g{i},1);
    nnhi{i} = size(locFunsCas.h{i},1);    
    
    % set up bounds for equalities/inequalities
    gBounds.lb{i}  = [zeros(nngi{i},1); -inf*ones(nnhi{i},1)];
    gBounds.ub{i}  = zeros(nngi{i}+nnhi{i},1);
    
    % local Lagrange multipliers
    kkappCas = opts.sym('kapp',nngi{i}+nnhi{i},1);
 
 
    nx        = length(xxCas{i});
    zzCas{i}  = opts.sym('z',nx,1);

                
    % objective function for local NLP's
    ffiLocCas = locFunsCas.f{i} + lamCas'*AA{i}*xxCas{i} ...
                + rhoCas/2*(xxCas{i} - zzCas{i})'*Sig{i}*(xxCas{i} - zzCas{i});
     
            
    
    %%% set up local solvers %%%
    % set some local solver options if desired
    % disable output of local solvers
    nlp_opts.print_time = 0;
    nlp_opts.ipopt.print_level = 5;
    
%     nlp_opts.qpsol = 'qpoases';
%     nlp_opts.ipopt.acceptable_tol = 1e-12;
%     nlp_opts.ipopt.acceptable_compl_inf_tol = 1e-12;
%     nlp_opts.ipopt.acceptable_constr_viol_tol = 1e-12;
%     nlp_opts.ipopt.acceptable_iter = 0;
    
    % set up bounds for equalities/inequalities
    lbg{i}  = [zeros(nngi{i},1); -inf*ones(nnhi{i},1)];
    ubg{i}  = zeros(nngi{i}+nnhi{i},1);
    
     % parameters for local problems
    ppCas{i}     = [ rhoCas;
                     lamCas;
                     zzCas{i}];
    
    nlp     = struct('x',xxCas{i},'f',ffiLocCas,'g',[locFunsCas.g{i}; locFunsCas.h{i}],'p',ppCas{i});
    nnlp{i} = nlpsol('solver','ipopt',nlp,nlp_opts);
    % alternatively use an SQP algorithm
%    nnlp{i} = nlpsol('solver','sqpmethod',nlp);
    
    % Jacobian of local constraints
    JJhiCas = jacobian([locFunsCas.g{i}; locFunsCas.h{i}],xxCas{i});   
    
    % Gradient and Hessian  of local objective
    gradiCas    = gradient(locFunsCas.f{i},xxCas{i}); 
 %   gradLiCas   = gradient(locFunsCas.f{i} + kkappCas'*[locFunsCas.g{i}; locFunsCas.h{i}],xxCas{i}); 

    if nngi{i}+nnhi{i} == 0
        if strcmp(opts.hessian,'aug') % Hessian of aug. L.
            HHiCas    = hessian(locFunsCas.f{i} + rhoCas/2*(xxCas{i})'*Sig{i}*(xxCas{i}),xxCas{i}); 
        elseif strcmp(opts.hessian,'gaussNewton')
            HHiCas    = hessian(locFunsCas.f{i} + 100*locFunsCas.g{i}'*locFunsCas.g{i},xxCas{i});
        else
            % standard Hessian
            HHiCas    = hessian(locFunsCas.f{i}, xxCas{i});       
        end
    else
        if strcmp(opts.hessian,'aug') % Hessian of aug. L.
            HHiCas    = hessian(locFunsCas.f{i} + kkappCas'*[locFunsCas.g{i}; locFunsCas.h{i}]+rhoCas/2*(xxCas{i})'*Sig{i}*(xxCas{i}),xxCas{i}); 
        elseif strcmp(opts.hessian,'gaussNewton')
            HHiCas    = hessian(locFunsCas.f{i} + 100*locFunsCas.g{i}'*locFunsCas.g{i},xxCas{i});
        else
            % standard Hessian
            HHiCas    = hessian(locFunsCas.f{i}+kkappCas'*[locFunsCas.g{i}; locFunsCas.h{i}],xxCas{i});       
        end
    end
    % set up CasADi function
    sens.g{i}   = Function(['g' num2str(i)],{xxCas{i}},{gradiCas});
    sens.H{i}   = Function(['H' num2str(i)],{xxCas{i},kkappCas,rhoCas},{HHiCas}); 
    sens.Jac{i} = Function(['Jac' num2str(i)],{xxCas{i}},{JJhiCas});
     
    % gradient of Lagrangian for BFGS version
    sens.gL{i}  = Function(['g' num2str(i)],{xxCas{i},kkappCas},{gradiCas});

end



% hFun       =   Function('hFun',{yCas},{hCas});
% gFun       =   Function('gFun',{yCas},{gCas});




end

