function [ISI_data] = addSGN(ISI_data,filepath,bl_start,bl_end,drug_start,drug_end)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    numCells = size(ISI_data,1);
    index = numCells + 1;
    
    [filename,name] = fileparts(char(filepath));
    ISI_data{index,1}=name;
    [d,time]=loadPclampData(filepath); %load pClamp data
    time = time*1000; %convert seconds to milliseconds
    
    %get ISIs
    [b_sp,b_ISIs,b_locs,d_sp,d_ISIs,d_locs]=SGNpeaks(d,time,[bl_start bl_end drug_start drug_end]);
    ISI_data{index,2}=b_sp;
    ISI_data{index,3}=b_ISIs;
    ISI_data{index,4}=b_locs;
    ISI_data{index,5}=d_sp;
    ISI_data{index,6}=d_ISIs;
    ISI_data{index,7}=d_locs;
end

