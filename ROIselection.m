%load file
%cd 'M:\Bergles Lab Data\Projects\In vivo imaging';
%[fn path] = uigetfile();

%

function [LICmov, RICmov] = ROIselection(movie)
    %RIC
    rotateCCW = imrotate(movie,55);
    CCW = figure;
    imagesc(rotateCCW(:,:,50));
    RIC = imrect(gca,[0,0,125,100]);
    setResizable(RIC,0);
    wait(RIC);
    pos = getPosition(RIC);
    pos = int16(round(pos));
    RICmov = rotateCCW(pos(2):pos(2)+pos(4)-1,pos(1):pos(1)+pos(3)-1,:);

    %LIC
    rotateCW = imrotate(movie,-55);
    CW = figure;
    imagesc(rotateCW(:,:,50));
    LIC = imrect(gca,[0,0,125,100]);
    setResizable(LIC,0);
    wait(LIC);
    pos = getPosition(LIC);
    pos = int16(round(pos));
    LICmov = rotateCW(pos(2):pos(2)+pos(4)-1,pos(1):pos(1)+pos(3)-1,:);
end