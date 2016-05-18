%SGN Script Wildtype versus MRS
%Script to find ISIs for SGN Ca

base = 'D:\Bergles Lab Data\RecordingsAndImaging\';
%filename, baseline start (sec), end, drug start, end
 files = {
            %KO + MRS25000
            '150905\15905000.abf',0,600,900,1500
            '150905\15905002.abf',0,600,900,1500
            '150905\15905004.abf',0,600,900,1500
         };

%initialize data, uncomment if starting from no data loaded
ISI_data = cell(size(files,1),7);
parfor i=1:size(files,1)
    ISI_slice = ISI_data(i,:);
    filepath = strcat(base,files{i,1});
    display(filepath);
    [pathstr, name] = fileparts(char(filepath));
    ISI_slice{1,1}=name
    [d,time]=loadPclampData(filepath); %load pClamp data
    time = time*1000; %convert seconds to milliseconds
    
    %load start and end times for baseline and drug application
    bl_start = files{i,2};
    bl_end = files{i,3};
    drug_start = files{i,4};
    drug_end = files{i,5};
    
    %get ISIs
    [b_sp,b_ISIs,b_locs,d_sp,d_ISIs,d_locs,d_blsubtract]=SGNpeaks(d,time,[bl_start bl_end drug_start drug_end]);
    ISI_slice{1,2}=b_sp;
    ISI_slice{1,3}=b_ISIs;
    ISI_slice{1,4}=b_locs;
    ISI_slice{1,5}=d_sp;
    ISI_slice{1,6}=d_ISIs;
    ISI_slice{1,7}=d_locs;
    
    %create figure to showcase data
    figure(i);
    subplot(2,1,1);
    plot(time/1000,d_blsubtract);
    upper_y = max(d);
    axis([bl_start drug_end -inf upper_y+2]);
    line([drug_start drug_end],[upper_y+1 upper_y+1]);

    ISI_data(i,:)=ISI_slice
 end

%concatenate baseline and drug conditions for total histogram
baseline = zeros(0,1);
MRS = zeros(0,1);
for i=1:size(ISI_data,1)
    baseline = vertcat(baseline,ISI_data{i,3});
    MRS = vertcat(MRS,ISI_data{i,6});
end

%[mb_thr, b_thr] =  SGNgaussianfit(baseline);
mb_thr = 19.16;
b_thr = 1500;

%plot histogram of conditions
ISI_histogram(baseline,MRS);

%use thresholds to detect bursts of activity
b_intervals_tot = NaN(size(files,1),11);
d_intervals_tot = NaN(size(files,1),11);

for i=1:size(files,1)
   %baseline
   b_ISIs = ISI_data{i,3};
   b_locs = ISI_data{i,4};
   [intervals, burst_locs,num_bursts,spikesPerBurst,burst_dur] = SGNbursts(b_ISIs, mb_thr, b_thr, b_locs);
   b_intervals = intervals;
   b_intervals_tot(i,:)=mean(b_intervals);
   b_burst_locs = burst_locs/1000;
   ISI_data{i,8} = num_bursts;
   ISI_data{i,9} = spikesPerBurst;
   ISI_data{i,10} = burst_dur;

   clearvars ISI_burstdata intervals burst_locs;
   
   %drugs
   d_ISIs = ISI_data{i,6};
   d_locs = ISI_data{i,7};
   [intervals, burst_locs,num_bursts,spikesPerBurst,burst_dur] = SGNbursts(d_ISIs, mb_thr, b_thr, d_locs);
   d_intervals = intervals;
   d_intervals_tot(i,:)=mean(d_intervals);
   d_burst_locs = burst_locs/1000;
   ISI_data{i,11} = num_bursts;
   ISI_data{i,12} = spikesPerBurst;
   ISI_data{i,13} = burst_dur;
   
   clearvars ISI_burstdata intervals burst_locs;
   
   b_int_std = nanstd(b_intervals_tot);
   d_int_std = nanstd(d_intervals_tot);
   b_int_mean = nanmean(b_intervals_tot);
   d_int_mean = nanmean(d_intervals_tot);   
   
   figure(i);
   subplot(2,1,1);
   for j=1:size(b_burst_locs,1)
       line([b_burst_locs(j,1) b_burst_locs(j,2)],[1 1],'LineWidth',4,'Color','r');
   end
   for j=1:size(d_burst_locs,1)
       line([d_burst_locs(j,1) d_burst_locs(j,2)],[1 1],'LineWidth',4,'Color','g');
   end
 
   subplot(2,1,2);
   plot(mean(b_intervals)');
   hold on;
   plot(mean(d_intervals)');
   hold off;
end

%PDF for histogram
figure;
ksdensity(log10(baseline),[0:0.01:5]')
hold on;
ksdensity(log10(MRS),[0:0.01:5]');

%intervals figure
figure;
errorbar(b_int_mean',b_int_std);
hold on;
errorbar(d_int_mean',d_int_std);
   
%clearvars -except ISI_data
