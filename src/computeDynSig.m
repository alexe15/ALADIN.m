function [ SSig ] = computeDynSig(sProb)
%COMPUTEDYNSIG Summary of this function goes here
%   Detailed explanation goes here
            % compute Hessian at y for scaling
            if i > 1
                tmp         = ones(nngi{j} + nnhi{j},1);
                tmp(~inact) = kapp;
                HHiEval{j}  = sens.H{j}(yy{j},tmp,rho);
                HHiEval{j}  = regularizeH(HHiEval{j});
            else
                HHiEval = Sig;
            end
end

