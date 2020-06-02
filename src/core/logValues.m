% logg consensus violation, objective value and gradient 
%consViol        = full(sol.g);
%consViolEq      = [consViolEq; consViol(1:nngi{j})];
%iinact{j}       = inact;


% logging
x                 = vertcat(iter.loc.xx{:});
y                 = vertcat(iter.yy{:});
yOld              = vertcat(iter.yyOld{:});

iter.logg.X(:,i)  =  x;
iter.logg.Y(:,i)  =  y;
%         logg.delY       = [logg.delY delx];
%         logg.Kappa      = [logg.Kappa vertcat(Kiopt{:})];
%         logg.KappaEq    = [logg.KappaEq vertcat(KioptEq{:})];
%         logg.KappaIneq  = [logg.KappaIneq vertcat(KioptIneq{:})];
iter.logg.lam(:,i)        = iter.lam;
iter.logg.localStepS(:,i) = norm(full(x - yOld),inf);
iter.logg.QPstepS(:,i)    = norm(full(y-x),inf);
% iter.logg.Mfun       = [iter.logg.Mfun full(sProb.Mfun(y,iter.ls.muMeritMin*1.1))];
iter.logg.consViol(:,i+1)   = norm([sProb.AA{:}]*x,inf);


%         logg.obj        = [logg.obj obj];
%    logg.desc       = [logg.desc full(grad'*delx)<0];
%         logg.alpha      = [logg.alpha alphaSQP];

if strcmp(opts.alg, 'ALADIN')
    % maximal multiplier for inequalities
    kappaMax        = max(abs(vertcat(iter.loc.KKapp{:}))); 

    for j=1:NsubSys
            KioptEq{j}      = iter.loc.KKapp{j}(1:nngi{j});
            KioptIneq{j}    = iter.loc.KKapp{j}(nngi{j}+1:end); 
    end
    
    iter.logg.wrkSet(:,i)   = ~vertcat(iter.loc.inact{:});
    
    if i>2 % number of changing active constraints
        iter.logg.wrkSetChang(:,i) = sum(abs(iter.logg.wrkSet(:,end-1) - ~vertcat(iter.loc.inact{:})));
    end
end