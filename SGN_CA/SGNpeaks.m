function [b_sp, b_ISIs, b_locs, d_sp, d_ISIs, d_locs, d_blsubtract] = SGNpeaks(d, time, x)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    baselineStart = x(1)*1000;
    baselineEnd = x(2)*1000;
    drugStart = x(3)*1000;
    drugEnd = x(4)*1000;
    
    %baseline correction for thresholding
    d_blsubtract = msbackadj(time,d,'WindowSize',10000,'StepSize',10000);
    prominenceThr = 0.3; %mV
    [pks,locs]=findpeaks(d_blsubtract,time,'MinPeakProminence',prominenceThr,'MinPeakHeight',0.25);
    
    %ISI measurements
    ISIs = zeros(size(locs,1)-1,1);
    for i=1:size(locs)-1
        ISIs(i)=locs(i+1)-locs(i);
    end
    
    %baseline and drug spikes
    baselineSpikes = locs(baselineStart <= locs & locs <= baselineEnd);
    b_ISIs = ISIs(baselineStart <= locs & locs <= baselineEnd);
    b_sp = size(b_ISIs,1);
    b_locs = locs(baselineStart <= locs & locs <= baselineEnd);
    baselineFreqHz = b_sp/(baselineEnd-baselineStart);
    
    drugSpikes = locs(drugStart <=locs & locs <= drugEnd);
    d_ISIs = ISIs(drugStart <= locs(1:size(ISIs,1)) & locs(1:size(ISIs,1)) <= drugEnd);
    d_sp = size(d_ISIs,1);
    d_locs = locs(drugStart <= locs & locs <= drugEnd);
    drugFreqHz = d_sp/(drugEnd-drugStart);
    fprintf('Baseline Spikes (Freq):%f (%f)\n',size(b_ISIs,1),baselineFreqHz);
    fprintf('Drug Spikes (Freq):%f (%f)\n',size(d_ISIs,1),drugFreqHz);
    
end

