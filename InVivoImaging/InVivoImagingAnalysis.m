% % load file
% cd 'M:\Bergles Lab Data\Projects\In vivo imaging';
% [fn path] = uigetfile();
% movie = loadTif([path fn],32);
% 
%  [LICmov, RICmov] = ROIselection(movie);
[smLIC, histobuild, stats, convPeaks] = calculatePeaks(LICmov,0,1);
convL = convPeaks;
histoL = histobuild;
[smRIC, histobuild, stats, convPeaks] = calculatePeaks(RICmov,1,1);
histoR = histobuild;
convR = convPeaks;



conv = (convL + convR);
figure;
imagesc(conv'*40);

% savefile = 'ICmovs_peaks.mat';
% save([path savefile],'LICmov','RICmov','smLIC','smRIC','histoL','histoR'); 
