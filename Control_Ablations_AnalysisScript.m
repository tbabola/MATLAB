
addpath('C:\Users\Bergles Lab\Documents\MATLAB\MATLAB\OldRoutines\findICpeaks.m'); %add Matlab path to find peaks
%%
close all;
wt = 'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-342_P2ry1het_ds.tif_PCA\ICinfo_PCA.mat';
load(wt);
findICpeaks(ICsignal,filePath,'PCA');
%%
close all;
uniR = 'M:\Bergles Lab Data\Projects\In vivo imaging\Unilateral Ablations\Right Ablations\DUP_Experiment-373_processed\DUP_Experiment-373-ds_PCA\DUP_Experiment-373-ds_PCA\ICinfo_PCA.mat';
load(uniR);
findICpeaks(ICsignal,filePath,'PCA');
%%
close all;
uniL = 'M:\Bergles Lab Data\Projects\In vivo imaging\Unilateral Ablations\Left Ablations\DUP_Experiment-320_processed\DUP_Experiment-320-ds_PCAallcomponents\ICinfo_PCA.mat';
load(uniL);findICpeaks(ICsignal,filePath,'PCA');


%% Wildtype Animals
wt_paths = {'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-265-P7_Wildtype_PCA\ICinfo_PCA.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-267-P7_Wildtype_PCA\ICinfo_PCA.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-314-P6_Wildtype_PCA\ICinfo_PCA.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-330_processed\DUP_Experiment-330-ds_PCApro\ICinfo_PCA.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-337-ds_PCApro\ICinfo_PCA.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-342_P2ry1het_ds.tif_PCA\ICinfo_PCA.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-495-P7-Snap25GC6s_Wildtype_PCA\ICinfo_PCA.mat'};
 
[stats] = groupData(wt_paths);


 function [stats] = groupData(paths)
     m = size(paths,1);
     WT_individualStats = [];
     WT_rpks = []
     WT_lpks = [];

     for i = 1:m
         load(paths{i});
         pkData = findICpeaks(ICsignal,filePath,'PCA');
         stats = [stats; stats1];
         rpks = [rpks; pkData((pkData(:,7)==2),4)];
         lpks = [lpks; pkData((pkData(:,7)==1),2)];
     end
    lt_org = [255, 166 , 38]/255;
    dk_org = [255, 120, 0]/255;
    lt_blue = [50, 175, 242]/255;
    dk_blue = [0, 13, 242]/255;
    
    figure;
    Rcounts= histcounts(rpks,[0:6:42 100],'Normalization','probability');
    Lcounts =histcounts(lpks,[0:6:42 100],'Normalization','probability');
    binY = [3:6:45];
    
    figure;
        h=barh(binY,Rcounts,.9);
        hold on;
        barh(binY,-Lcounts,.9,'FaceColor',lt_org,'EdgeColor','none');
        %barh(Lbins,-Lcounts,.9,'FaceColor',lt_org,'EdgeColor',lt_org);
        h.FaceColor = lt_blue;
        h.EdgeColor = 'none';
        ylim([0 50]);
        yticks([0 25 50]);
        box off;
 end
    

