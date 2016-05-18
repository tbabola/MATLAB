%Script for analyzing peaks across multiple IHCs

test_IHC = test_IHC_bup;
IHC_data = cell(0,0);
IHC_spikes = cell(0,0);

%test_IHC_sm = smooth(test_IHC,3);
%test_IHC_sm = reshape(test_IHC_sm,[1500 size(test_IHC,2)]);
%test_IHC = test_IHC_sm;
time = [1:1:1500]';

for i=1:size(test_IHC,2)
    [pks,locs]=findpeaks(test_IHC(:,i),'MinPeakProminence',0.1,'MinPeakDistance',4);
    IHC_data{i,1} = [pks,locs];
    IHC_spikes{i,1} = locs';
end

for i=1:size(test_IHC,2)
    test_IHC_spread(:,i) = test_IHC(:,i)+0.1*(i-1);
end

figure;
g = plot(test_IHC_spread);
set(g,'Color','black');


figure
 plotSpikeRaster(IHC_spikes,'PlotType','vertLine');
