% load file
 
  [fn dname] = uigetfile('M:\Bergles Lab Data\Projects\In vivo imaging\*.tif');
 X = loadTif([dname fn],16);
 [m,n,t] = size(X);
 Xreshape = reshape(X,m*n,t)';
 Fo = prctile(Xreshape,10,1);
 X25 = reshape(Fo',m,n);
 dFoF = double(X - X25) ./ double(X25);
% 
[LICmov, RICmov] = ROIselection(dFoF);
meanIC = squeeze(mean(LICmov,1));
smLIC = double(imgaussfilt(meanIC,3));
meanIC = squeeze(mean(RICmov,1));
smRIC = double(imgaussfilt(meanIC,3));

%%remove background transients from signal
top = dFoF(1:20,:,:); %picks area at top of image
top = squeeze(mean(mean(top),2));
mid = dFoF(60:80,:,:);
mid = squeeze(mean(mean(mid),2));
diff = top - mid;
diff(diff < 0) = 0;
[pks,locs,w]=findpeaks(diff,'MinPeakHeight',0.02,'WidthReference','halfprom','MinPeakWidth',7,'Annotate','extents');

[m] = size(locs,1);
flash = zeros(size(top));
for i=1:m
    ww = round(w(i));
    wloc = locs(i);
    flash(wloc-ww:wloc+ww) = 1;
end

%%
%LIC & RIC
[peaksBinaryL] = getPeaks_dFoF(smLIC,0,0.005);
[peaksBinaryR] = getPeaks_dFoF(smRIC,1,0.005);

[peakStat, eventStats] = peakStats_dFoF(smLIC, peaksBinaryL, smRIC, peaksBinaryR);
plotTimeSeries_dFoF(smLIC, smRIC, peaksBinaryL, peaksBinaryR, peakStat);
 
savefile = 'ICmovs_peaks_dFoF.mat';
save([dname savefile],'smLIC','smRIC','peaksBinaryR','peaksBinaryL'); 
save([dname 'Fo.mat'],'X25');
