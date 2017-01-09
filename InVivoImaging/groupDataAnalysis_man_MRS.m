%% Mannitol data
load('F:\Bergles Lab Data\Projects\In vivo imaging\Bilateral Mannitol Sham\GroupData_paths.mat');
paths = manGroupData(:,3);
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
    individualStats(i,:) = [max(eventStats.eventLabel) median(eventStats.domAmp) median(eventStats.hwt) nanmedian(eventStats.hwx) (eventStats.numPeaks > 1)/max(eventStats.eventLabel)*100];
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

%% MRS data
load('F:\Bergles Lab Data\Projects\In vivo imaging\MRS2500 to RWM\GroupDataBi_paths.mat');
paths = MRSgroupData(:,3);
MRSgroupHistoL = [];
MRSgroupHistoR = [];
MRSgroupAmpL = [];
MRSgroupAmpR = [];
MRSstatsL = table();
MRSstatsR = table();
MRSmeanHW = [];
MRStotalEvents = [];
MRSindividualStats = [];

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
    MRSindividualStats(i,:) = [max(eventStats.eventLabel) median(eventStats.domAmp) median(eventStats.hwt) nanmedian(eventStats.hwx)];
    peaksL = peakStat{1};
    peaksR = peakStat{2};
    MRSgroupHistoL = [groupHistoL; peaksL(:,2)];
    MRSgroupHistoR = [groupHistoR; peaksR(:,2)];
    MRSgroupAmpL = [groupAmpL; i*ones(size(peaksL,1),1), peaksL];
    MRSgroupAmpR = [groupAmpR; i*ones(size(peaksR,1),1), peaksR];
    MRStotalEvents = [totalEvents; eventStats];
%     tempR = stats;
%     statsR = [statsR; stats];
%     
%     meanHW = [meanHW; mean([tempL.halfwidths;tempR.halfwidths])];
%     totalEvents = [totalEvents; size(tempL.eventLabels,1)];

end

%% Plot 2
figure;
subplot(1,3,1);
box off; grid off;
cdfplot(totalEvents.hwx*7.45);
hold on;
%cdfplot(KOtotalEvents.hwx);
cdfplot(MRStotalEvents.hwx*7.45);
%cdfplot(a9totalEvents.hwx);
%cdfplot(SaltotalEvents.hwx(SaltotalEvents.domAmp > 20));
xlabel('Spatial Sread (\mum)');
legend('Sham','MRS2500');
%set(gcf,'XTicks',0:25:125,'XLabels',num2str(7.65*[0:25:125]),1,5);
% 
subplot(1,3,2);
box off; grid off;
cdfplot(totalEvents.hwt/10);
hold on;
%cdfplot(KOtotalEvents.hwt);
cdfplot(MRStotalEvents.hwt/10);
%cdfplot(a9totalEvents.hwt);
%cdfplot(SaltotalEvents.hwt(SaltotalEvents.domAmp > 20));
xlabel('Half-width (s)');
legend('Sham','MRS2500');

subplot(1,3,3);
box off; grid off;
cdfplot(totalEvents.domAmp);
hold on;
%cdfplot(KOtotalEvents.hwt);
cdfplot(MRStotalEvents.domAmp);
%cdfplot(a9totalEvents.hwt);
%cdfplot(SaltotalEvents.domAmp);
xlabel('Amplitude (AIU)');
legend('Sham','MRS2500');

figure;
ind = size(individualStats,1);
MRS = size(MRSindividualStats,1);
subplot(1,4,1);
plot(ones(ind,1),individualStats(:,1)/10,'o');
hold on;
plot(2*ones(MRS,1),MRSindividualStats(:,1)/10,'o');
xlim([0 3]);
ylim([0 30]);
box off;

subplot(1,4,2);
plot(ones(ind,1),individualStats(:,2),'o');
hold on;
plot(2*ones(MRS,1),MRSindividualStats(:,2),'o');
xlim([0 3]);
ylim([0 30]);
box off;

subplot(1,4,3);
plot(ones(ind,1),individualStats(:,3)/10,'o');
hold on;
plot(2*ones(MRS,1),MRSindividualStats(:,3)/10,'o');
xlim([0 3]);
ylim([0 5]);
box off;

subplot(1,4,4);
plot(ones(ind,1),individualStats(:,4)*7.45,'o');
hold on;
plot(2*ones(MRS,1),MRSindividualStats(:,4)*7.45,'o');
xlim([0 3]);
ylim([0 800]);
box off;


