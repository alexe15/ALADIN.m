% variable initialization
HHiEval = cell(NsubSys, 1);


nh = 0;
ng = 0;
nx = 0;

% initialization
iter.yy              = sProb.zz0;
iter.loc.xx          = sProb.zz0;
iter.lam             = sProb.lam0;
iter.delxs           = inf;

funs = sProb.locFuns;
z0 = sProb.zz0;

for j=1:NsubSys
   nngi{j} = size(funs.ggi{j}(z0{j}), 1);
   nnhi{j} = size(funs.hhi{j}(z0{j}), 1);

   iter.KKapp{j} = zeros(nngi{j}+nnhi{j},1);
   iter.LLam_x{j}= zeros(length(iter.loc.xx{j}),1);
   
   nx = nx + size(sProb.zz0{j},1);
   nh = nh + nnhi{j};
   ng = ng + nngi{j};
end


iter.logg.X          = zeros(nx,opts.maxiter);
iter.logg.Y          = zeros(nx,opts.maxiter);
iter.logg.Z          = zeros(nx,opts.maxiter);
iter.logg.delY       = zeros(nx,opts.maxiter);
% iter.logg.Kappa      = [];
% iter.logg.KappaEq    = [];
% iter.logg.KappaIneq  = [];
iter.logg.Mfun        = [];
iter.logg.consViol    = inf;
iter.logg.wrkSet      = zeros(ng + nh,opts.maxiter);
iter.logg.wrkSetChang = zeros(ng + nh,opts.maxiter);
iter.logg.obj         = zeros(1,opts.maxiter);
% iter.logg.desc       = [];
% iter.logg.alpha      = [];
% iter.logg.distrDiff  = [];
iter.logg.localStepS = zeros(1,opts.maxiter);
iter.logg.QPstepS    = zeros(1,opts.maxiter);
iter.logg.lam        = zeros(Ncons,opts.maxiter);
iter.logg.maxNLPt    = 0;
iter.comm.globF      = {};


timers.NLPtotTime = 0;
timers.RegTotTime = 0;
timers.sensEvalT  = 0;
timers.plotTimer  = 0;
timers.QPtotTime  = 0;



% communication counters
if strcmp(opts.commCount, 'true')
    [iter.comm.globF.Hess{1:NsubSys}]    = deal([]);
    [iter.comm.globF.grad{1:NsubSys}]    = deal([]);
    [iter.comm.globF.AAred{1:NsubSys}]   = deal([]);
    [iter.comm.globF.Hess{1:NsubSys}]    = deal([]);
    [iter.comm.globF.grad{1:NsubSys}]    = deal([]);
    [iter.comm.globF.Jac{1:NsubSys}]     = deal([]);
    [iter.comm.globF.primVal{1:NsubSys}] = deal([]);
    [iter.comm.nn{1:NsubSys}]            = deal([]);
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

if strcmp(opts.alg, 'ALADIN')
    iter.stepSizes.mu      = opts.mu0;
end

iter.stepSizes.alpha   = 1;

