function smIC = calculatePeaks(meanIC,leftOrRight)
    meanIC = mean(meanIC,1);
    meanIC = squeeze(meanIC);
    smIC = imgaussfilt(meanIC,3);
    time = [1:1:size(meanIC,2)];
    leftOrRight; %0 is left, 1 is right

    %find peaks in signal
    peaks = imregionalmax(smIC);
    peaks = smIC.*peaks;
    peaks(peaks < 10) = 0; %filter out any events less than x
    peaksBinary = peaks > 0; %create binary version of peaks
    
    %blank out whole IC events, (events that are far left or far right)
    peak_locs = find(peaks);
    [r,c] = ind2sub(size(peaks),peak_locs);
    if leftOrRight %picks out far left or far right events
        ctodel = c(r <= 15);
        c = c(r > 15);
        r = r(r > 15);
    else
        ctodel = c(r >= 110);
        c = c(r < 110);
        r = r(r < 110);
    end
    blank_area = 5;
    for i=1:size(ctodel,1)
        if i > blank_area
            peaks(:,ctodel(i)-blank_area:ctodel(i)+blank_area)= zeros(size(peaks(:,ctodel(i)-blank_area:ctodel(i)+blank_area)));
        end
    end

    
  
    
    %binarize peaks and collapse into 1D to calculate event timeframes

    oneDPeaks = sum(peaksBinary,1);
    convPeaks = oneDPeaks + conv(single(oneDPeaks > 0),ones(1,5),'same');
    convPeaks = convPeaks > 0;
    labels = bwlabel(convPeaks);
    eventNum = max(labels);
    eventLabels = [1:1:eventNum];
    totalPeaks = [];
    maxEvents = [];
    halfwidths = [];
    
    test = [];
    for i=1:eventNum
        index = find(labels == i);
        startTime = index(1);
        endTime = index(end);
        eventArea = peaks(:, startTime:endTime);
        totalPeaks = [totalPeaks nnz(eventArea)];
        
        %find max intensity event
        maxEvent = max(eventArea(:));
        [row,col] = ind2sub(size(eventArea),find(eventArea == maxEvent));
        maxEvents = [maxEvents; row, startTime + col;];
        
        windowSize = 100;
        if startTime - windowSize < 1
            windowStart = 1;
        else
            windowStart = startTime - windowSize;
        end
        
        if endTime + windowSize > size(smIC,2) 
            windowEnd = size(smIC,2)
        else
            windowEnd = endTime + windowSize;
        end  
        
        %[pks, locs, w] = 
        %findpeaks(smIC(r,windowStart:windowEnd),'Annotate','extents','WidthReference','halfheight');
        [pks,locs,w] = findpeaks(smIC(row,windowStart:windowEnd),'WidthReference','halfheight');
        index = find(pks == maxEvent);
        halfwidths = [halfwidths; w(index)];
    end
    
    
    
    
    
    figure;
    imagesc([smIC' (convPeaks*40)'] );
    hold on;
    h(2) = scatter(r,c,'LineWidth',2);
    ylim([0,1200]);
    colormap jet;
    caxis([0,70]);

    sum_peaks = sum(peaksBinary');
    histoBuild = [];
    for i=1:size(sum_peaks,2)
        histoBuild = [histoBuild i*ones(1,sum_peaks(i))];
    end
    figure;
    histogram(histoBuild,20);
    xlim([0,125]);
end


% peaks = zeros(size(meanIC));
% time = [1:1:size(meanIC,2)];
% 
% figure;
% surf([1:1:125],time,meanIC','EdgeColor','none');
% view(2);
% figure;
% surf([1:1:125],time,imgaussfilt(meanIC,2)','EdgeColor','none');
% view(2);
% figure;
% imagesc(imregionalmax(meanIC));
% figure;
% imagesc(imregionalmax(smIC));



% for i=1:size(meanIC,1)
%     [pks, locs] = findpeaks(double(meanIC(i,:)),time,'MinPeakProminence',5);
%     peaks(i,locs(:))=1;
% end
% 
% %times = meanIC .* peaks;
% times = meanIC;
% figure;
% surf([1:1:125],time,times','EdgeColor','none');
% view(2



%  indexLeft = startTime + c - 1;
%         foundLeft = 0;
%         indexRight = startTime + c + 1;
%         foundRight = 0;
%         halfwidthLeft = 0;
%         halfwidthRight = 0;
%        
%         while ~foundLeft || ~foundRight
%             if ~foundLeft
%                 ampLeft = smIC(r,indexLeft);
%             end
%             if ~foundRight
%                 ampRight = smIC(r,indexRight);
%             end
%             target = maxEvent/2;
%             
%             if ampLeft < target && ~foundLeft
%                 halfwidthLeft = indexLeft;
%                 foundLeft = 1;
%             end
%             if ampRight < target && ~foundRight
%                 halfwidthRight = indexRight;
%                 foundRight = 1;
%             end
%             
%             indexLeft = indexLeft - 1;
%             if (indexLeft < 1) && ~foundLeft
%                 foundLeft = 1;
%                 halfwidthLeft = NaN;
%             end
%             
%             indexRight = indexRight + 1;
%             if indexRight > size(smIC,2) && ~foundRight
%                 foundRight = 1;
%                 halfwidthRight = NaN;
%             end
%         end
%         
%         test = [test [halfwidthLeft; halfwidthRight; target; target]];
