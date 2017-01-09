%% Wildtype data
load('M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\GroupData_paths.mat');
paths = groupData(:,3);
groupHistoL = [];
groupHistoR = [];
groupAmpL = [];
groupAmpR = [];
statsL = table();
statsR = table();
meanHW = [];
totalEvents = [];
individualStats = [];

for i=1:size(paths)
    load(paths{i},'-regexp','^(?!LICmov|RICmov)...');
    %load(paths{i});
    %[smLIC, peaksBinaryL] = getPeaks(LICmov,0);
    %[smRIC, peaksBinaryR] = getPeaks(RICmov,1);
    %savefile = '\ICmovs_peaks.mat';
    %[path, fn, ext ] = fileparts(paths{i});
    %save([path savefile],'LICmov','RICmov','smLIC','smRIC','peaksBinaryR','peaksBinaryL');
    size(peaksBinaryR)
    size(peaksBinaryL)
    
    [peakStat, eventStats] = peakStats(smLIC, peaksBinaryL, smRIC, peaksBinaryR);
    plotTimeSeries(smLIC, smRIC, peaksBinaryL, peaksBinaryR, peakStat);
    %eventStat = table(eventLabel, eventClassification, leftOrRightDom, numPeaks, domAmp, maxLAmp, maxRAmp,xloc, tloc, hwt, hwx);
    individualStats(i,:) = [max(eventStats.eventLabel) median(eventStats.domAmp) median(eventStats.hwt) nanmedian(eventStats.hwx) size((find(eventStats.numPeaks > 1)),1)/max(eventStats.eventLabel)*100];
    peaksL = peakStat{1};
    peaksR = peakStat{2};
    groupHistoL = [groupHistoL; peaksL(:,2)];
    groupHistoR = [groupHistoR; peaksR(:,2)];
    groupAmpL = [groupAmpL; i*ones(size(peaksL,1),1), peaksL];
    groupAmpR = [groupAmpR; i*ones(size(peaksR,1),1), peaksR];
    totalEvents = [totalEvents; eventStats];
%     tempR = stats;
%     statsR = [statsR; stats];
%     
%     meanHW = [meanHW; mean([tempL.halfwidths;tempR.halfwidths])];
%     totalEvents = [totalEvents; size(tempL.eventLabels,1)];

end

%% KO Data
load('M:\Bergles Lab Data\Projects\In vivo imaging\P2ry1 KO\groupDataKO.mat');
paths = groupDataKO(:,3);
KOgroupHistoL = [];
KOgroupHistoR = [];
KOstatsL = table();
KOstatsR = table();
KOmeanHW = [];
KOtotalEvents = [];
KOgroupAmpL = [];
KOgroupAmpR = [];

for i=1:size(paths)
    load(paths{i});
    [smLIC, peaksBinaryL] = getPeaks(LICmov,0);
    [smRIC, peaksBinaryR] = getPeaks(RICmov,1);
    
    
    [peakStat, eventStats] = peakStats(smLIC, peaksBinaryL, smRIC, peaksBinaryR);
    %plotTimeSeries(smLIC, smRIC, peaksBinaryL, peaksBinaryR, peakStat);
    
    peaksL = peakStat{1};
    peaksR = peakStat{2};
    KOgroupHistoL = [KOgroupHistoL; peaksL(:,2)];
    KOgroupHistoR = [KOgroupHistoR; peaksR(:,2)];
    KOgroupAmpL = [KOgroupAmpL; i*ones(size(peaksL,1),1), peaksL];
    KOgroupAmpR = [KOgroupAmpR; i*ones(size(peaksR,1),1), peaksR];
    KOtotalEvents = [KOtotalEvents; eventStats];
end

% %% Plots
figure;
histogram([groupHistoL; abs(groupHistoR-125)],25,'faceColor','black','edgeColor','black','faceAlpha',1)
xlim([0,125]);
hold on;
histogram([KOgroupHistoL; abs(KOgroupHistoR-125)],25,'faceColor','red','edgeColor','black','faceAlpha',1)

figure;
ksdensity([groupHistoL; abs(groupHistoR-125)]);
hold on;
yyaxis right;
ksdensity([KOgroupHistoL; abs(KOgroupHistoR-125)]);
% 
% figure;
% histogram([groupAmpR;groupAmpL],'Normalization','cdf');
% hold on;
% histogram([KOgroupAmpR;KOgroupAmpL],'Normalization','cdf');
%% Vglut3 data
load('M:\Bergles Lab Data\Projects\In vivo imaging\vGluT3 KO\GroupData_paths.mat');
paths = VG3groupData(:,3);

VG3groupHistoL = [];
VG3groupHistoR = [];
VG3groupAmpL = [];
VG3groupAmpR = [];
VG3totalEvents = [];
VG3individualStats = [];


for i=1:size(paths)
    load(paths{i},'-regexp','^(?!LICmov|RICmov)...');
    %[smLIC, peaksBinaryL] = getPeaks(LICmov,0);
    %[smRIC, peaksBinaryR] = getPeaks(RICmov,1);
    
    
    [peakStat, eventStats] = peakStats(smLIC, peaksBinaryL, smRIC, peaksBinaryR);
    plotTimeSeries(smLIC, smRIC, peaksBinaryL, peaksBinaryR, peakStat);
    VG3individualStats(i,:) = [max(eventStats.eventLabel) median(eventStats.domAmp) median(eventStats.hwt) nanmedian(eventStats.hwx) size((find(eventStats.numPeaks > 1)),1)/max(eventStats.eventLabel)*100];
    
    peaksL = peakStat{1};
    peaksR = peakStat{2};
    VG3groupHistoL = [VG3groupHistoL; peaksL(:,2)];
    VG3groupHistoR = [VG3groupHistoR; peaksR(:,2)];
    VG3groupAmpL = [VG3groupAmpL; i*ones(size(peaksL,1),1), peaksL];
    VG3groupAmpR = [VG3groupAmpR; i*ones(size(peaksR,1),1), peaksR];
    VG3totalEvents = [VG3totalEvents; eventStats];
    
   
%     tempR = stats;
%     statsR = [statsR; stats];
%     
%     meanHW = [meanHW; mean([tempL.halfwidths;tempR.halfwidths])];
%     totalEvents = [totalEvents; size(tempL.eventLabels,1)];
end
%% Salicylate data
load('M:\Bergles Lab Data\Projects\In vivo imaging\Salicylate\GroupData_paths.mat');
paths = SalgroupData(:,3);

SalgroupHistoL = [];
SalgroupHistoR = [];
SalgroupAmpL = [];
SalgroupAmpR = [];
SaltotalEvents = [];
SalindividualStats = [];


for i=1:size(paths)
    load(paths{i},'-regexp','^(?!LICmov|RICmov)...');
    %[smLIC, peaksBinaryL] = getPeaks(LICmov,0);
    %[smRIC, peaksBinaryR] = getPeaks(RICmov,1);
    
    
    [peakStat, eventStats] = peakStats(smLIC, peaksBinaryL, smRIC, peaksBinaryR);
    %plotTimeSeries(smLIC, smRIC, peaksBinaryL, peaksBinaryR, peakStat);
    SalindividualStats(i,:) = [max(eventStats.eventLabel) median(eventStats.domAmp) median(eventStats.hwt) nanmedian(eventStats.hwx)];
    
    peaksL = peakStat{1};
    peaksR = peakStat{2};
    SalgroupHistoL = [SalgroupHistoL; peaksL(:,2)];
    SalgroupHistoR = [SalgroupHistoR; peaksR(:,2)];
    SalgroupAmpL = [SalgroupAmpL; i*ones(size(peaksL,1),1), peaksL];
    SalgroupAmpR = [SalgroupAmpR; i*ones(size(peaksR,1),1), peaksR];
    SaltotalEvents = [SaltotalEvents; eventStats];
    
%     tempR = stats;
%     statsR = [statsR; stats];
%     
%     meanHW = [meanHW; mean([tempL.halfwidths;tempR.halfwidths])];
%     totalEvents = [totalEvents; size(tempL.eventLabels,1)];
end


%%a9 data
% load('M:\Bergles Lab Data\Projects\In vivo imaging\a9 KO\GroupData_paths.mat');
%  paths = a9groupData(:,3);
% 
% a9groupHistoL = [];
% a9groupHistoR = [];
% a9groupAmpL = [];
% a9groupAmpR = [];
% a9totalEvents = [];
% 
% 
% for i=1:size(paths)
%     load(paths{i});
%     [smLIC, peaksBinaryL] = getPeaks(LICmov,0);
%     [smRIC, peaksBinaryR] = getPeaks(RICmov,1);
%     
%     
%     [peakStat, eventStats] = peakStats(smLIC, peaksBinaryL, smRIC, peaksBinaryR);
%     %plotTimeSeries(smLIC, smRIC, peaksBinaryL, peaksBinaryR, peakStat);
%     
%     peaksL = peakStat{1};
%     peaksR = peakStat{2};
%     a9groupHistoL = [a9groupHistoL; peaksL(:,2)];
%     a9groupHistoR = [a9groupHistoR; peaksR(:,2)];
%     a9groupAmpL = [a9groupAmpL; i*ones(size(peaksL,1),1), peaksL];
%     a9groupAmpR = [a9groupAmpR; i*ones(size(peaksR,1),1), peaksR];
%     a9totalEvents = [a9totalEvents; eventStats];
%     
% %     tempR = stats;
% %     statsR = [statsR; stats];
% %     
% %     meanHW = [meanHW; mean([tempL.halfwidths;tempR.halfwidths])];
% %     totalEvents = [totalEvents; size(tempL.eventLabels,1)];
% end
% 
% close all;

%% Plot
figure;
cutoff =0;
subplot(3,1,1);
cdfplot(totalEvents.hwx(totalEvents.domAmp > cutoff)*7.45);
hold on;
%cdfplot(KOtotalEvents.hwx);
cdfplot(VG3totalEvents.hwx(VG3totalEvents.domAmp > cutoff)*7.45);
%cdfplot(a9totalEvents.hwx);
%cdfplot(SaltotalEvents.hwx(SaltotalEvents.domAmp > 20));
xlabel('Spatial Spread (\mum)');
legend('WT','vG3 KO');
%set(gcf,'XTicks',0:25:125,'XLabels',num2str(7.65*[0:25:125]),1,5);
% 
subplot(3,1,2);
cdfplot(totalEvents.hwt(totalEvents.domAmp > cutoff)/10);
hold on;
%cdfplot(KOtotalEvents.hwt);
cdfplot(VG3totalEvents.hwt(VG3totalEvents.domAmp > cutoff)/10);
%cdfplot(a9totalEvents.hwt);
%cdfplot(SaltotalEvents.hwt(SaltotalEvents.domAmp > 20));
xlabel('Half-width (s)');
legend('WT','vG3 KO');

subplot(3,1,3);
cdfplot(totalEvents.domAmp);
hold on;
%cdfplot(KOtotalEvents.hwt);
cdfplot(VG3totalEvents.domAmp);
%cdfplot(a9totalEvents.hwt);
%cdfplot(SaltotalEvents.domAmp);
xlabel('Amplitude (AIU)');
legend('WT','vG3 KO');

