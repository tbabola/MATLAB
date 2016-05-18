function [LICinfo,RICinfo] = findICpeaks(ICsignal,filePath,analysisName)
    if ~exist('analysisName','var')
        analysisName = 'stock';
    end
    time = [1:1:size(ICsignal,1)]';
    LIC = msbackadj(time,smooth(ICsignal(:,1),3));
    RIC = msbackadj(time,smooth(ICsignal(:,2),3));
    bg = msbackadj(time,smooth(ICsignal(:,3),3));
    
    
    %parameters
    pkThreshold = 1;
    pkMinHeight = 1;
    pkDistance = 5; %in frame, 10 = 1s
    [pks,locs,w] = findpeaks(LIC,'MinPeakProminence',pkThreshold,'MinPeakHeight',pkMinHeight,'MinPeakDistance',pkDistance,'Annotate','extents');
    LIC_itk = ctx_PkRemoval(bg, locs);
    pksLIC = pks(LIC_itk);
    locsLIC = locs(LIC_itk);
    wLIC = w(LIC_itk);
    LICinfo = [pksLIC locsLIC wLIC];
    
    
    [pks,locs,w] = findpeaks(RIC,'MinPeakProminence',pkThreshold,'MinPeakHeight',pkMinHeight,'MinPeakDistance',pkDistance,'Annotate','extents');
    RIC_itk = ctx_PkRemoval(bg, locs);
    pksRIC = pks(RIC_itk);
    locsRIC = locs(RIC_itk);
    wRIC = w(RIC_itk);
    RICinfo = [pksRIC locsRIC wRIC];
   
    
    figure;
    subplot(2,1,1);
        plot(time/10,LIC);
        hold on;
        plot(time/10,RIC);
        plot(locsRIC/10,pksRIC,'o');
        plot(locsLIC/10,pksLIC,'o');
        ylabel('Amplitude (AIU)')
        xlabel('Time (s)');
    subplot(2,1,2);
        plot(time/10,bg);
        ylabel('Amplitude (AIU)')
        xlabel('Time (s)');
    savefig([filePath,'dfof_bg_',analysisName]);

    [LtoRpks,LtoRlocs] = ICcompare(pksLIC,locsLIC,pksRIC,locsRIC);
    LtoRpks = LtoRpks(all(~isnan(LtoRpks),2),:);
    LtoRlocs = LtoRlocs(all(~isnan(LtoRpks),2),:);
    totLpks = size(pksLIC,1);
    totLcorrPks = size(LtoRpks,1);
    disp(['LIC: ',num2str(size(pksLIC,1)),' peaks total, ',num2str(size(LtoRpks,1)),' corresponding RIC peaks.']);
    
    [RtoLpks,RtoLlocs] = ICcompare(pksLIC,locsLIC,pksRIC,locsRIC);
    RtoLpks = RtoLpks(all(~isnan(RtoLpks),2),:);
    RtoLlocs = RtoLlocs(all(~isnan(RtoLpks),2),:);
    totRpks = size(pksRIC,1);
    totRcorrPks = size(RtoLpks,1);
    disp(['RIC: ',num2str(size(pksRIC,1)),' peaks total, ',num2str(size(RtoLpks,1)),' corresponding LIC peaks.']);
    disp(['Mean RIC amplitude: ', num2str(mean(pksRIC))]);
    disp(['Mean LIC amplitude: ', num2str(mean(pksLIC))]);
    stats = [totLpks totLcorrPks totLcorrPks/totLpks totRpks totRcorrPks totRcorrPks/totRpks mean(pksLIC) mean(pksRIC)];
    assignin('base','stats',stats);
    figure;
        scatter(LtoRpks(:,1),LtoRpks(:,2));
        hold on;
        refline(1,0);
        xlabel('LIC Amplitude (AIU)');
        ylabel('RIC Ampltiude (AIU)');
    savefig([filePath,'amplScatter_',analysisName]);
    
    save([filePath,['ICinfo_',analysisName]],'LICinfo','RICinfo','ICsignal','filePath');
    events = graphLocsOnly(pksLIC, locsLIC, pksRIC, locsRIC); 
    figure;
    assignin('base','events',events);
    plot(events(:,1),'s','Color','red');
    hold on;
    plot(events(:,2),'s','Color','black');
    plot(events(:,3),'s','Color','red','MarkerFaceColor','red');
    plot(events(:,4),'s','Color','black','MarkerFaceColor','black');
    figure;
    plot(events(:,5),'s','Color','red','MarkerFaceColor','red');
    hold on;
    plot(events(:,6),'s','Color','black','MarkerFaceColor','black');
    
%     figure;
%     plot(sortrows(events),'s');
%     figure;
%     events(:,[1,2])=events(:,[2,1]);
%     plot(sortrows(events),'s');
    figure;
    plot(abs(events(:,1)-events(:,2)),'s');
    hold on;
    plot(smooth(abs(events(:,1)-events(:,2)),3));
end

function ICcompare2(master_pks,master_locs,pks,locs)
    windowforhit = 10;
    
    pkData; %col 1: LIC loc, 2: LIC pk, 3:RIC loc, 4:RIC pk, 5:delta, 6: which is bigger (1=LIC, 2=RIC)
    
    for i=1:size(master_pks,1)
        match = 0;
        j = 1;
        while match == 0
            if abs(master_locs(i)-locs(j,1)) <= windowforhit & locs(j,2) ~= 1
                pkData(i, 1:5) = [master_locs(i) master_pks(i) locs(j,1) pks(j) abs(pks(j)-pks(i))];
                locs(j,2) = 1;
                match = 1;
            else
                j = j+1;
            end
            if j > size(pks,1)
                match = 1;
                pkData(i, 1:5) = [master_locs(i) master_pks(i) master_locs(i) 0 abs(pks(j)-pks(i))];
            end
        end
   end
    
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

function [indexToKeep] = ctx_PkRemoval(ctxSignal, IClocs)
    time = [1:1:size(ctxSignal,1)]';
    [pks,locs,w] = findpeaks(msbackadj(time,ctxSignal),'MinPeakHeight',10,'MaxPeakWidth',40,'Annotate','extents');
    
    ctxBright = zeros(size(ctxSignal));
    for i = 1:size(locs)
        mid = locs(i);
        lower = mid - int16(w(i)/1.25);
        if(lower < 1)
            lower = 1;
        end
        upper = mid + int16(w(i)/1.25);
        if upper > size(ctxSignal,1)
            upper = size(ctxSignal,1);
        end
        disp([lower '  ' upper])
        ctxBright(lower:upper) = 1;
    end
    
    indexToKeep = [];
    for i=1:size(IClocs)
        if ctxBright(IClocs(i)) == 0
            indexToKeep = [indexToKeep i];
        end      
    end
end

function [events] = graphLocsOnly(pks1,locs1,pks2,locs2)
    windowforhit = 10;
    
    result_index = 1;
    events = []; %small 1, small 2, big 1, big 2
    while ~isempty(locs1) & ~isempty(locs2)
        if isempty(locs1)
           events(result_index,4) = pks2(1);
           events(result_index,6) = 1;
           events(result_index,1) = -1;
           locs2(1) = [];
           pks2(1) = [];
           result_index = result_index + 1;
        elseif isempty(locs2)
           events(result_index,3) = pks1(1);
           events(result_index,5) = 1;
           events(result_index,2) = -1;
           locs1(1) = [];
           pks1(1) = [];
           result_index = result_index + 1;
        else
            if locs1(1) < locs2(1)
                %check if match
                match = 0;
                j = 1;
                while match == 0
                    if abs(locs1(1)-locs2(j)) <= windowforhit
                        %events(result_index,2) = pks2(j);
                        if pks2(j) > pks1(1)
                            events(result_index,4)=pks2(j);
                            events(result_index,1)=pks1(1);
                            events(result_index,6) = 1;
                        else
                            events(result_index,2)=pks2(j);
                            events(result_index,3)=pks1(1);
                            events(result_index,5) = 1;
                        end
                        locs2(j) = [];
                        pks2(j) = [];
                        match = 1;
                    else
                        j = j+1;
                    end
                    if j > size(locs2,1)
                        match = 1;
                        events(result_index,3)=pks1(1);
                        events(result_index,5) = 1;
                        events(result_index,2)=-1;
                    end
                end
                locs1(1) = [];
                pks1(1) = [];
            else
                %check if match
                match = 0;
                j = 1;
                while match == 0
                    if abs(locs1(j)-locs2(1)) <= windowforhit
                        if pks2(j) > pks1(1)
                            events(result_index,4)=pks2(1);
                            events(result_index,1)=pks1(j);
                            events(result_index,6) = 1;
                        else
                            events(result_index,2)=pks2(1);
                            events(result_index,3)=pks1(j);
                            events(result_index,5) = 1;
                        end
                        locs1(j) = [];
                        pks1(j) = [];
                        match = 1;
                    else
                        j = j+1;
                    end
                    if j > size(locs1,1)
                        match = 1;
                        events(result_index,4)=pks2(1);
                        events(result_index,6) = 1;
                        events(result_index,1)=-1;
                    end
                end
                locs2(1) = [];
                pks2(1) = [];
            end  
            result_index = result_index + 1;
        end
    end
   
    events(events==0)=NaN;
    events(events==-1)=0;
end
