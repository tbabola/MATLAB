%SGN Script Wildtype versus MRS
%Script to find ISIs for SGN Ca

base = 'E:\Bergles Lab Data\RecordingsAndImaging\';
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
        
ISI_data = loadSGNs(base,files);

time_raster = 0:.001:1500;
conv_filt = ones(5000,1); %10000ms/10s window for moving average
ISI_heat = [];
ISI_heat_2 = [];

for i=1:size(files,1)
    signal_raster = zeros(size(time_raster));
    signal_raster(int32(ISI_data{i,5})) = 1;
    mov_avg = conv(conv_filt,signal_raster);
    ISI_heat(i,:) = mov_avg;
end

for i=1:size(files,1)
    ISIs = ISI_data{i,4};
    inv_ISI = [];
    for j=1:size(ISIs)
        inv_ISI(j) = 1/(ISIs(j)/1000);
    end
    
    spike_indexes = int32(ISI_data{i,5});
    signal_raster = zeros(size(time_raster));
    
    signal_raster(spike_indexes) = 1;
    for j=1:size(spike_indexes)-1
        signal_raster((spike_indexes(j)+1):(spike_indexes(j+1)-1)) = inv_ISI(j);
    end
   
    ISI_heat_2(i,:) = signal_raster;
end


figure;
colormap('Jet');
imagesc(ISI_heat/5,[0 20]);
colorbar;

figure;
colormap(logMap);
imagesc(ISI_heat_2);
colorbar;


