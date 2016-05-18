function [pks,locs] = findISCpeaks(d,time,start,end)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    findpeaks(d*-1,time,'Annotate','extents','MinPeakProminence',50);
    [pks,locs]=findpeaks(d*-1,time,'Annotate','extents','MinPeakProminence',50);
    pks = pks *-1;
    
 
    b_sp = size(b_ISIs,1);
    locs = locs(baselineStart <= locs & locs <= baselineEnd);
    pks = pks(baselineStart <= locs & locs <= baselineEnd);
    baselineFreqHz = b_sp/(baselineEnd-baselineStart);
end

 