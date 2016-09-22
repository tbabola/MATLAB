%load file
cd 'M:\Bergles Lab Data\Projects\In vivo imaging';
[fn path] = uigetfile();
movie = loadTif([path fn],32);

[LICmov, RICmov] = ROIselection(movie);
[smLIC, histobuild] = calculatePeaks(LICmov,0);
histoL = histobuild;
[smRIC, histobuild] = calculatePeaks(RICmov,1);
histoR = histobuild;

savefile = 'ICmovs_peaks.mat';
save([path savefile],'LICmov','RICmov','smLIC','smRIC','histoL','histoR'); 
