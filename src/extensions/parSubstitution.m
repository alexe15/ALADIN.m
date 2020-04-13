    import casadi.*
    for i = 1:NsubSys
        nngi{i}  = size(sProb.locFunsCas.ggi{i},1);
        nnhi{i}  = size(sProb.locFunsCas.hhi{i},1);
        nx        = length(sProb.zz0{i});
        
       
        xxCas{i}  = opts.sym('x',nx,1);    
        kkappCas  = opts.sym('kapp',nngi{i}+nnhi{i},1);
        rhoCas    = opts.sym('rho',1,1);
        
        
        hhiCas{i}   = sProb.locFuns.hhi{i}(xxCas{i},sProb.p{i});
        ggiCas{i}   = sProb.sens.gg{i}(xxCas{i},sProb.p{i});
        JJhiCas{i}  = sProb.sens.JJac{i}(xxCas{i},sProb.p{i});
        HHiCas{i}   = sProb.sens.HH{i}(xxCas{i},sProb.p{i},kkappCas,rhoCas);
        
        
        sProb.locFuns.hhi{i} = Function(['h' num2str(i)],{xxCas{i}},{hhiCas{i}});
        sProb.sens.gg{i}     = Function(['g' num2str(i)],{xxCas{i}},{ggiCas{i}});
        sProb.sens.JJac{i}   = Function(['Jac' num2str(i)],{xxCas{i}},{JJhiCas{i}});
        sProb.sens.HH{i}     = Function(['H' num2str(i)],{xxCas{i},kkappCas,rhoCas},{HHiCas{i}});
    end