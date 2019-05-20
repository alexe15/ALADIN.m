function [ Mfun ] = createMfun( locFunsCas, xxCas, AA, opts )
%CREATEMFUN Summary of this function goes here
%   Detailed explanation goes here
import casadi.*

kappMerit   = opts.sym('muMerit',1,1);
NsubSys     = length(locFunsCas.f);
Ncons       = size(AA{1},1);
xCas        = vertcat(xxCas{:});

mFunCas = 0;
for i=1:NsubSys
    nngi{i} = size(locFunsCas.g{i},1);
    nnhi{i} = size(locFunsCas.h{i},1);   
    
    mFunCas = mFunCas + locFunsCas.f{i} ...
            + kappMerit*(ones(nnhi{i},1)'*max(0,locFunsCas.h{i}) ...
            + ones(nngi{i},1)'*abs(locFunsCas.g{i}));
end

% set up the merit function
mFunCas    =   mFunCas + kappMerit*ones(Ncons,1)'*abs([AA{:}]*xCas);            
Mfun       =   Function('Mfun',{xCas,kappMerit},{mFunCas});
end

