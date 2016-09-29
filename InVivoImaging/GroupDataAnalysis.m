load('M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\GroupData_paths.mat');
paths = groupData(:,3);
%load('M:\Bergles Lab Data\Projects\In vivo imaging\P2ry1 KO\groupDataKO.mat');
%paths = groupDataKO(:,3);

groupHistoL = [];
groupHistoR = [];
statsL = table();
statsR = table();
KOmeanHW = [];
KOtotalEvents = [];

load(paths{1});
%     groupHistoL = [groupHistoL histoL];
%     groupHistoR = [groupHistoR histoR];
%     
% for i=1:size(paths)
%     load(paths{i});
%     [smLIC, histobuild, stats] = calculatePeaks(LICmov,0,0);
%     histoL = histobuild;
%     tempL = stats;
%     statsL = [statsL; stats];
%     [smRIC, histobuild, stats] = calculatePeaks(RICmov,1,0);
%     histoR = histobuild;
%     tempR = stats;
%     statsR = [statsR; stats];
%     
%     KOmeanHW = [meanHW; mean([tempL.halfwidths;tempR.halfwidths])];
%     KOtotalEvents = [KOtotalEvents; size(tempL.eventLabels,1)];
%     
    
    
%end

% figure;
% histogram(groupHistoL,50)
% xlim([0,125]);
% 
% figure;
% histogram(groupHistoR,50)
% xlim([0,125]);