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

%%
%LIC & RIC
[peaksBinaryL] = getPeaks_dFoF(smLIC,0,0.005);
[peaksBinaryR] = getPeaks_dFoF(smRIC,1,0.005);

[peakStat, eventStats] = peakStats_dFoF(smLIC, peaksBinaryL, smRIC, peaksBinaryR);
plotTimeSeries_dFoF(smLIC, smRIC, peaksBinaryL, peaksBinaryR, peakStat);
 
savefile = 'ICmovs_peaks_dFoF.mat';
save([dname savefile],'smLIC','smRIC','peaksBinaryR','peaksBinaryL'); 
save([dname 'Fo.mat'],'X25');
