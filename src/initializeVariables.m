% variable initialization
nngi    = {};
nnhi    = {};
HHiEval = cell(NsubSys, 1);


iter.logg.X          = [];
iter.logg.Y          = [];
iter.logg.delY       = [];   
iter.logg.Kappa      = [];
iter.logg.KappaEq    = [];
iter.logg.KappaIneq  = [];
iter.logg.Mfun       = [];
iter.logg.consViol   = opts.term_eps;
iter.logg.wrkSet     = [];
iter.logg.obj        = [];
iter.logg.desc       = [];
iter.logg.alpha      = [];
iter.logg.distrDiff  = [];
iter.logg.wrkSetChang= [];
iter.logg.localStepS = [];
iter.logg.QPstepS    = [];
iter.logg.lam        = [];



% initialization
iter.yy              = sProb.zz0;
iter.loc.xx              = sProb.zz0;
iter.lam             = sProb.lam0;
iter.delxs           = inf;

for j=1:NsubSys
   nngi{j} = size(sProb.locFunsCas.ggi{j},1);
   nnhi{j} = size(sProb.locFunsCas.hhi{j},1);  
    
   iter.KKapp{j} = zeros(nngi{j}+nnhi{j},1);
   iter.LLam_x{j}= zeros(length(iter.loc.xx{j}),1);
end

iter.ls.kappaMax        = 0;
iter.ls.lamMeritNum     = 0;
iter.ls.kappMeritNum    = 0;
iter.HHQP            = {};  

NLPtotTime      = 0;
QPtotTime       = 0;    
RegTotTime      = 0;
  
nonMonSteps     = 0;

% compute matrices for ineq. QP
lbx        = vertcat(sProb.llbx{:});
ubx        = vertcat(sProb.uubx{:});


% From central solution multipliers
iter.ls.muMeritMin     = 1e4;

iter.logg.consViolEq   = [];

iter.stepSizes.rho     = opts.rho0;
iter.stepSizes.mu      = opts.mu0;

iter.stepSizes.alpha   = 1;

iter.timers.NLPtotTime = 0;
iter.timers.RegTotTime = 0;