function tif2avi(img)

outputVideo = VideoWriter('/Users/Travis/Desktop/141203/A2P2/141203_Vid_13_Baseline.avi');
outputVideo.FrameRate = 1;
outputVideo.Quality = 100;
open(outputVideo);

for iStep=1:size(img,3)
    writeVideo(outputVideo,img(:,:,iStep));
end

end