function [ sum ] = cellPlus( C )
%CELLPLUS Summary of this function goes here
%   Detailed explanation goes here
sum = 0;    
for i=1:length(C)
sum = sum + C{i};        
end
end

