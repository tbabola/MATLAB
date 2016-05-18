function [ time, d ] = extractABR( x )   
    time = x.AverageData(:,1);
    d = x.AverageData(:,4);  
end

