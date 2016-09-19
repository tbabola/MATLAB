% spike_locs = {};
% 
% for i=1:size(IHCS_offset,2)
%     signal = IHCS_offset(:,i);
%     average = mean(signal);
%     stdev = std(signal);
%     thr = average + 8*stdev;
%     
%     %signal = msbackadj([1:1:1500]',signal);
%     [pk,locs] = findpeaks(signal, time, 'MinPeakProminence',thr-average);
%     spike_locs{i,1} = locs';
% end
% 
% figure;
% plotSpikeRaster(spike_locs,'PmsbacklotType','VertLine');

SGNS_bl = msbackadj(time,SGNS);

for i=1:size(SGNS,2)
SGNS_offset(:,i) = SGNS_bl(:,i)+20*i;
end

for i=1:10
    alpha = .1*i;
    SGN_filt = filter(alpha,[1 alpha-1],SGNS_offset);
    figure(i);
    subplot(2,1,1);
    plot(SGN_filt);
    
    for j=1:size(SGNS,2)
        signal = SGN_filt(:,j);
        average = mean(signal);
        stdev = std(signal);
        thr = 3*stdev
        
        [pk,locs] = findpeaks(signal, time, 'MinPeakProminence',thr);
        spike_locs{j,1} = locs';
    end
    
    subplot(2,1,2);
    plotSpikeRaster(spike_locs,'PlotType','VertLine');
end
    