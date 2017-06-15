function [groupHistoL,groupHistoR,totalEvents,individualStats] = analGroupDataLR(paths,plotFlag)
    %paths = paths(:,3);
    groupHistoL = [];
    groupHistoR = [];
    totalEvents = [];
    individualStats = [];
    hwtL = [];
    hwtR = [];
    hwxL = [];
    hwxR = [];
    ampL = [];
    ampR = [];
    
    for i=1:size(paths)
        load(paths{i},'-regexp','^(?!LICmov|RICmov)...');
%         load(paths{i});
%         [smLIC, peaksBinaryL] = getPeaks(LICmov,0,0.25);
%         [smRIC, peaksBinaryR] = getPeaks(RICmov,1,0.25);
%         savefile = '\ICmovs_peaks.mat';
%         [path, fn, ext ] = fileparts(paths{i});
%         save([path savefile],'LICmov','RICmov','smLIC','smRIC','peaksBinaryR','peaksBinaryL');
        %size(peaksBinaryR)
        %size(peaksBinaryL)
        
        [peakStat, eventStats] = peakStats(smLIC, peaksBinaryL, smRIC, peaksBinaryR);
       
        %eventStat = table(eventLabel, eventClassification, leftOrRightDom, numPeaks, domAmp, maxLAmp, maxRAmp,xloc, tloc, hwt, hwx);
        peaksL = peakStat{1};
        peaksR = peakStat{2};
        groupHistoL = [groupHistoL; peaksL(:,2)];
        groupHistoR = [groupHistoR; peaksR(:,2)];
        histoLat = [peaksL(:,2); abs(peaksR(:,2)-125)];
        histoLat = histoLat(histoLat > 50);
        histoLat = histoLat(histoLat < 100);
        totalEvents = [totalEvents; eventStats];
        %individualStats(i,:) = [max(eventStats.eventLabel) median(eventStats.domAmp) median(eventStats.hwt) nanmedian(eventStats.hwx) size((find(eventStats.numPeaks > 1)),1)/max(eventStats.eventLabel)*100 size(histoLat,1)];
        
        %left right compariason
        hwtLdist = eventStats.hwt(strcmp('Left', cellstr(eventStats.leftOrRightDom)));
        hwtRdist = eventStats.hwt(strcmp('Right', cellstr(eventStats.leftOrRightDom)));
        hwtL = [hwtL; hwtLdist];
        hwtR = [hwtR; hwtRdist];
        hwtLavg = median(hwtLdist);
        hwtRavg = median(hwtRdist);
        
        hwxLdist = eventStats.hwx(strcmp('Left', cellstr(eventStats.leftOrRightDom)));
        hwxRdist = eventStats.hwx(strcmp('Right', cellstr(eventStats.leftOrRightDom)));
        hwxL = [hwxL; hwxLdist];
        hwxR = [hwxR; hwxRdist];
        hwxLavg = nanmedian(hwxLdist);
        hwxRavg = nanmedian(hwxRdist);
        
        ampLdist = eventStats.domAmp(strcmp('Left', cellstr(eventStats.leftOrRightDom)));
        ampRdist = eventStats.domAmp(strcmp('Right', cellstr(eventStats.leftOrRightDom)));
        ampL = [ampL; ampLdist];
        ampR = [ampR; ampRdist];
        ampLavg = median(ampLdist);
        ampRavg = median(ampRdist);
        individualStats(i,:) = [max(eventStats.eventLabel) median(eventStats.domAmp) median(eventStats.hwt) nanmedian(eventStats.hwx) size((find(eventStats.numPeaks > 1)),1)/max(eventStats.eventLabel)*100 size(histoLat,1)...
            hwtLavg hwtRavg hwxLavg hwxRavg ampLavg ampRavg...
            kstest2(hwtLdist,hwtRdist) kstest2(hwxLdist,hwxRdist) kstest2(ampLdist,ampRdist)];
        
    
    end
    
    if(plotFlag)
          %plotTimeSeries(smLIC, smRIC, peaksBinaryL, peaksBinaryR, peakStat);
          compareFigLR([hwtL hwxL ampL], [hwtR hwxR ampR],groupHistoL, groupHistoR);
        end
    
end