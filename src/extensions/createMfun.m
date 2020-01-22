function [ Mfun ] = createMfun( sProb, opts )
%CREATEMFUN Summary of this function goes here
%   Detailed explanation goes here
import casadi.*

kappMerit   = opts.sym('muMerit',1,1);
NsubSys     = length(sProb.AA);
Ncons       = size(sProb.AA{1},1);
xCas        = vertcat(sProb.xxCas{:});

mFunCas = 0;
for i=1:NsubSys
    nngi{i} = size(sProb.locFunsCas.ggi{i},1);
    nnhi{i} = size(sProb.locFunsCas.hhi{i},1);   
    
    mFunCas = mFunCas + sProb.locFunsCas.ffi{i} ...
            + kappMerit*(ones(nnhi{i},1)'*max(0,sProb.locFunsCas.hhi{i}) ...
            + ones(nngi{i},1)'*abs(sProb.locFunsCas.ggi{i}));
end

% set up the merit function
mFunCas    =   mFunCas + kappMerit*ones(Ncons,1)'*abs([sProb.AA{:}]*xCas);            
Mfun       =   Function('Mfun',{xCas,kappMerit},{mFunCas});
end

