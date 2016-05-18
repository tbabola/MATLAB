%SGN Script WT versus KO
%Script to find ISIs for SGN Ca
close all;

base = 'D:\Bergles Lab Data\RecordingsAndImaging\';
%filename, baseline start (sec), end, drug start, end
 files = {
%          very high firing, no NBQX/CPP
%           '150612\15612018.abf',10,610,790,1390 
%           '150612\15612025.abf',10,610,790,1390

%           preceding ATP puff, diminishes activity right after that
%           returns
%           '150618\15618012.abf',60,660,960,1560
%           '150619\15619001.abf',0,600,900,1500
%           '150619\15619013.abf',0,600,900,1500
% 
%           Low K+ versus High K+, KOs
%           '150710\15710001.abf',300,900,900,901
%           '150710\15710004.abf',0,600,600,601
%           '150710\15710009.abf',0,600,900,1500
%           '150710\15710010.abf',0,600,600,601

            %WT
            '150719\15719003.abf',0,600,'WT'
            '150723\15723000.abf',0,600,'WT'
            '150723\15723002.abf',0,600,'WT'
            '150723\15723003.abf',0,600,'WT'
            '150723\15723006.abf',60,660,'WT'
            '150724\15724007.abf',0,600,'WT'
            '150725\15725007.abf',0,600,'WT'
            '150807\15807000.abf',0,600,'WT'
            
            %KO
             '150724\15724000.abf',30,630,'KO'
             '150724\15724001.abf',0,600,'KO'
             '150724\15724002.abf',0,600,'KO'
             '150724\15724004.abf',0,600,'KO'
             '150724\15724005.abf',0,600,'KO'
             '150725\15725000.abf',0,600,'KO'
             '150725\15725005.abf',0,600,'KO'
             '150725\15725006.abf',0,600,'KO'
             
             %thapsi
             '150731\15731000.abf',300,900,'Thapsi'
             '150731\15731003.abf',0,600,'Thapsi'
             '150731\15731004.abf',60,660,'Thapsi'
             '150731\15731007.abf',0,600,'Thapsi'
             
         };

     spike_locs_WT={};
     spike_locs_KO={};
     spike_locs_thapsi={};
%initialize data, uncomment if starting from no data loaded
% for i=1:size(files,1)
%     filepath = strcat(base,files{i,1});
%     display(filepath);
%     [pathstr, name] = fileparts(char(filepath));
%     ISI_data_WTKO{i,1}=name;
%     [d,time]=loadPclampData(filepath); %load pClamp data
%     time = time*1000; %convert seconds to milliseconds
%     
%     %load start and end times for baseline and drug application
%     bl_start = files{i,2};
%     bl_end = files{i,3};
%     d = d(time >= bl_start*1000 & time <= bl_end*1000);
%     time = time(time >=bl_start*1000 & time <=bl_end*1000);
%     
%     %get ISIs
%     [b_sp,b_ISIs,b_locs]=SGNpeaksSingle(d,time);
%     ISI_data_WTKO{i,2} = files{i,4};
%     ISI_data_WTKO{i,3}=b_sp;
%     ISI_data_WTKO{i,4}=b_ISIs;
%     ISI_data_WTKO{i,5}=b_locs;
%     
%     %ISI_data{i,8}=d;
%     %ISI_data{i,9}=time;
%     
%     %create figure to showcase data
%     figure(i);
%     subplot(2,1,1);
%     plot(resample(time/1000,1,10),resample(d,1,10));
%     upper_y = max(d);
%     axis([bl_start bl_end -inf upper_y+2]);
% end

%concatenate baseline and drug conditions for total histogram
wildtype = zeros(0,1);
KO = zeros(0,1);
thapsi = zeros(0,1);

for i=1:size(ISI_data_WTKO,1)
    b_locs = ISI_data_WTKO{i,5};
    if strcmp(ISI_data_WTKO{i,2},'WT')
        spike_locs_WT{size(spike_locs_WT,2)+1}=b_locs'/1000;
        wildtype = vertcat(wildtype,ISI_data_WTKO{i,4});
    elseif strcmp(ISI_data_WTKO{i,2},'KO')
        spike_locs_KO{size(spike_locs_KO,2)+1}=b_locs'/1000;
        KO = vertcat(KO,ISI_data_WTKO{i,4});
    elseif strcmp(ISI_data_WTKO{i,2},'Thapsi')
        spike_locs_thapsi{size(spike_locs_thapsi,2)+1}=b_locs'/1000;
        thapsi = vertcat(thapsi,ISI_data_WTKO{i,4});
    end
end

%[mb_thr, b_thr] =  SGNgaussianfit(baseline);
mb_thr = 19.16;
b_thr = 1500;

%plot histogram of conditions
edges = 10.^(-1:0.1:6);
figure;
histogram(wildtype,edges); 
hold on;
histogram(KO,edges);
histogram(thapsi,edges);
hold off;
set(gca,'XScale','log');
axis([10^0 10^5 -inf inf]);
line([mb_thr b_thr;mb_thr b_thr],[0 0; 100 100]);

%use thresholds to detect bursts of activity
WT_intervals_tot = NaN(0,11);
KO_intervals_tot = NaN(0,11);
thapsi_intervals_tot = NaN(0,11);

for i=1:size(files,1)
   %baseline
   ISIs = ISI_data_WTKO{i,4};
   locs = ISI_data_WTKO{i,5};
   [ISI_burstdata, intervals, burst_locs] = SGNbursts(ISIs, mb_thr, b_thr, locs);
   ISI_data_WTKO{i,6} = max(ISI_burstdata(:,3));
   
   if strcmp(ISI_data_WTKO{i,2},'WT')
       WT_intervals_tot(size(WT_intervals_tot,1)+1,:)=mean(intervals);
       b_burst_locs = burst_locs/1000;
   elseif strcmp(ISI_data_WTKO{i,2},'KO')
      KO_intervals_tot(size(KO_intervals_tot,1)+1,:)=mean(intervals);
      d_burst_locs = burst_locs/1000;
  elseif strcmp(ISI_data_WTKO{i,2},'Thapsi')
      thapsi_intervals_tot(size(thapsi_intervals_tot,1)+1,:)=mean(intervals);
      thapsi_burst_locs = burst_locs/1000;
   end
   clearvars ISI_burstdata intervals burst_locs; 
   
end

   b_int_std = nanstd(WT_intervals_tot);
   d_int_std = nanstd(KO_intervals_tot);
   t_int_std = nanstd(thapsi_intervals_tot);
   b_int_mean = nanmean(WT_intervals_tot);
   d_int_mean = nanmean(KO_intervals_tot);
   t_int_mean = nanmean(thapsi_intervals_tot);
   figure;
   errorbar(b_int_mean',b_int_std);
   hold on;
   errorbar(d_int_mean',d_int_std);
   errorbar(t_int_mean',d_int_std);
   
   figure;
   plotSpikeRaster(spike_locs_WT,'PlotType','vertLine');
   figure;
   plotSpikeRaster(spike_locs_KO,'PlotType','vertLine');
   figure;
   plotSpikeRaster(spike_locs_thapsi,'PlotType','vertLine');
   
   figure;
   ksdensity(log10(wildtype),[0:0.01:5]')
   hold on
   ksdensity(log10(KO),[0:0.01:5]')
   ksdensity(log10(thapsi),[0:0.01:5]')
%clearvars -except ISI_data
