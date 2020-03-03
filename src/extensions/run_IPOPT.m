function [globSol, globFuns] = run_IPOPT( sProb )
% solves an affinely-coupled seperable problem by a centralized solver
import casadi.*
NsubSys = length(sProb.zz0);
x0      = vertcat(sProb.zz0{:});


% convert to CasADi functions           
f = 0;
g = [];
h = [];

for i=1:NsubSys
    xxCas{i}  = SX.sym('x',length(sProb.zz0{i}),1);    
    
    % local equality and inequality constraints
    ggCas{i}  = sProb.locFuns.ggi{i}(xxCas{i});
    hhCas{i}  = sProb.locFuns.hhi{i}(xxCas{i});
    ffCas{i}  = sProb.locFuns.ffi{i}(xxCas{i});
end

% concatenate... 
A     = [sProb.AA{:}];
xCas = vertcat(xxCas{:});
gCas = vertcat(ggCas{:});
hCas = vertcat(hhCas{:});
fCas = ones(1,NsubSys)*[ffCas{:}]';

gCas  = [ gCas; A*xCas];
cCas  = [ gCas; hCas];

nlp_opts.ipopt.print_level = 5;

nlp = struct('x',xCas,'f',fCas,'g',cCas);
cas = nlpsol('solver','ipopt',nlp,nlp_opts);
tic
sol = cas('x0' , x0,...
          'lbx', vertcat(sProb.llbx{:}),...
          'ubx', vertcat(sProb.uubx{:}),...
          'lbg', [zeros(length(gCas),1); -inf*ones(length(hCas),1)], ...
          'ubg', [zeros(length(gCas),1);  zeros(length(hCas),1)]);
toc

xopt    = full(sol.x);   
fval    = full(sol.f);
mult    = full(sol.lam_g);

% struct for global result
globSol     = struct('x',xopt,'f',fval,'lam',mult);

globFuns.g = Function('g',{xCas},{vertcat(ggCas{:})});
globFuns.h = Function('h',{xCas},{hCas});
globFuns.f = Function('f',{xCas},{fCas});



end

