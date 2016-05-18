function [ctxBright] = ctx_PkRemoval(ctxSignal)
    time = [1:1:size(ctxSignal,1)]';
    [pks,locs,w] = findpeaks(msbackadj(time,ctxSignal),'MinPeakProminence',200,'MaxPeakWidth',40,'Annotate','extents');
    
    ctxBright = zeros(size(ctxSignal));
    for i = 1:size(locs)
        mid = locs(i)
        lower = mid - int16(w(i)/2)
        upper = mid + int16(w(i)/2)
        ctxBright(lower:upper)=1;
    end
    
end
