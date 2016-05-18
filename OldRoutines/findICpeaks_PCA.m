function [LICinfo,RICinfo] = findICpeaks_PCA(ICsignal,filePath,analysisName)
    if ~exist('analysisName','var')
        analysisName = 'stock';
    end
    time = [1:1:size(ICsignal,1)]';
    LIC = msbackadj(time,smooth(ICsignal(:,1)));
    RIC = msbackadj(time,smooth(ICsignal(:,2)));
     
    %parameters
    pkThreshold = 1;
    pkMinHeight = 1;
    pkDistance = 5; %in frame, 10 = 1s
    [pks,locs,w] = findpeaks(LIC,'MinPeakProminence',pkThreshold,'MinPeakHeight',pkMinHeight,'MinPeakDistance',pkDistance,'Annotate','extents');
    pksLIC = pks;
    locsLIC = locs;
    wLIC = w;
    LICinfo = [pksLIC locsLIC wLIC];
    
    
    [pks,locs,w] = findpeaks(RIC,'MinPeakProminence',pkThreshold,'MinPeakHeight',pkMinHeight,'MinPeakDistance',pkDistance,'Annotate','extents');
    pksRIC = pks;
    locsRIC = locs;
    wRIC = w;
    RICinfo = [pksRIC locsRIC wRIC];
   
    
    figure;
        plot(time/10,LIC);
        hold on;
        plot(time/10,RIC);
        plot(locsRIC/10,pksRIC,'o');
        plot(locsLIC/10,pksLIC,'o');
        ylabel('Amplitude (AIU)')
        xlabel('Time (s)');
    savefig([filePath,'dfof_',analysisName]);

    [LtoRpks,LtoRlocs] = ICcompare(pksLIC,locsLIC,pksRIC,locsRIC);
    LtoRpks = LtoRpks(all(~isnan(LtoRpks),2),:);
    LtoRlocs = LtoRlocs(all(~isnan(LtoRpks),2),:);
    disp(['LIC: ',num2str(size(pksLIC,1)),' peaks total, ',num2str(size(LtoRpks,1)),' corresponding RIC peaks.']);
    
    [RtoLpks,RtoLlocs] = ICcompare(pksLIC,locsLIC,pksRIC,locsRIC);
    RtoLpks = RtoLpks(all(~isnan(RtoLpks),2),:);
    RtoLlocs = RtoLlocs(all(~isnan(RtoLpks),2),:);
    disp(['RIC: ',num2str(size(pksRIC,1)),' peaks total, ',num2str(size(RtoLpks,1)),' corresponding LIC peaks.']);
    disp(['Mean RIC amplitude: ', num2str(mean(pksRIC))]);
    disp(['Mean LIC amplitude: ', num2str(mean(pksLIC))]);
    
    figure;
        scatter(LtoRpks(:,1),LtoRpks(:,2));
        hold on;
        refline(1,0);
        xlabel('LIC Amplitude (AIU)');
        ylabel('RIC Ampltiude (AIU)');
    savefig([filePath,'amplScatter_',analysisName]);
    
    save([filePath,['ICinfo_',analysisName]],'LICinfo','RICinfo','ICsignal','filePath');
    
end

function [mPks,mLocs] = ICcompare(master_pks,master_locs,pks,locs)
   windowforhit = 10;
   mPks = NaN(size(master_pks,1),2);
   mLocs = NaN(size(master_pks,1),2);
   
   for i=1:size(master_pks,1)
        match = 0;
        j = 1;
        while match == 0
            if abs(master_locs(i)-locs(j)) <= windowforhit
                mPks(i,1:2) = [master_pks(i) pks(j)];
                mLocs(i,1:2) = [master_locs(i) locs(j)];
                match = 1;
            else
                j = j+1;
            end
            if j > size(pks,1)
                match = 1;
            end
        end
   end
end