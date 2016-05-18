function [ISI_data] = addSGNnoDrug(ISI_data,filepath,bl_start,bl_end,condition)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    numCells = size(ISI_data,1);
    index = numCells + 1;
    
    [filename,name] = fileparts(char(filepath));
    ISI_data{index,1}=name;
    [d,time]=loadPclampData(filepath); %load pClamp data
    time = time*1000; %convert seconds to milliseconds
    
    %load start and end times for baseline and drug application
    d = d(time >= bl_start*1000 & time <= bl_end*1000);
    time = time(time >=bl_start*1000 & time <=bl_end*1000);
    
    %get ISIs
    [b_sp,b_ISIs,b_locs]=SGNpeaksSingle(d,time);
    b_locs = b_locs - bl_start*1000;
    ISI_data{index,2} = condition;
    ISI_data{index,3}= b_sp;
    ISI_data{index,4}= b_ISIs;
    ISI_data{index,5}= b_locs;
end


