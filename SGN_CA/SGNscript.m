%Script to find ISIs for SGN Ca

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

            %WT + MRS25000
            %'150719\15719003.abf',0,600,900,1500
            %'150723\15723000.abf',0,600,900,1500
            %'150723\15723002.abf',0,600,900,1500
            %'150723\15723003.abf',0,600,900,1500
            %'150723\15723006.abf',60,660,960,1560
            
             '150724\15724000.abf',30,630,930,1530
             '150724\15724001.abf',0,600,900,1500
             '150724\15724002.abf',0,600,601,602
             '150724\15724004.abf',0,600,900,1500
         };

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
    
    %get ISIs
    [b_sp,b_ISIs,b_locs,d_sp,d_ISIs,d_locs,d_blsubtract]=SGNpeaks(d,time,[bl_start bl_end drug_start drug_end]);
    ISI_data{i,2}=b_sp;
    ISI_data{i,3}=b_ISIs;
    ISI_data{i,4}=b_locs;
    ISI_data{i,5}=d_sp;
    ISI_data{i,6}=d_ISIs;
    ISI_data{i,7}=d_locs;
    %ISI_data{i,8}=d;
    %ISI_data{i,9}=time;
    
    %create figure to showcase data
    figure(i);
    subplot(2,1,1);
    plot(time/1000,d_blsubtract);
    upper_y = max(d);
    axis([bl_start drug_end -inf upper_y+2]);
    line([drug_start drug_end],[upper_y+1 upper_y+1]);
end

%concatenate baseline and drug conditions for total histogram
baseline = zeros(0,1);
MRS = zeros(0,1);
for i=1:size(files,1)
    baseline = vertcat(baseline,ISI_data{i,3});
    MRS = vertcat(MRS,ISI_data{i,6});
end

%[mb_thr, b_thr] =  SGNgaussianfit(baseline);
mb_thr = 19.16;
b_thr = 1500;

%plot histogram of conditions
edges = 10.^(-1:0.1:6);
figure;
histogram(baseline,edges); 
hold on;
histogram(MRS,edges);
hold off;
set(gca,'XScale','log');
axis([10^0 10^5 -inf inf]);
line([mb_thr b_thr;mb_thr b_thr],[0 0; 100 100]);

%use thresholds to detect bursts of activity
b_intervals_tot = NaN(size(files,1),11);
d_intervals_tot = NaN(size(files,1),11);

for i=1:size(files,1)
   %baseline
   b_ISIs = ISI_data{i,3};
   b_locs = ISI_data{i,4};
   [ISI_burstdata, intervals, burst_locs] = SGNbursts(b_ISIs, mb_thr, b_thr, b_locs);
   b_ISI_burstdata = ISI_burstdata;
   b_intervals = intervals;
   b_intervals_tot(i,:)=mean(b_intervals);
   b_burst_locs = burst_locs/1000;
   clearvars ISI_burstdata intervals burst_locs;
   
   %drugs
   d_ISIs = ISI_data{i,6};
   d_locs = ISI_data{i,7};
   [ISI_burstdata, intervals, burst_locs] = SGNbursts(d_ISIs, mb_thr, b_thr, d_locs);
   d_ISI_burstdata = ISI_burstdata;
   d_intervals = intervals;
   d_intervals_tot(i,:)=mean(d_intervals);
   d_burst_locs = burst_locs/1000;
   clearvars ISI_burstdata intervals burst_locs;
   
   b_int_std = nanstd(b_intervals_tot);
   d_int_std = nanstd(d_intervals_tot);
   b_int_mean = nanmean(b_intervals_tot);
   d_int_mean = nanmean(d_intervals_tot);
   
   figure;
   errorbar(b_int_mean',b_int_std);
   hold on;
   errorbar(d_int_mean',d_int_std);
   
   
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

