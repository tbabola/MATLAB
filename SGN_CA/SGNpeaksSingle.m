function [b_sp, b_ISIs, b_locs] = SGNpeaksSingle(d, time)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    
    %baseline correction for thresholding
    d_blsubtract = msbackadj(time,d,'WindowSize',10000,'StepSize',10000);
    prominenceThr = 0.3; %mV
    [~,locs]=findpeaks(d_blsubtract,time,'MinPeakProminence',prominenceThr,'MinPeakHeight',0.25);
    
    %ISI measurements
    ISIs = zeros(size(locs,1)-1,1);
    for i=1:size(locs)-1
        ISIs(i)=locs(i+1)-locs(i);
    end
    
    %baseline
    b_ISIs = ISIs;
    b_sp = size(b_ISIs,1);
    b_locs = locs;
    
end

