function [ leftEvents biEvents rightEvents ] = eventCoordination(leftConv rightConv)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    leftEvents = bwlabel(leftConv);
    leftEventNum = max(leftEvents);
    rightEvents = bwlabel(rightConv);
    rightEventNum = max(rightEvents);
    biEvents = zeros(size(leftEvents));
   
    for i=1:size(leftEvents)
        leftIndices = find(leftEvents==i);
        rightEvents = find(rightEvents(leftIndices));
        
        if ~isempty(rightEvents)
            rightValue = rightEvents(1);
            biValues(right Events == rightValue) = 1;
        end
    end

end

