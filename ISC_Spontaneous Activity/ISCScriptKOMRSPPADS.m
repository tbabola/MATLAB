 %Script to find ISC spontaneous activity (peaks, frequency, and integral) between WT and KO

base = 'D:\Bergles Lab Data\RecordingsAndImaging\';
%filename, baseline start (sec), end, drug start, end
 files = {
            %WT, MRS, MRS+PPADS experiments
            '150430\15430002.abf','KO',0,300
            '150430\15430002.abf','MRS',600,900
             
            '150929\15929004.abf','KO',60,360
            '150929\15929004.abf','MRS',540,840
            
            '151016\15o16006.abf','KO',0,300
            '151016\15o16006.abf','MRS',480,780   
            
            '151016\15o16023.abf','KO',60,360
            '151016\15o16023.abf','MRS',540,860
            
            '151016\15o16027.abf','KO',0,300
            '151016\15o16027.abf','MRS',480,780 
         };

for i=1:size(files,1)
    filepath = strcat(base,files{i,1});
    display(filepath);
    [pathstr, name] = fileparts(char(filepath));
    ISC_data{i,1}=name;
    [d,time]=loadPclampData(filepath); %load pClamp data
    
    %load start and end times for measurement
    bl_start = files{i,3};
    bl_end = files{i,4};
    
    %subtract baseline
    winStepSize = 100; %best fit for this data
    dinv = d*-1;
    %figure;
    baseline = msbackadj(time,dinv,'StepSize',winStepSize,'WindowSize',winStepSize,'SHOWPLOT',1);
    d = baseline;
    d = d*-1;
    
    %only analyze noted start and end times
    d = d(time >= bl_start & time <= bl_end);
    time = time(time >= bl_start & time <= bl_end);
   
    %get ISIs
    [pks,locs]=findISCpeaks(d,time,[bl_start bl_end]);
    ISC_data{i,2} = files{i,2}; % stores condition
    ISC_data{i,3} = pks;
    ISC_data{i,4} = locs;
    ISC_data{i,5} = size(pks,1)/(bl_end-bl_start); %frequency
    ISC_data{i,6} = trapz(time,d)/(bl_end-bl_start);
    ISC_data{i,7} = mean(pks);
%     
%     %create figure to showcase data
%     figure(i);
%     subplot(2,1,1);
%     plot(time/1000,d_blsubtract);
%     upper_y = max(d);
%     axis([bl_start drug_end -inf upper_y+2]);
%     line([drug_start drug_end],[upper_y+1 upper_y+1]);
end

% %concatenate baseline and drug conditions for total histogram
% baseline = zeros(0,1);
% MRS = zeros(0,1);
% for i=1:size(files,1)
%     baseline = vertcat(baseline,ISI_data{i,3});
%     MRS = vertcat(MRS,ISI_data{i,6});
% end
% 
% %[mb_thr, b_thr] =  SGNgaussianfit(baseline);
% mb_thr = 19.16;
% b_thr = 1500;
% 
% %plot histogram of conditions
% edges = 10.^(-1:0.1:6);
% figure;
% histogram(baseline,edges); 
% hold on;
% histogram(MRS,edges);
% hold off;
% set(gca,'XScale','log');
% axis([10^0 10^5 -inf inf]);
% line([mb_thr b_thr;mb_thr b_thr],[0 0; 100 100]);
% 
% %use thresholds to detect bursts of activity
% b_intervals_tot = NaN(size(files,1),11);
% d_intervals_tot = NaN(size(files,1),11);
% 
% for i=1:size(files,1)
%    %baseline
%    b_ISIs = ISI_data{i,3};
%    b_locs = ISI_data{i,4};
%    [ISI_burstdata, intervals, burst_locs] = SGNbursts(b_ISIs, mb_thr, b_thr, b_locs);
%    b_ISI_burstdata = ISI_burstdata;
%    b_intervals = intervals;
%    b_intervals_tot(i,:)=mean(b_intervals);
%    b_burst_locs = burst_locs/1000;
%    clearvars ISI_burstdata intervals burst_locs;
%    
%    %drugs
%    d_ISIs = ISI_data{i,6};
%    d_locs = ISI_data{i,7};
%    [ISI_burstdata, intervals, burst_locs] = SGNbursts(d_ISIs, mb_thr, b_thr, d_locs);
%    d_ISI_burstdata = ISI_burstdata;
%    d_intervals = intervals;
%    d_intervals_tot(i,:)=mean(d_intervals);
%    d_burst_locs = burst_locs/1000;
%    clearvars ISI_burstdata intervals burst_locs;
%    
%    b_int_std = nanstd(b_intervals_tot);
%    d_int_std = nanstd(d_intervals_tot);
%    b_int_mean = nanmean(b_intervals_tot);
%    d_int_mean = nanmean(d_intervals_tot);
%    
%    figure;
%    errorbar(b_int_mean',b_int_std);
%    hold on;
%    errorbar(d_int_mean',d_int_std);
%    
%    
%    figure(i);
%    subplot(2,1,1);
%    for j=1:size(b_burst_locs,1)
%        line([b_burst_locs(j,1) b_burst_locs(j,2)],[1 1],'LineWidth',4,'Color','r');
%    end
%    for j=1:size(d_burst_locs,1)
%        line([d_burst_locs(j,1) d_burst_locs(j,2)],[1 1],'LineWidth',4,'Color','g');
%    end
%  
%    subplot(2,1,2);
%    plot(mean(b_intervals)');
%    hold on;
%    plot(mean(d_intervals)');
%    hold off;
% end

