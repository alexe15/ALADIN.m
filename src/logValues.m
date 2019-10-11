for j=1:NsubSys
        KioptEq{j}      = KKapp{j}(1:nngi{j});
        KioptIneq{j}    = KKapp{j}(nngi{j}+1:end); 
end

% logging
        logg.X          = [logg.X x];
        logg.Y          = [logg.Y y];
%         logg.delY       = [logg.delY delx];
%         logg.Kappa      = [logg.Kappa vertcat(Kiopt{:})];
%         logg.KappaEq    = [logg.KappaEq vertcat(KioptEq{:})];
%         logg.KappaIneq  = [logg.KappaIneq vertcat(KioptIneq{:})];
        logg.lambda     = [logg.lambda lam];     
        logg.localStepS = [logg.localStepS norm(x - yOld,1)];
        logg.QPstepS    = [logg.QPstepS norm(y-x,1)];
        logg.Mfun       = [logg.Mfun full(Mfun(y,muMeritMin*1.1))];
        logg.consViol   = [logg.consViol norm(A*x,inf)];
        Act             = vertcat(iinact{:});
        logg.wrkSet     = [logg.wrkSet ~Act];
        if i>2 % number of changing active constraints
            logg.wrkSetChang = [logg.wrkSetChang sum(abs(logg.wrkSet(:,end-1) - ~Act))];
        end
%         logg.obj        = [logg.obj obj];
    %    logg.desc       = [logg.desc full(grad'*delx)<0];
%         logg.alpha      = [logg.alpha alphaSQP];