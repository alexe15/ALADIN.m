function [ sProb ] = reform(sProb)

    % reformulation the struct of sProb
    
    sProb.nnlp = sProb.reuse.nnlp;
    sProb.sens = sProb.reuse.sens;
    sProb.locFunsCas = sProb.reuse.locFunsCas;
    sProb.gBounds = sProb.reuse.gBounds;
    sProb.Mfun = sProb.reuse.Mfun;
    
    % remove the field 'reuse'
    sProb = rmfield(sProb, 'reuse');
    
end

