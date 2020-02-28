% Copy local data from parfor compatible data vector 

if strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none') && strcmp(opts.reg, 'true')
        for j=1:NsubSys
        loc.xx{j} = loc_temp(j).xx;
        loc.KKapp{j} = loc_temp(j).KKapp;
        loc.LLam_x{j} = {loc_temp(j).LLam_x};
        loc.inact{j} = loc_temp(j).inact;
        
       loc.sensEval.ZZ{j} = loc_temp(j).sensEval.ZZ;
       loc.sensEval.HHred{j} = loc_temp(j).sensEval.HHred;
       loc.sensEval.AAred{j} = loc_temp(j).sensEval.AAred;
       loc.sensEval.ggred{j} = loc_temp(j).sensEval.ggred;
     
       loc.sensEval.ggiEval{j} = loc_temp(j).sensEval.ggiEval;
       loc.sensEval.HHiEval{j} = loc_temp(j).sensEval.HHiEval;
       loc.sensEval.JJacCon{j} = loc_temp(j).sensEval.JJacCon;    
        end
elseif strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none') && strcmp(opts.reg, 'false')
        for j=1:NsubSys
        loc.xx{j} = loc_temp(j).xx;
        loc.KKapp{j} = loc_temp(j).KKapp;
        loc.LLam_x{j} = {loc_temp(j).LLam_x};
        loc.inact{j} = loc_temp(j).inact;
        
       loc.sensEval.ZZ{j} = loc_temp(j).sensEval.ZZ;
       % loc.sensEval.HHred{j} = loc_temp(j).sensEval.HHred;
       loc.sensEval.AAred{j} = loc_temp(j).sensEval.AAred;
       loc.sensEval.ggred{j} = loc_temp(j).sensEval.ggred;
       
       loc.sensEval.ggiEval{j} = loc_temp(j).sensEval.ggiEval;
       loc.sensEval.HHiEval{j} = loc_temp(j).sensEval.HHiEval;
       loc.sensEval.JJacCon{j} = loc_temp(j).sensEval.JJacCon; 
      
        end 
elseif (~strcmp(opts.slack,'redSpace') && strcmp(opts.innerAlg, 'none') && strcmp(opts.reg, 'true'))
    for j=1:NsubSys
        loc.xx{j} = loc_temp(j).xx;
        loc.KKapp{j} = loc_temp(j).KKapp;
        loc.LLam_x{j} = {loc_temp(j).LLam_x};
        loc.inact{j} = loc_temp(j).inact;

        loc.sensEval.ggiEval{j} = loc_temp(j).sensEval.ggiEval;
        loc.sensEval.HHiEval{j} = loc_temp(j).sensEval.HHiEval;
        loc.sensEval.JJacCon{j} = loc_temp(j).sensEval.JJacCon;    
    end
else
        for j=1:NsubSys
        loc.xx{j} = loc_temp(j).xx;
        loc.KKapp{j} = loc_temp(j).KKapp;
        loc.LLam_x{j} = {loc_temp(j).LLam_x};
        loc.inact{j} = loc_temp(j).inact;

        loc.sensEval.ggiEval{j} = loc_temp(j).sensEval.ggiEval;
        loc.sensEval.JJacCon{j} = loc_temp(j).sensEval.JJacCon;
        end
end

if strcmp(opts.Hess, 'BFGS') || strcmp(opts.Hess, 'DBFGS')
   for j = 1 : NsubSys
    loc.sensEval.gLiEval{j} = loc_temp(j).sensEval.gLiEval;
   end
end


for j = 1 : NsubSys
    if strcmp(opts.Sig,'dyn')
        % after second iteration
        if size(iter.logg.X,2) > 2 
             opts.SSig{j} = mat2cell(SSig(j));
             loc.locStep{j} = loc_temp(j).locStep;
        else
            loc.locStep{j} = loc_temp(j).locStep;
        end
    end
end

for j = 1:NsubSys
    timers.RegTotTime = timers.RegTotTime + timers_temp(j).RegToTTime;
    timers.sensEvalT = timers.sensEvalT + timers_temp(j).sensEvalT;
    timers.NLPtotTime = timers.NLPtotTime + timers_temp(j).NLPtotTime;
end


