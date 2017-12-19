function [figh] = rainbowRaster(spikeTimes, range)
    cmap = hsv;
    cmapsize = size(cmap,1);
    rangeSize = range(2) - range(1) + 1;
    cmap = imresize(cmap,[rangeSize 3]);
    cmap(cmap > 1) = 1;
    cmap(cmap < 0) = 0;
    spikeTimes = spikeTimes(spikeTimes >= range(1) & spikeTimes <= range(2));
    spikeTimes = spikeTimes - range(1);
    m = size(spikeTimes,1);
    
    figh = figure;
    for i=1:m
        x = spikeTimes(i);
        line([x x], [1 2], 'Color',cmap(x,:),'LineWidth',1);
    end
    xlim([0 rangeSize]);
      
    

end

