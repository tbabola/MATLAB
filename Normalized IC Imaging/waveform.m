function [avgWave, stErr] = waveform(paths)
    m = size(paths,1);
    
    win_before = 20;
    win_after = 50;
    LICavgTraces = [];
    RICavgTraces = [];
    for i=1:m
        load(paths{i});
        t = size(ICsignal,1);
        l_m = size(LICinfo,1);
        l_locs = LICinfo(:,2);
        r_locs = RICinfo(:,2);
        r_m = size(RICinfo,1);
        k = 1;
        LIC_trace = [];
        for j=1:l_m
            loc = l_locs(j);
            if ~(loc <= win_before || (loc + win_after) > t)
                loc_l = loc - win_before;
                loc_r = loc + win_after;
                LIC_trace(:,k) = ICsignal(loc_l:loc_r,1);
                k = k+1;
            end    
        end
        
        k = 1;
        RIC_trace = [];
        for j=1:r_m
            loc = r_locs(j);
            if ~(loc <= win_before || (loc + win_after) > t)
                loc_l = loc - win_before;
                loc_r = loc + win_after;
                RIC_trace(:,k) = ICsignal(loc_l:loc_r,2);
                k = k+1;
            end    
        end
       
        LICavgTraces(:,i) = mean(LIC_trace,2);
        RICavgTraces(:,i) = mean(RIC_trace,2);
        totavgTraces(:,i) = mean([LIC_trace RIC_trace],2);
        
    end
    
    time = [1:1:win_before+win_after+1]'/10;
    lt_org = [255, 166 , 38]/255;
    dk_org = [255, 120, 0]/255;
    lt_blue = [50, 175, 242]/255;
    dk_blue = [0, 13, 242]/255;
    
    
    if m == 1
            totTraces = [LIC_trace, RIC_trace];
            f = figure; 
            set(f,'renderer','painters');
            shadedErrorBar(time, mean(totTraces,2)-mean(totTraces(1,:),2), std(totTraces,1,2)/sqrt(size(totTraces,2)),{'-','color','r'});
            xlim([0 6.5]);
            ylim([-0.01 .15]);
            avgWave = mean(totTraces,2)-mean(totTraces(1,:),2);
            stErr = std(totTraces,1,2)/sqrt(i);
    else
        f = figure; 
        set(f,'renderer','painters');
        shadedErrorBar(time, mean(LICavgTraces,2)-mean(LICavgTraces(1,:),2), std(LICavgTraces,1,2)/sqrt(i),{'-','color',dk_org}); hold on;
        shadedErrorBar(time, mean(RICavgTraces,2)-mean(RICavgTraces(1,:),2), std(RICavgTraces,1,2)/sqrt(i),{'-','color',dk_blue});
        xlim([0 6.5]);
            ylim([-0.01 .15]);
            
         f = figure; 
        set(f,'renderer','painters');
        shadedErrorBar(time, mean(totavgTraces,2)-mean(totavgTraces(1,:),2), std(totavgTraces,1,2)/sqrt(i),{'-'});
        avgWave = mean(totavgTraces,2)-mean(totavgTraces(1,:),2);
        stErr = std(totavgTraces,1,2)/sqrt(i);
        xlim([0 6.5]);
            ylim([-0.01 .15]);
    end
    
    
    
    %plot(mean(LICavgTraces,2)-mean(LICavgTraces(1,:),2)); hold on; plot(mean(RICavgTraces,2)-mean(RICavgTraces(1,:),2));
    
end
