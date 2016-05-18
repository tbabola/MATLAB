%raster plots of long time period

base = 'E:\Bergles Lab Data\RecordingsAndImaging\';
%filename, baseline start (sec), end, drug start, end
files = {
            %WT + MRS25000
            '150822\15822000.abf',0,600,900,1500
            '150822\15822002.abf',60,660,960,1560
            '150822\15822004.abf',0,600,900,1500
   };
            
spike_locs_WT = {};

%initialize data, uncomment if starting from no data loaded
for i=1:size(files,1)
    filepath = strcat(base,files{i,1});
    display(filepath);
    [pathstr, name] = fileparts(char(filepath));
    ISI_data{i,1}=name;
    [d,time]=loadPclampData(filepath); %load pClamp data
    time = time*1000; %convert seconds to milliseconds
    
    %load start and end times for baseline and drug application
    bl_start = files{i,2};
    bl_end = files{i,3};
    drug_start = files{i,4};
    drug_end = files{i,5};
    
    d = d(time>=bl_start*1000 & time <=drug_end*1000);
    time = time(time>=bl_start*1000 & time <=drug_end*1000);
    time = time - bl_start*1000;
    
    %get ISIs
    [b_sp, b_ISIs, b_locs] = SGNpeaksSingle(d, time)
    spike_locs_WT{size(spike_locs_WT,2)+1}=b_locs'/1000;
end

figure;
plotSpikeRaster(spike_locs_WT,'PlotType','vertLine');
