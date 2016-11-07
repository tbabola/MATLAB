% load file
 cd 'M:\Bergles Lab Data\Projects\In vivo imaging';
 [fn path] = uigetfile();
 movie = loadTif([path fn],32);
[LICmov, RICmov] = ROIselection(movie);
% 
% %LIC
[smLIC, peaksBinaryL] = getPeaks(LICmov,0);
%RIC
[smRIC, peaksBinaryR] = getPeaks(RICmov,1);

[peakStat, eventStats] = peakStats(smLIC, peaksBinaryL, smRIC, peaksBinaryR);
plotTimeSeries(smLIC, smRIC, peaksBinaryL, peaksBinaryR, peakStat);

%event stats
[stats] = peakStats(smLIC, peaksBinaryL, smRIC, peaksBinaryR);


%event coordination
%[ leftEvents biEvents rightEvents, test ] = eventCoordination(convL, convR, smLIC.*binaryPeaksL, smRIC.*binaryPeaksR);

% 
% conv = (convL + convR);
% figure;
% imagesc(conv'*40);
 savefile = 'ICmovs.mat';
 save([path savefile],'LICmov','RICmov'); 
 savefile = 'ICmovs_peaks.mat';
 save([path savefile],'LICmov','RICmov','smLIC','smRIC','peaksBinaryR','peaksBinaryL'); 
