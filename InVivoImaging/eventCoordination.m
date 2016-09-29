%function [ leftEvents biEvents rightEvents ] = eventCoordination(leftConv rightConv)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    leftLabel = bwlabel(leftConv);
    leftEventNum = max(leftLabel);
    rightLabel = bwlabel(rightConv);
    rightEventNum = max(rightLabel);
    leftEvents = zeros(size(leftLabel));
    biEvents = zeros(size(leftLabel));
    rightEvents = zeros(size(leftLabel));
   
    for i=1:leftEventNum
        leftIndices = find(leftLabel==i);
        rightEvent = max(rightLabel(leftIndices)) > 0;
        
        if rightEvent
            rightValue = max(rightLabel(leftIndices));
            rightIndices = find(rightLabel==rightValue);
            biEvents(leftIndices) = 1;
            biEvents(rightIndices) = 1;
        end
    end
    
    leftEvents = (leftLabel - (500*biEvents)) > 0;
    rightEvents = (rightLabel - (500*biEvents)) > 0;

%end

