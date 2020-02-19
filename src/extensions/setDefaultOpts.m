function [ opts ] = setDefaultOpts( opts )
% set the required option fields to default values if not defined by the
% user

% define default options
defaultOpts = struct( 'rho0',1e2,'rhoUpdate',1.1,'rhoMax',1e8, ...
        'mu0',1e3,'muUpdate',2,'muMax',2*1e6,'eps',0,'maxiter',150, ...
        'actMargin',-1e-6,'hessian','standard','solveQP','MA57', ...
        'reg','true','locSol','ipopt','innerIter',2400,'innerAlg', ...
        'none','Hess','standard','plot',true,'slpGlob', true, ...
        'trGamma', 1e6,'Sig','const','lamInit',false,'term_eps',false, ...
        'slack','standard','warmStart',true);


optFields    = fieldnames(opts);
defOptFields = fieldnames(defaultOpts);
diffFields   = setdiff(defOptFields,optFields);

% set missing options to default options
for i=1:numel(diffFields)
    opts.(diffFields{i}) =  defaultOpts.(diffFields{i});
end
end

