%SGNscriptRasters
%SGN Script MRS versus Wildty
%Script to find ISIs for SGN Ca

base = 'D:\Bergles Lab Data\RecordingsAndImaging\';
%filename, baseline start (sec), end, drug start, end
 files = {
            %WT + MRS25000
            '150719\15719003.abf',0,600,900,1500
             '150723\15723000.abf',0,600,900,1500
            '150723\15723002.abf',0,600,900,1500
            '150723\15723003.abf',0,600,900,1500
            '150723\15723006.abf',60,660,960,1560
            '150724\15724007.abf',0,600,900,1500
            '150725\15725007.abf',0,600,900,1500
            
         };

%initialize data, uncomment if starting from no data loaded
for i=1:size(files,1)
    filepath = strcat(base,files{i,1});
    display(filepath);
    [pathstr, name] = fileparts(char(filepath));
    [d,time]=loadPclampData(filepath); %load pClamp data
    time = time*1000; %convert seconds to milliseconds
    
    if strcmp(files{i,1},'150723\15723006.abf');
        time = time - 60 * 1000;
    end
    
    %get ISIs
    [b_sp,b_ISIs,b_locs]=SGNpeaksSingle(d,time);
    
    spike_locs{i}=b_locs'/1000;
    
    %create figure to showcase data
end

plotSpikeRaster(spike_locs,'PlotType','vertLine');
