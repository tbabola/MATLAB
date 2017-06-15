%%Figs for paper

%% Figure 1
rawFile = 'C:\Users\Bergles Lab\Desktop\temp\Experiment-330-P8-Snap25GC6s_baseline.tif';
pathStr = fileparts(rawFile);
img = loadTif(rawFile,16);
norm = normalizeImg(img,10,1);
filt = imgaussfilt3(norm(:,:,1:3000));

handle = implay(filt);
handle.Visual.ColorMap.MapExpression = 'gfb';
handle.Visual.ColorMap.UserRangeMin = -0.1;
handle.Visual.ColorMap.UserRangeMax = 0.8;

% = imgaussfilt3(norm(:,:,1:2058));

low = -.1;
hi = 0.8;
images = [1826; 1906; 1921; 1955; 2003; 2025; 2058];
%images = [288; 328; 368; 
figure(3);
box off; axis off;
m = size(images,1);
for i = 1:m
    subplot(1,m,i);
    imagesc(flipud(filt(100:450,:,images(i))));
    box off; axis off;
    colormap(gfb);
    caxis([low hi]);
    UL=[512*m 300];
    po=get(gcf,'position');
    po(3:4)=UL;
    set(gcf,'position',po);
    %imwrite([pathStr '\' num2str(i) '.tif'],
end

%%correlations
hand = figure(7);
norm_crop = flipud(norm(100:300,:,:));
imagesc(std(norm_crop,1,3));
[x, y] = getpts(hand);
x = round(x);
y = round(y);
[m,n,t] = size(norm_crop);
re_normcrop = single(reshape(norm_crop,m*n,t));

for i = 1:size(x,1)
seed = squeeze(single(norm_crop(y(i),x(i),:)));
    corrmat = corr(seed, re_normcrop');
    corrmatstore(:,:,i) = reshape(corrmat,m,n);
end

low = 0;
hi = 1;
figure(8);
m = size(x,1);
for i = 1:m
    subplot(m,1,i);
    %axesHand = axes;
    imagesc(corrmatstore(10:end,10:end,i));
    box off; axis off;
    colormap(parula);
    caxis([low hi]);
end
figure(9);
meanImg = imgaussfilt(mean(norm_crop,3));
imagesc(meanImg(10:end,10:end));
box off; axis off;
colormap(gfb);
caxis([0.02 .14]);







%load ICinfo
load('M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-330_processed\ICinfo16_dFoF.mat');
[m,n] = size(ICsignal);
smIC = smooth(ICsignal);
smIC = reshape(smIC,m,n);
lt_org = [255, 166 , 38]/255;
dk_org = [255, 120, 0]/255;
lt_blue = [50, 175, 242]/255;
dk_blue = [0, 13, 242]/255;
start = 1800;
endpt = 2800;
time = [1:1:(endpt-start+1)]'/10;
figure(4);
hold off;
plot(time,smIC(start:endpt,1),'Color',lt_org);
hold on;
plot(time,smIC(start:endpt,2),'Color',lt_blue);
indices = find(pkData(:,1) >= start & pkData(:,1) <=endpt);
temp_pkData = pkData(indices,:);
[m, n] = size(temp_pkData);
temp_pkData(:,[1 3]) = (temp_pkData(:,[1 3]) - [start*ones(m,1) start*ones(m,1)])/10;
r_pkData = temp_pkData(temp_pkData(:,7)==2,:);
l_pkData = temp_pkData(temp_pkData(:,7)==1,:);
scatter(r_pkData(:,3),r_pkData(:,4),r_pkData(:,5)*500,dk_blue,'filled');
scatter(l_pkData(:,1),l_pkData(:,2),l_pkData(:,5)*500,dk_org,'filled');

%%sound evoked activity
rawFile = 'M:\Bergles Lab Data\Projects\In vivo imaging\Sound Evoked\Experiment-745-2.t_PCA-2.tif';
se_PCAimg = loadTif(rawFile,32);
images = [ 232; 190; 284];
low = -100;
hi = 1200;
%images = [288; 328; 368; 
figure(6);
box off; axis off;
m = size(images,1);
for i = 1:m
    subplot(1,m,i);
    imagesc(se_PCAimg(:,:,images(i)));
    box off; axis off;
    colormap(gfb);
    if i == 1
    caxis([low hi]);
    else
        caxis([low hi-100]);
    end
    UL=[200*m 200];
    po=get(gcf,'position');
    po(3:4)=UL;
    set(gcf,'position',po);
    %imwrite([pathStr '\' num2str(i) '.tif'],
end


%%example
rawFile = 'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-330_processed\DUP_Experiment-330-ds_PCApro\PCA_330.tif';
PCAimg = loadTif(rawFile,32);
images = [354; 637; 806];

low = -10;
hi = 120;
%images = [288; 328; 368; 
figure(5);
box off; axis off;
m = size(images,1);
for i = 1:m
    subplot(1,m,i);
    imagesc(PCAimg(:,:,images(i)));
    box off; axis off;
    colormap(gfb);
    caxis([low hi]);
    UL=[200*m 200];
    po=get(gcf,'position');
    po(3:4)=UL;
    set(gcf,'position',po);
    %imwrite([pathStr '\' num2str(i) '.tif'],
end





rawFile = 'M:\Bergles Lab Data\Projects\In vivo imaging\Bilateral Mannitol Sham\DUP_Experiment-618_P7_Snap25GC6s_bilat_mannitol_PCA\Experiment-618_P7_Snap25GC6s_bilat_mannitol.tif';
pathStr = fileparts(rawFile);
img = loadTif(rawFile,16);
img = img(:,:,2900:5900);
norm = normalizeImg(img,10,1);
filt = imgaussfilt3(norm);

handle = implay(filt);
handle.Visual.ColorMap.MapExpression = 'gfb';
handle.Visual.ColorMap.UserRangeMin = -0.1;
handle.Visual.ColorMap.UserRangeMax = 0.8;

low = -.1;
hi = 0.8;
images = [1694;; ];
figure(3);
for i = 1:size(images,1)
    subplot(1,6,i);
    imagesc(filt(100:450,:,images(i)));
    colormap(gfb);
    caxis([low hi]);
    UL=[512*6 300];
    po=get(gcf,'position');
    po(3:4)=UL;
    set(gcf,'position',po);
    %imwrite([pathStr '\' num2str(i) '.tif'],
end


%% figure 2


%% Figure 3
file = 'M:\Bergles Lab Data\Projects\In vivo imaging\Auditory Cortex and IC Imaging\Downsample\Experiment-820_resampled_corrdfof.mat';
load(file);
%%dfOF
figure;
plot(ICsignal+2,'k');
hold on;
plot(ACsignal+1,'k');
plot(V1signal,'k');
xlim([1450 3200]);
set(gcf, 'Renderer', 'Painters');

figure;
figure;
plot(ICsignal*2-.02);
hold on;
plot(ACsignal,'k');
xlim([1520 1640]);

ctxabl_paths = {'M:\Bergles Lab Data\Projects\In vivo imaging\Auditory Cortex Ablation\Experiment-652_P7_Snap25GC6s_AC_ablation\ICinfo16_dFoF.mat';
                'M:\Bergles Lab Data\Projects\In vivo imaging\Auditory Cortex Ablation\Experiment-689_P7_Snap25GC6s_AC_ablation\ICinfo16_dFoF.mat';
                'M:\Bergles Lab Data\Projects\In vivo imaging\Auditory Cortex Ablation\Experiment-690_P7_Snap25GC6s_AC_ablation\ICinfo16_dFoF.mat';
                'M:\Bergles Lab Data\Projects\In vivo imaging\Auditory Cortex Ablation\Experiment-693_P7_Snap25GC6s_AC_ablation\ICinfo16_dFoF.mat';
                'M:\Bergles Lab Data\Projects\In vivo imaging\Auditory Cortex Ablation\Experiment-712_P7_Snap25GC6s_AC_ablation\ICinfo16_dFoF.mat';
                'M:\Bergles Lab Data\Projects\In vivo imaging\Auditory Cortex Ablation\Discarded because of image quality\Experiment-660_P7_Snap25GC6s_AC_ablation\ICinfo16_dFoF.mat';
                'M:\Bergles Lab Data\Projects\In vivo imaging\Auditory Cortex Ablation\Discarded because of image quality\Experiment-709_P7_Snap25GC6s_AC_ablation\ICinfo16_dFoF.mat';
                'M:\Bergles Lab Data\Projects\In vivo imaging\Auditory Cortex Ablation\Discarded because of image quality\Experiment-710_P7_Snap25GC6s_AC_ablation\ICinfo16_dFoF.mat';
                'M:\Bergles Lab Data\Projects\In vivo imaging\Auditory Cortex Ablation\Discarded because of image quality\Experiment-716_P7_Snap25GC6s_AC_ablation\ICinfo16_dFoF.mat';
                }
                
[m] = size(ctxabl_paths(:,1));
stats = [];
stats_tot = table();
for i=1:m
    load(ctxabl_paths{i});
    stats_tot = [stats_tot; stats];
end

lgray=  [.8 0.8 .8];
figure(4);
subplot(1,3,1);
stats_tot = stats_tot(1:5,:);
meanAmpl = mean(stats_tot{:,8:9}/10);
stdAmpl = std(stats_tot{:,8:9}/10);
m = size(stats_tot,1);
scatter([ones(1,m) 2*ones(1,m)], [stats_tot{:,8}/10; stats_tot{:,9}/10],'filled','MarkerFaceColor',lgray);
errorbar([1 2], meanAmpl, stdAmpl,'LineStyle', 'none','Color','k','CapSize',0,'Marker','.','MarkerSize',20);
line([ones(1,m); 2*ones(1,m)], [stats_tot{:,8}/10, stats_tot{:,9}/10]','Color',lgray);
xlim([0.5 2.5]);
ylim([0 15]);
xticks([1 2])
xticklabels({'Left','Right'});
ylabel('Frequency of Dominant Events (events/min)');

subplot(1,3,3);
meanAmpl = mean(stats_tot{:,4:5}*100);
stdAmpl = std(stats_tot{:,4:5}*100);
m = size(stats_tot,1);
scatter([ones(1,m) 2*ones(1,m)], [stats_tot{:,4}*100; stats_tot{:,5}*100],'filled','MarkerFaceColor',lgray);
errorbar([1 2], meanAmpl, stdAmpl,'LineStyle', 'none','Color','k','CapSize',0,'Marker','.','MarkerSize',20);
line([ones(1,m); 2*ones(1,m)], [stats_tot{:,4}*100, stats_tot{:,5}*100]','Color',lgray);
xlim([0.5 2.5]);
ylim([0 15]);
xticks([1 2])
xticklabels({'Left','Right'});
ylabel('Average Amplitude of All Events (% \DeltaF/F)');

subplot(1,3,2);
meanAmpl = mean(stats_tot{:,1:2}/10);
stdAmpl = std(stats_tot{:,1:2}/10);
m = size(stats_tot,1);
scatter([ones(1,m) 2*ones(1,m)], [stats_tot{:,1}/10; stats_tot{:,2}/10],'filled','MarkerFaceColor',lgray);
errorbar([1 2], meanAmpl, stdAmpl,'LineStyle', 'none','Color','k','CapSize',0,'Marker','.','MarkerSize',20);
line([ones(1,m); 2*ones(1,m)], [stats_tot{:,1}/10, stats_tot{:,2}/10]','Color',lgray);
xlim([0.5 2.5]);
ylim([0 15]);
xticks([1 2])
xticklabels({'Left','Right'});
ylabel('Frequency of All Events (events/min)');

%% fig 5
%notes: vg3 is 496_PCA, frame 139, 588
close all;

paths = {'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-569_P6-Snap25GC6s_PCA\ICmovs_peaks_dFoF_remflash.mat';
        };

    for i=1:size(paths)
         %load(paths{i},'-regexp','^(?!LICmov|RICmov)...');
         load(paths{i});
         [peaksBinaryL] = getPeaks_dFoF(smLIC,0,0.015);
         [peaksBinaryR] = getPeaks_dFoF(smRIC,1,0.015);
         savefile = '\ICmovs_peaks_dFoF.mat';
         [path, fn, ext ] = fileparts(paths{i});
         save([path savefile],'smLIC','smRIC','peaksBinaryR','peaksBinaryL');
        %size(peaksBinaryR)
        %size(peaksBinaryL)
        
        [peakStat, eventStats] = peakStats_dFoF(smLIC, peaksBinaryL, smRIC, peaksBinaryR);
        
    end
    
    Llocs = find(peaksBinaryL);
    [Lr, Lc] = ind2sub(size(peaksBinaryL),Llocs);
    Rlocs = find(peaksBinaryR);
    [Rr, Rc] = ind2sub(size(peaksBinaryL),Rlocs);
    
    statsL = peakStat{1};
    statsR = peakStat{2};
    histoL = statsL(:,2);
    histoR = statsR(:,2);
    ylims = [3410 3450];
    %markerSize = 10;
    
    rightDomIndices = find(strcmp(eventStats.leftOrRightDom,'Right'));
    leftDomIndices = find(strcmp(eventStats.leftOrRightDom,'Left'));
    lhwx= eventStats.hwx(leftDomIndices)/2;
    lhwt= eventStats.hwt(leftDomIndices)/2;
    lx = eventStats.xloc(leftDomIndices);
    lt = eventStats.tloc(leftDomIndices);
    lhwxlinesx = [lx-lhwx lx+lhwx]';
    lhwxlinesy = [lt lt]';
    lhwtlinesx = [lx lx]';
    lhwtlinesy = [lt-lhwt lt+lhwt]';
    rhwx= eventStats.hwx(rightDomIndices)/2;
    rhwt= eventStats.hwt(rightDomIndices)/2;
    rx = eventStats.xloc(rightDomIndices);
    rt = eventStats.tloc(rightDomIndices);
    rhwxlinesx = [rx-rhwx rx+rhwx]';
    rhwxlinesy =[rt rt]';
    rhwtlinesx =[rx rx]';
    rhwtlinesy = [rt-rhwt rt+rhwt]';
    
    %single figure for movie
    markerSize = 5;
    p = figure;
    p.Units ='inches';
    p.Position = [2 2 3/3.6 2/3.6];
    set(0, 'defaultFigureRenderer', 'OpenGL')
    set(gca,'FontSize',6);
    set(p,'Color','white');
    colormap jet;
    pv = [.15 .3 .4 .65/2];
    subplot('Position',pv);
    imagesc(smLIC');
    caxis([0 0.25]);
    xlim([5 125]);
    ylim(ylims);
    hold on; 
    scatter(Lr, Lc,markerSize,'MarkerEdgeColor','white','LineWidth',.1);
    line(lhwxlinesx,lhwxlinesy,'Color','white');
    line(lhwtlinesx,lhwtlinesy,'Color','white');
    set(gca,'XTick',[],'XColor','k','YColor','k');
    %axis off;
    
    pv = [.58 .3 .4 .65/2];
    subplot('Position',pv);
    imagesc(smRIC');
    caxis([0 0.25]);
    xlim([0 115]);
    ylim(ylims);
    hold on; 
    scatter(Rr, Rc, markerSize,'MarkerEdgeColor','white','LineWidth',.1);
    line(rhwxlinesx,rhwxlinesy,'Color','white');
    line(rhwtlinesx,rhwtlinesy,'Color','white');
    set(gca,'XTick',[],'XColor','k');
    set(gca,'YTick',[],'YColor','k');
    %axis off;
    
    
    ylims = [5770 5810];
    %single figure single shot
    markerSize = 5;
    p = figure;
    p.Units ='inches';
    p.Position = [2 2 3/3.6 2/3.6];
    set(0, 'defaultFigureRenderer', 'OpenGL')
    set(gca,'FontSize',6);
    set(p,'Color','white');
    colormap jet;
    pv = [.15 .3 .4 .65/2];
    subplot('Position',pv);
    imagesc(smLIC');
    caxis([0 0.25]);
    xlim([5 125]);
    ylim(ylims);
    hold on; 
    scatter(Lr, Lc,markerSize, 'MarkerEdgeColor','white','LineWidth',.1);
    line(lhwxlinesx,lhwxlinesy,'Color','white');
    line(lhwtlinesx,lhwtlinesy,'Color','white');
    set(gca,'XTick',[],'XColor','k','YColor','k');
    %axis off;
    
    pv = [.58 .3 .4 .65/2];
    subplot('Position',pv);
    imagesc(smRIC');
    caxis([0 0.25]);
    xlim([0 115]);
    ylim(ylims);
    hold on; 
    scatter(Rr, Rc,markerSize, 'MarkerEdgeColor','white','LineWidth',.1);
    set(gca,'XTick',[],'XColor','k');
    set(gca,'YTick',[],'YColor','k');
    line(rhwxlinesx,rhwxlinesy,'Color','white');
    line(rhwtlinesx,rhwtlinesy,'Color','white');
    %axis off;
    
 % for WT figure;   
paths = {'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-569_P6-Snap25GC6s_PCA\ICmovs_peaks_dFoF_remflash.mat';
        };
    for i=1:size(paths)
         %load(paths{i},'-regexp','^(?!LICmov|RICmov)...');
         load(paths{i});
         [peaksBinaryL] = getPeaks_dFoF(smLIC,0,0.015);
         [peaksBinaryR] = getPeaks_dFoF(smRIC,1,0.015);
         savefile = '\ICmovs_peaks_dFoF.mat';
         [path, fn, ext ] = fileparts(paths{i});
         save([path savefile],'smLIC','smRIC','peaksBinaryR','peaksBinaryL');
        %size(peaksBinaryR)
        %size(peaksBinaryL)
        
        [peakStat, eventStats] = peakStats_dFoF(smLIC, peaksBinaryL, smRIC, peaksBinaryR);
        
    end
    
    Llocs = find(peaksBinaryL);
    [Lr, Lc] = ind2sub(size(peaksBinaryL),Llocs);
    Rlocs = find(peaksBinaryR);
    [Rr, Rc] = ind2sub(size(peaksBinaryL),Rlocs);
    
    statsL = peakStat{1};
    statsR = peakStat{2};
    histoL = statsL(:,2);
    histoR = statsR(:,2);
    ylims = [1700 1700+2000];  
    %single figure for movie
    markerSize = 5;
    p = figure;
    p.Units ='inches';
    p.Position = [2 2 3/1.75 2*3];
    set(0, 'defaultFigureRenderer', 'OpenGL')
    set(gca,'FontSize',6);
    set(p,'Color','white');
    colormap jet;
    pv = [.15 .3 .4 .65/2];
    subplot('Position',pv);
    imagesc(smLIC');
    caxis([0 0.25]);
    xlim([5 125]);
    ylim(ylims);
    hold on; 
    scatter(Lr, Lc,markerSize,'MarkerEdgeColor','white','LineWidth',.1);
    set(gca,'XTick',[],'XColor','k','YColor','k');
    %axis off;
    
    pv = [.58 .3 .4 .65/2];
    subplot('Position',pv);
    imagesc(smRIC');
    caxis([0 0.25]);
    xlim([0 115]);
    ylim(ylims);
    hold on; 
    scatter(Rr, Rc, markerSize,'MarkerEdgeColor','white','LineWidth',.1);
    set(gca,'XTick',[],'XColor','k');
    set(gca,'YTick',[],'YColor','k');
    %axis off;
    
    pv = [.15 .1 .4 .06];
    subplot('Position',pv);
    histogram(histoL,[0:5:125],'FaceColor','black','FaceAlpha',1);
    xlim([0 120]);
    ylim([0 20]);
    ylabel('# of Events');

    pv = [.58 .1 .4 .06];
    subplot('Position',pv);
    histogram(histoR,[0:5:125],'FaceColor','black','FaceAlpha',1);
    xlim([5 125]);
    ylim([0 20]);
    
    %for vg3 figure
            paths = {'M:\Bergles Lab Data\Projects\In vivo imaging\vGluT3 KO\DUP_Experiment-593-Snap25GC6s_vGluT3KO_PCA\ICmovs_peaks_dFoF_remflash.mat';
        };
    for i=1:size(paths)
         %load(paths{i},'-regexp','^(?!LICmov|RICmov)...');
         load(paths{i});
         [peaksBinaryL] = getPeaks_dFoF(smLIC,0,0.015);
         [peaksBinaryR] = getPeaks_dFoF(smRIC,1,0.015);
         savefile = '\ICmovs_peaks_dFoF.mat';
         [path, fn, ext ] = fileparts(paths{i});
         save([path savefile],'smLIC','smRIC','peaksBinaryR','peaksBinaryL');
        %size(peaksBinaryR)
        %size(peaksBinaryL)
        
        [peakStat, eventStats] = peakStats_dFoF(smLIC, peaksBinaryL, smRIC, peaksBinaryR);
        
    end
    
    Llocs = find(peaksBinaryL);
    [Lr, Lc] = ind2sub(size(peaksBinaryL),Llocs);
    Rlocs = find(peaksBinaryR);
    [Rr, Rc] = ind2sub(size(peaksBinaryL),Rlocs);
    
    statsL = peakStat{1};
    statsR = peakStat{2};
    histoL = statsL(:,2);
    histoR = statsR(:,2);
    ylims = [2000 2000+2000];  
    %single figure for movie
    markerSize = 5;
    p = figure;
    p.Units ='inches';
    p.Position = [2 2 3/1.75 2*3];
    set(0, 'defaultFigureRenderer', 'OpenGL')
    set(gca,'FontSize',6);
    set(p,'Color','white');
    colormap jet;
    pv = [.15 .3 .4 .65/2];
    subplot('Position',pv);
    imagesc(smLIC');
    caxis([0 0.25]);
    xlim([5 125]);
    ylim(ylims);
    hold on; 
    scatter(Lr, Lc,markerSize,'MarkerEdgeColor','white','LineWidth',.1);
    set(gca,'XTick',[],'XColor','k','YColor','k');
    %axis off;
    
    pv = [.58 .3 .4 .65/2];
    subplot('Position',pv);
    imagesc(smRIC');
    caxis([0 0.25]);
    xlim([0 115]);
    ylim(ylims);
    hold on; 
    scatter(Rr, Rc, markerSize,'MarkerEdgeColor','white','LineWidth',.1);
    set(gca,'XTick',[],'XColor','k');
    set(gca,'YTick',[],'YColor','k');
    %axis off;
    
    pv = [.15 .1 .4 .06];
    subplot('Position',pv);
    histogram(histoL,[0:5:125],'FaceColor','black','FaceAlpha',1);
    xlim([0 120]);
    ylim([0 20]);
    ylabel('# of Events');

    pv = [.58 .1 .4 .06];
    subplot('Position',pv);
    histogram(histoR,[0:5:125],'FaceColor','black','FaceAlpha',1);
    xlim([5 125]);
    ylim([0 20]);
    
    %
