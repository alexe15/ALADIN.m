function [  ] = displayTimers(timers)
% Shows the timings for the major steps of ALADIN

decP    = 1;
p.setup =  round(timers.setupT/timers.totTime*100,decP);
p.iter  =  round(timers.iter.iterTime/timers.totTime*100,decP);

p.NLP  =  round(timers.iter.NLPtotTime/timers.iter.iterTime*100,decP);
p.plt  =  round(timers.iter.plotTimer/timers.iter.iterTime*100,decP);
p.QP   =  round(timers.iter.QPtotTime/timers.iter.iterTime*100,decP);
p.reg  =  round(timers.iter.RegTotTime/timers.iter.iterTime*100,decP);

dec =  2;

% disp(['                                                          '])
% disp(['   ==================   ALADIN timing   =================='])
% %disp(['                                                          '])
% disp(['                t[s]    %tot    %iter'])
% disp(['Tot time:       ' num2str(round(timers.totTime,dec))])
% disp(['Prob setup:     ' num2str(round(timers.setupT,dec)) '     ' ...
%                                                          num2str(p.setup)])
% disp(['Iter time:      ' num2str(round(timers.iter.iterTime,dec)) ...
%                                                   '     ' num2str(p.iter)])
% disp('  ------')
% disp(['NLP time:       ' num2str(round(timers.iter.NLPtotTime,dec)) ...
%                                       '            '  num2str(p.NLP)])
% disp(['QP time:        ' num2str(round(timers.iter.QPtotTime,dec))...
%                                       '            '  num2str(p.QP)])
% disp(['Reg time:       ' num2str(round(timers.iter.RegTotTime,dec))...
%                                       '            '  num2str(p.reg)])
% disp(['Plot time:      ' num2str(round(timers.iter.plotTimer,dec))...
%                                       '            '  num2str(p.plt)])
% output version 2 - 24.02.2020
% disp(['                                                          '])
% disp(['   ===============   Response from ALADIN   =============='])  
disp(['                                                          '])
disp(['   ==================   ALADIN timing   =================='])
name = [" ";
        "Tot time......:";
        "Prob setup....:";
        "Iter time.....:";
        " ---------     ";
        "NLP time......:";
        "QP time.......:";
        "Reg time......:";
        "Plot time.....:"];
    
time = ["t[s]";
        convertCharsToStrings(num2str(round(timers.totTime, dec)));
        convertCharsToStrings(num2str(round(timers.setupT, dec)));
        convertCharsToStrings(num2str(round(timers.iter.iterTime, dec)));
        " ";
        convertCharsToStrings(num2str(round(timers.iter.NLPtotTime, dec)));
        convertCharsToStrings(num2str(round(timers.iter.QPtotTime, dec)));
        convertCharsToStrings(num2str(round(timers.iter.RegTotTime, dec)));
        convertCharsToStrings(num2str(round(timers.iter.plotTimer, dec)))];    

for i = 1 : length(time)
    if str2double(time(i)) < 100
        time(i) = strcat("  ", time(i));
    end
end

perTotTime = ["%tot";
          " ";
          convertCharsToStrings(num2str(p.setup));
          convertCharsToStrings(num2str(p.iter));
          " ";
          " ";
          " ";
          " ";
          " "];
      
perTotIter =    ["%iter"
          " ";
          " ";
          " ";
          " ";
          num2str(p.NLP);
          num2str(p.QP);
          num2str(p.reg);
          num2str(p.plt)];      
      
for i = 3 : 4      
    if (str2double(perTotTime(i)) < 10)
        perTotTime(i) = strcat(" ", perTotTime(i));
    end
end
   
for i = 6 : 9
    if (str2double(perTotIter(i)) < 10)
        perTotIter(i) = strcat(" ", perTotIter(i));
    end
end
      
perTotTime = pad(perTotTime);
time = pad(time);      
perTotIter = pad(perTotIter);

outstr = [name, time, perTotTime, perTotIter];

outstr1 = strcat(outstr,{'   '});
outstr_char = char(outstr1{:});
[m,n] = size(outstr1);
p = size(outstr_char,2);
out = reshape(permute(reshape(outstr_char.',p,m,[]),[1 3 2]),n*p,m).';
disp(out)                                 
end

