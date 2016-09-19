%load file
cd 'M:\Bergles Lab Data\Projects\In vivo imaging';
[fn path] = uigetfile();
movie = loadTif([path fn],8);

[LICmov, RICmov] = ROIselection(movie);
smLIC = calculatePeaks(LICmov,0);
smRIC = calculatePeaks(RICmov,1);

imagesc([smLIC' smRIC'])
