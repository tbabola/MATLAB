%load('M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\GroupData_paths.mat');
%paths = groupData(:,3);
load('M:\Bergles Lab Data\Projects\In vivo imaging\P2ry1 KO\groupDataKO.mat');
paths = groupDataKO(:,3);

groupHistoL = [];
groupHistoR = [];
for i=1:size(paths)
    load(paths{i});
    groupHistoL = [groupHistoL histoL];
    groupHistoR = [groupHistoR histoR];
end

% figure;
% histogram(groupHistoL,50)
% xlim([0,125]);
% 
% figure;
% histogram(groupHistoR,50)
% xlim([0,125]);