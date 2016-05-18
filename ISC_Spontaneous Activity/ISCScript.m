 %Script to find ISC spontaneous activity (peaks, frequency, and integral) between WT and KO

base = 'D:\Bergles Lab Data\RecordingsAndImaging\';
%filename, baseline start (sec), end, drug start, end
 files = {
            %WT, MRS, MRS+PPADS experiments
            '150503\15503004.abf','WT',0,300
            '150503\15503004.abf','MRS',600,900
            '150503\15503004.abf','MRSPPADS',1200,1500
            
            '150503\15503009.abf','WT',0,300
            '150503\15503009.abf','MRS',600,900
            '150503\15503009.abf','MRSPPADS',1200,1500
            
            '150219\A1P1_gapfree.abf','WT',0,300
            '150219\A1P1_gapfree.abf','MRS',480,780
            '150219\A1P1_gapfree.abf','MRSPPADS',960,1260
            
            '150306\A2P1\A2P1_gapfree.abf','WT',300,600
            '150306\A2P1\A2P1_gapfree.abf','MRS',900,1200
            '150306\A2P1\A2P1_gapfree.abf','MRSPPADS',1380,1680
            
            '150306\A3P1\A3P1_gapfree.abf','WT',15,315
            '150306\A3P1\A3P1_gapfree.abf','MRS',660,960
            '150306\A3P1\A3P1_gapfree.abf','MRSPPADS',1085,1385
            
            '150306\A4P1\A4P1_gapfree.abf','WT',60,360
            '150306\A4P1\A4P1_gapfree.abf','MRS',675,975
            '150306\A4P1\A4P1_gapfree.abf','MRSPPADS',1290,1590
            
            '150308\A3P1\A3P1_gapfree.abf','WT',15,315
            '150308\A3P1\A3P1_gapfree.abf','MRS',615,915
            '150308\A3P1\A3P1_gapfree.abf','MRSPPADS',1230,1530
            
            
            %KOs
            '150410\Concatenate000.abf','KO',140,440
            '150410\Concatenate000.abf','PPADS',740,1040
            '150430\15430002.abf','KO',0,300
            '150430\15430002.abf','MRS',600,900
            '150410\15410017.abf','KO',15,315
            '150410\15410017.abf','Benzbromarone',740,1040
            '150514\15514019.abf','WTLM',0,300
            '150520\A1P1\15520003.abf','WTLM',300,600
            %'150520\15520016.abf','WTLM',0,300
            '150520\A2P1_KO\15520025.abf','KO',300,600
            '150522\15522001.abf','WT',0,300
            %'150525\15525002.abf','WTLM',0,300 P0
            '150609\15609005.abf','KO',0,300
            '150609\15609014.abf','KO',0,300
            '150610\15610003.abf','KO',0,300
            '150802\15802002.abf','WTLM',300,600
            '150802\15802007.abf','WTLM',300,600
            '150802\15802010.abf','KO',300,600
            '150802\1580215.abf','WTLM',300,600
            %last updated 7/20/14
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
    ISI_data{i,5}=d;
    ISI_data{i,6}=time;
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

