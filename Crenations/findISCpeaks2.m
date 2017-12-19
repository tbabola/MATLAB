function [pks,locs] = findISCpeaks2(d,time,thr)
    [pks,locs]=findpeaks(d*-1,time,'Annotate','extents','MinPeakProminence',thr);
    pks = pks *-1;
end