function [smIC, peaksBinary] = getPeaks(meanIC, leftOrRight, cutoff)
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
    prominenceCutoff = cutoff;
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

