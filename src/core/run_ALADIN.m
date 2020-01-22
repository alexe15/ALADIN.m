% Solves a non-convex optimization problem in consensus form via the ALADIN
% algorithm
%
% in:  ffi:    Cell with local objective functions fi
%      hhi:    Cell with local inequality constraints hi
%      ggi:    Cell with local equality constraints gi
%      AA:     Cell with consensus matrices Ai
%
% out: xopt:   Optimal x vector
%      logg:   Struct, logging several values during the iteration process
%%------------------------------------------------------------------------
function [ xopt, lamOpt, iter ] = run_ALADIN( ffi,ggi,hhi,AA,zz0,...
                                                 lam0,llbx,uubx,SSig,opts )
                                
% just a wrapper for new interface!

sProb.locFuns.ffi  = ffi;
sProb.locFuns.ggi  = ggi;
sProb.locFuns.hhi  = hhi;
sProb.llbx = llbx;
sProb.uubx = uubx;
sProb.AA   = AA;
sProb.zz0  = zz0;
sProb.lam0 = lam0;
opts.SSig  = SSig;

                                
sol = run_ALADINnew( sProb, opts );                             
                          
xopt   = sol.xxOpt;
lamOpt = sol.lamOpt;
iter   = sol.iter;
end