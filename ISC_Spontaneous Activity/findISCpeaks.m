function [pks,locs, int] = findISCpeaks(d,time,x)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    baseline_start = x(1);
    baseline_end = x(2);

    %findpeaks(d*-1,time,'Annotate','extents','MinPeakProminence',50);
    [pks,locs]=findpeaks(d*-1,time,'Annotate','extents','MinPeakProminence',40);
    pks = pks *-1;
end

