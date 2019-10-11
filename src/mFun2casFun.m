function [ locFunsCas, xxCas ] = mFun2casFun( locFuns, zz0, opts )
%MFUN2CASFUN Summary of this function goes here
%   Detailed explanation goes here
NsubSys    = length(locFuns.f);
for i=1:NsubSys
    % set up local variables
    nx        = length(zz0{i});
    xxCas{i}  = opts.sym('x',nx,1);    
           
    % local equality and inequality constraints
    locFunsCas.g{i}  = locFuns.g{i}(xxCas{i});
    locFunsCas.h{i}  = 1*locFuns.h{i}(xxCas{i});
    locFunsCas.f{i}  = locFuns.f{i}(xxCas{i});

end

end

