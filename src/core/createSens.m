function [ sens ] = createSens(sProb, opts)
import casadi.*
NsubSys = length(sProb.AA);

for i=1:NsubSys
    nngi{i}  = size(sProb.locFunsCas.ggi{i},1);
    nnhi{i}  = size(sProb.locFunsCas.hhi{i},1);    
    
    % Lagrange multipliers for nonlinear constraints
    kkappCas = opts.sym('kapp',nngi{i}+nnhi{i},1);
    
    % Jacobian of local constraints
    JJhiCas      = jacobian([sProb.locFunsCas.ggi{i}; 
                        sProb.locFunsCas.hhi{i}],sProb.xxCas{i});   

    % Gradient and Hessian  of local objective
    gradiCas     = gradient(sProb.locFunsCas.ffi{i},sProb.xxCas{i}); 

    
    % set up CasADi functions
    sens.gg{i}   = Function(['g' num2str(i)],{sProb.xxCas{i}},{gradiCas});
    sens.JJac{i} = Function(['Jac' num2str(i)],{sProb.xxCas{i}},{JJhiCas});

    if strcmp(opts.Hess, 'BFGS') || strcmp(opts.Hess, 'DBFGS')
        % gradient of Lagrangian for BFGS version
        if size(kkappCas,1) == 0
            gradiLag     = gradiCas;
            
            % standard Hessian (for initialization)
            HHiCas    = hessian(sProb.locFunsCas.ffi{i}, sProb.xxCas{i});   
        else
            gradiLag     = gradient(sProb.locFunsCas.ffi{i} + kkappCas'* ...
                        [sProb.locFunsCas.ggi{i};sProb.locFunsCas.hhi{i}],...
                        sProb.xxCas{i});
            % standard Hessian
            HHiCas    = hessian(sProb.locFunsCas.ffi{i} + kkappCas'* ...
                    [sProb.locFunsCas.ggi{i}; sProb.locFunsCas.hhi{i}], ...
                                                           sProb.xxCas{i});  
        end
        sens.gL{i}  = Function(['g' num2str(i)],{sProb.xxCas{i},kkappCas},{gradiLag});
        sens.HH{i}   = Function(['H' num2str(i)],{sProb.xxCas{i}, ... 
                                      kkappCas,sProb.rhoCas},{HHiCas}); 
    else
        % compute the Hessian approximation
        if nngi{i}+nnhi{i} == 0
            if strcmp(opts.hessian,'gaussNewton')
                HHiCas    = hessian(sProb.locFunsCas.ffi{i}, xxCas{i});
            else
                % standard Hessian
                HHiCas    = hessian(sProb.locFunsCas.ffi{i}, sProb.xxCas{i});       
            end
        else
            if  strcmp(opts.hessian,'gaussNewton')
                HHiCas    = hessian(sProb.locFunsCas.ffi{i} + ...
                    sProb.locFunsCas.ggi{i}'*locFunsCas.ggi{i},sProb.xxCas{i});
            else
                % standard Hessian
                HHiCas    = hessian(sProb.locFunsCas.ffi{i} + kkappCas'* ...
                        [sProb.locFunsCas.ggi{i}; sProb.locFunsCas.hhi{i}], ...
                                                               sProb.xxCas{i});       
            end
        end
        sens.HH{i}   = Function(['H' num2str(i)],{sProb.xxCas{i}, ... 
                                              kkappCas,sProb.rhoCas},{HHiCas}); 
    end
end

end

