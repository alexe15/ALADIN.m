% variable initialization
logg.X          = [];
logg.Y          = [];
logg.delY       = [];   
logg.Kappa      = [];
logg.KappaEq    = [];
logg.KappaIneq  = [];
logg.lambda     = [];
logg.Mfun       = [];
logg.consViol   = [];
logg.wrkSet     = [];
logg.obj        = [];
logg.desc       = [];
logg.alpha      = [];
logg.distrDiff  = [];
logg.wrkSetChang= [];
logg.localStepS = [];
logg.QPstepS    = [];

% initialization
yy              = zz0;
xx              = zz0;
lam             = lam0;
delxs           = inf;

for j=1:NsubSys
   nngi{j} = size(locFunsCas.g{j},1);
   nnhi{j} = size(locFunsCas.h{j},1);  
    
   KKapp{j} = zeros(nngi{j}+nnhi{j},1);
   LLam_x{j}= zeros(length(xx{j}),1);
end

kappaMax        = 0;
lamMeritNum     = 0;
kappMeritNum    = 0;
HHQP            = {};  

NLPtotTime      = 0;
QPtotTime       = 0;    
RegTotTime      = 0;
  
nonMonSteps     = 0;

% compute matrices for ineq. QP
lbx        = vertcat(llbx{:});
ubx        = vertcat(uubx{:});


% From central solution multipliers
muMeritMin  = 1e4;

consViolEq = [];