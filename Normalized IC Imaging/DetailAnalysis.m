% load file
%  
% [fn dname] = uigetfile('M:\Bergles Lab Data\Projects\In vivo imaging\*.tif');
%  X = loadTif([dname fn],16);
%  [m,n,t] = size(X);
%  [dFoF, Fo] = normalizeImg(X, 10, 1);
% % %  
 [LICmov, RICmov] = ROIselection(dFoF);
 meanLIC = squeeze(mean(LICmov,1));
 percentLIC = prctile(meanLIC,30,2);
 meanRIC = squeeze(mean(RICmov,1));
 percentRIC = prctile(meanRIC,30,2);

% %%remove background transients from signal
top = dFoF(1:20,:,:); %picks area at top of image
top = squeeze(mean(mean(top),2));
mid = dFoF(60:80,:,:);
mid = squeeze(mean(mean(mid),2));
diff = top - mid;
diff(diff < 0) = 0;
[pks,locs,w]=findpeaks(double(diff),'MinPeakHeight',0.02,'WidthReference','halfprom','MinPeakWidth',7,'Annotate','extents');


flash = zeros(size(top));
for i=1:size(w,1)
    ww = floor(w(i));
    wloc = locs(i);
    left = wloc-ww-2;
    right = wloc+ww+2;
    if left < 1
        left = 1;
    end
    if right > t
        right = t;
    end
    flash(left:right) = 1;
end

[m,n] = size(meanLIC(:,find(flash)));
percentLIC = repmat(percentLIC,1,n);
percentLIC = imnoise(percentLIC,'gaussian',0,.0001);
percentLIC = imgaussfilt(percentLIC);
meanLIC(:,find(flash)) = percentLIC;
[m,n] = size(meanRIC(:,find(flash)));
percentRIC = repmat(percentRIC,1,n);
percentRIC = imnoise(percentRIC,'gaussian',0,.0001);
percentRIC = imgaussfilt(percentRIC);
meanRIC(:,find(flash)) = percentRIC;
% 
smLIC = double(imgaussfilt(meanLIC,3));
smRIC = double(imgaussfilt(meanRIC,3));

%%
%LIC & RIC
[peaksBinaryL] = getPeaks_dFoF(smLIC,0,0.01);
[peaksBinaryR] = getPeaks_dFoF(smRIC,1,0.01);

[peakStat, eventStats] = peakStats_dFoF(smLIC, peaksBinaryL, smRIC, peaksBinaryR);
plotTimeSeries_dFoF(smLIC, smRIC, peaksBinaryL, peaksBinaryR, peakStat);
 
savefile = 'ICmovs_peaks_dFoF_remflash.mat';
save([dname savefile],'smLIC','smRIC','peaksBinaryR','peaksBinaryL'); 
save([dname 'Fo.mat'],'Fo');
