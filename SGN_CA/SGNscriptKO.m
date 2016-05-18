%SGN Script WT versus KO
%Script to find ISIs for SGN Ca
close all;

base = 'D:\Bergles Lab Data\RecordingsAndImaging\';
%filename, baseline start (sec), end, drug start, end
 files = {
            %WT
            '150719\15719003.abf',0,600,'WT'
             '150723\15723000.abf',0,600,'WT'
            '150723\15723002.abf',0,600,'WT'
            '150723\15723003.abf',0,600,'WT'
            '150723\15723006.abf',60,660,'WT'
            '150724\15724007.abf',0,600,'WT'
            '150725\15725007.abf',0,600,'WT'
            '150822\15822000.abf',0,600,'WT'
            '150822\15822002.abf',60,660,'WT'
            '150822\15822004.abf',0,600, 'WT'
            
            %KO
             '150724\15724000.abf',30,630,'KO'
             '150724\15724001.abf',0,600,'KO'
             '150724\15724002.abf',0,600,'KO'
             '150724\15724004.abf',0,600,'KO'
             '150724\15724005.abf',0,600,'KO'
             '150725\15725000.abf',0,600,'KO'
             '150725\15725005.abf',0,600,'KO'
             '150725\15725006.abf',0,600,'KO'
             '150905\15905000.abf',0,600,'KO'
             '150905\15905002.abf',0,600, 'KO'
             '150905\15905004.abf',0,600, 'KO' 
         };
     

%initialize data, uncomment if starting from no data loaded

spike_locs_WT={};
spike_locs_KO={};
size_files = size(files,1);
% ISI_data_WTKO = cell(size_files,6);
% 
% parfor i=1:size_files
%     ISI_slice = ISI_data_WTKO(i,:);
%     filepath = strcat(base,files{i,1});
%     display(filepath);
%     [pathstr, name] = fileparts(char(filepath));
%     ISI_slice{1,1}=name;
%     [d,time]=loadPclampData(filepath); %load pClamp data
%     time = time*1000; %convert seconds to milliseconds
%     
%     load start and end times for baseline and drug application
%     bl_start = files{i,2};
%     bl_end = files{i,3};
%     d = d(time >= bl_start*1000 & time <= bl_end*1000);
%     time = time(time >=bl_start*1000 & time <=bl_end*1000);
%     time = time - time(1);
%     
%     get ISIs
%       [b_sp,b_ISIs,b_locs]=SGNpeaksSingle(d,time);
%       ISI_slice{1,2} = files{i,4};
%       ISI_slice{1,3}=b_sp;
%       ISI_slice{1,4}=b_ISIs;
%       ISI_slice{1,5}=b_locs;
%     
%     ISI_data{i,8}=d;
%     ISI_data{i,9}=time;
%     
%     create figure to showcase data
%     figure(i);
%     subplot(2,1,1);
%     plot(resample(time/1000,1,10),resample(d,1,10));
%     upper_y = max(d);
%     axis([bl_start bl_end -inf upper_y+2]);
%     ISI_data_WTKO(i,:)=ISI_slice;
% end
% 
% concatenate baseline and drug conditions for total histogram
wildtype = zeros(0,1);
KO = zeros(0,1);
for i=1:size(ISI_data_WTKO,1)
    b_locs = ISI_data_WTKO{i,5};
    if strcmp(ISI_data_WTKO{i,2},'WT')
        wildtype = vertcat(wildtype,ISI_data_WTKO{i,4});
        spike_locs_WT{size(spike_locs_WT,2)+1}=b_locs'/1000;
    elseif strcmp(ISI_data_WTKO{i,2},'KO')
        KO = vertcat(KO,ISI_data_WTKO{i,4});
        spike_locs_KO{size(spike_locs_KO,2)+1}=b_locs'/1000;
    end
end

bursts = zeros(21,11);

%for j=1:11
%[mb_thr, b_thr] =  SGNgaussianfit(baseline);
mb_thr = 20;
b_thr = 1500;
%b_thr = 1000 + (j-1)*100;

%plot histogram of conditions
ISI_histogram(wildtype,KO);

%use thresholds to detect bursts of activity
WT_intervals_tot = NaN(size(files,1),11);
KO_intervals_tot = NaN(size(files,1),11);

for i=1:size(files,1)
   %baseline
   ISIs = ISI_data_WTKO{i,4};
   locs = ISI_data_WTKO{i,5};
   [intervals, burst_locs,num_bursts,spikesPerBurst,burst_dur] = SGNbursts(ISIs, mb_thr, b_thr, locs);
   %bursts(i,j) = max(ISI_burstdata(:,3));
   num_bursts
   ISI_data_WTKO{i,6} = num_bursts;
   ISI_data_WTKO{i,7} = spikesPerBurst;
   ISI_data_WTKO{i,8} = burst_dur/1000;
   ISI_data_WTKO{i,9} = burst_locs;
   
   if strcmp(ISI_data_WTKO{i,2},'WT')
       WT_intervals_tot(i,:)=mean(intervals);
       b_burst_locs = burst_locs/1000;
       clearvars ISI_burstdata intervals burst_locs;
   elseif strcmp(ISI_data_WTKO{i,2},'KO')
      KO_intervals_tot(i,:)=mean(intervals);
      d_burst_locs = burst_locs/1000;
      clearvars ISI_burstdata intervals burst_locs; 
   end
   
   b_int_std = nanstd(WT_intervals_tot);
   d_int_std = nanstd(KO_intervals_tot);
   b_int_mean = nanmean(WT_intervals_tot);
   d_int_mean = nanmean(KO_intervals_tot);
   
end
%PDF for histogram
figure;
ksdensity(log10(wildtype),[0:0.01:5]')

hold on;
ksdensity(log10(KO),[0:0.01:5]');

%end
 figure;
   errorbar(b_int_mean',b_int_std);
   hold on;
   errorbar(d_int_mean',d_int_std);
   
   figure;
   plotSpikeRaster(spike_locs_WT,'PlotType','vertLine');
   figure;
   plotSpikeRaster(spike_locs_KO,'PlotType','vertLine');
%clearvars -except ISI_data
