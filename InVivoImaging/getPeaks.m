function [smIC, peaksBinary] = getPeaks(meanIC, leftOrRight)
    meanIC = squeeze(mean(meanIC,1));
    smIC = double(imgaussfilt(meanIC,3));
    time = [1:1:size(meanIC,2)];
    leftOrRight; %0 is left, 1 is right

    %find peaks in signal
    peaks = imregionalmax(smIC);
    peaks = smIC.*peaks;
    peakFilter = 5;
    peaks(peaks < peakFilter) = 0; %filter out any events less than x
    
    %blank out whole IC events, (events that are far left or far right)
    [peaks, smIC] = clearCorticalEvents(smIC, peaks, leftOrRight, max(time));
    
    %test for prominence of peak
    prominenceCutoff = 0.25;
    peaks = clearNonprominentEvents(peaks, smIC, prominenceCutoff);
    
    %binarize peaks
    peaksBinary = peaks > 0; %create binary version of peaks
    
end

function [peaks, smIC] = clearCorticalEvents(smIC, peaks, leftOrRight,endTime)
    peak_locs = find(peaks);
    [r,c] = ind2sub(size(peaks),peak_locs);
    if leftOrRight %picks out far left or far right [r,c] = ind2sub(size(peaks),peak_locs);events
        ctodel = c(r <= 15);
    else
        ctodel = c(r >= 110);
    end
    
    blank_area = 10;
    for i=1:size(ctodel,1)
        if ctodel(i) < blank_area
            delLeft = 1;
            delRight = ctodel(i) + blank_area;
        elseif ctodel(i) + blank_area > endTime
            delLeft = ctodel(i) - blank_area;
            delRight = endTime;
        else
            delLeft = ctodel(i) - blank_area;
            delRight = ctodel(i) + blank_area;
        end
        peaks(:,delLeft:delRight)= zeros(size(peaks(:,delLeft:delRight)));
        %clear regions of this from actual signal for visualization
        %smIC(:,delLeft:delRight) = 0;
        %size(smIC,1)
    end
end

function peaks = clearNonprominentEvents(peaks, signal, prominenceCutoff)
    %We want to clear out events that are not coming out of the signal a
    %significant amount, i.e. prominence of prominenceCutoff or less
    peak_locs = find(peaks);
    [r,c] = ind2sub(size(peaks),peak_locs);
    endIndex = size(signal,2);
    
    %check every peak for prominence in time AND space
    %time
    timeEvents = zeros(size(signal));
    for i = 1:size(signal,1)
        [pks, locs] = findpeaks(signal(i,:),'MinPeakProminence',prominenceCutoff);
         timeEvents(i,locs)=1;
    end
    peaks_time = peaks .* timeEvents;
    
    indices = find(sum(peaks_time,1))';
    
    %space
    spaceEvents = zeros(size(signal));
    for i = 1:size(indices,1)
        [pks, locs] = findpeaks(signal(:,indices(i)),'MinPeakProminence',prominenceCutoff);
         spaceEvents(locs,indices(i))=1;
    end
    
    peaks_space = peaks .* spaceEvents;
    peaks = peaks.* timeEvents .*spaceEvents;
end

function [left right] = returnWindow(index, windowSize,endIndex)
    if index - windowSize < 1
        windowStart = 1;
        windowEnd = index + windowSize;
    elseif index + windowSize > endIndex;
        windowStart = index - windowSize;
        windowEnd = endIndex;
    else
        windowStart = index - windowSize;
        windowEnd = index + windowSize;
    end
    
    left = windowStart;
    right = windowEnd;
end

% for i=1:eventNum
%         index = find(labels == i);
%         startTime = index(1);
%         endTime = index(end);
%         eventArea = peaks(:, startTime:endTime);
%         totalPeaks = [totalPeaks; nnz(eventArea)];
%         
%         %find max intensity event
%         maxEvent = max(eventArea(:));
%         [row,col] = ind2sub(size(eventArea),find(eventArea == maxEvent,1));
%         maxEvents = [maxEvents; row, startTime + col;];
%         
%         windowSize = 100;
%         if startTime - windowSize < 1
%             windowStart = 1;
%             windowEnd = index + windowSize;
%         elseif endTime + windowSize > size(smIC,2)
%             windowStart = index - windowSize;
%             windowEnd = size(smIC,2);
%         else
%             windowStart = startTime - windowSize;
%             windowEnd = endTime + windowSize;
%         end
%         
%         %[pks, locs, w] = 
%         %findpeaks(smIC(r,windowStart:windowEnd),'Annotate','extents','WidthReference','halfheight');
%         [pks,locs,w] = findpeaks(smIC(row,windowStart:windowEnd),'WidthReference','halfheight');
%         index = find(pks == maxEvent);
%         halfwidths = [halfwidths; w(index)];
%     end

% 
%  stats = table(eventLabels,totalPeaks,maxEvents,halfwidths);
%     sum_peaks = sum(peaksBinary');
%     histoBuild = [];
%     for i=1:size(sum_peaks,2)
%         histoBuild = [histoBuild i*ones(1,sum_peaks(i))];
%     end
%         
%     if figs
%         figure;
%         histogram(halfwidths,30);
% 
%         [r,c] = ind2sub(size(peaks),find(peaks));
%         figure('Position',[100,100, 300, 700]);
%         imagesc([smIC' (convPeaks*40)'] );
%         hold on;
%         h(2) = scatter(r,c,'LineWidth',2);
% 
%         ylim([0,6000]);
%         colormap jet;
%         caxis([0,70]);
% 
%         sum_peaks = sum(peaksBinary');
%         histoBuild = [];
%         for i=1:size(sum_peaks,2)
%             histoBuild = [histoBuild i*ones(1,sum_peaks(i))];
%         end
% 
%         figure;
%         histogram(histoBuild,20);
%         xlim([0,125]);
%     end


