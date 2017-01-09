function [LICmov, RICmov] = ROIselection(movie)
    width = size(movie,2);
    %rotate images
    rotateRIC = imrotate(movie(:,width/2:end,:),55);
    meanRIC = mean(rotateRIC,3);
    rotateLIC = imrotate(movie(:,1:width/2,:),-55);
    meanLIC = mean(rotateLIC,3);
    
    CCW = figure;
    imagesc(meanRIC);
    RIC = imrect(gca,[0,0,125,100]);
    setResizable(RIC,0);
    wait(RIC);
    pos = getPosition(RIC);
    pos = int16(round(pos));
    RICmov = rotateRIC(pos(2):pos(2)+pos(4)-1,pos(1):pos(1)+pos(3)-1,:);

    %LIC
    CW = figure;
    imagesc(meanLIC);
    LIC = imrect(gca,[0,0,125,100]);
    setResizable(LIC,0);
    wait(LIC);
    pos = getPosition(LIC);
    pos = int16(round(pos));
    LICmov = rotateLIC(pos(2):pos(2)+pos(4)-1,pos(1):pos(1)+pos(3)-1,:);
end