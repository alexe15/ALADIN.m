function [ locFunsCas, xxCas ] = mFun2casFun( sProb, opts )
%MFUN2CASFUN Summary of this function goes here
%   Detailed explanation goes here


NsubSys    = length(sProb.locFuns.ffi);
for i=1:NsubSys
    % set up local variables
    nx        = length(sProb.zz0{i});
    xxCas{i}  = opts.sym('x',nx,1);    
           
    % local equality and inequality constraints
    locFunsCas.ggi{i}  = sProb.locFuns.ggi{i}(xxCas{i});
    locFunsCas.hhi{i}  = sProb.locFuns.hhi{i}(xxCas{i});
    locFunsCas.ffi{i}  = sProb.locFuns.ffi{i}(xxCas{i});

end

end

