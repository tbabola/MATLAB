%Script to find ISC spontaneous activity (peaks, frequency, and integral) between WT and KO

base = 'D:\Bergles Lab Data\RecordingsAndImaging\';
WT_count = 0;
WTLM_count = 0;
KO_count = 0;
%filename, baseline start (sec), end, drug start, end
 files = {
            %WT, MRS, MRS+PPADS experiments
            '150503\15503004.abf','WT',0,300
            '150503\15503009.abf','WT',0,300
            '150219\A1P1_gapfree.abf','WT',0,300
            '150306\A2P1\A2P1_gapfree.abf','WT',300,600
            '150306\A3P1\A3P1_gapfree.abf','WT',15,315
            '150306\A4P1\A4P1_gapfree.abf','WT',60,360
            '150308\A3P1\A3P1_gapfree.abf','WT',15,315
            '150522\15522001.abf','WT',0,300

            %WT Littermate Controls
            '150514\15514019.abf','WTLM',0,300
            '150520\A1P1\15520003.abf','WTLM',300,600
            '150802\15802002.abf','WTLM',300,600
            '150802\15802007.abf','WTLM',300,600
            '150802\15802015.abf','WTLM',300,600
            %'150525\15525002.abf','WTLM',0,300 P0
            %'150520\15520016.abf','WTLM',0,300 not usuable due to increase
            %in RN
            
            
            %KOs
            '150410\Concatenate000.abf','KO',140,440
            '150430\15430002.abf','KO',0,300
            '150410\15410017.abf','KO',15,315
            '150520\A2P1_KO\15520025.abf','KO',300,600
            '150609\15609005.abf','KO',0,300
            '150609\15609014.abf','KO',0,300
            '150610\15610003.abf','KO',0,300
            '150802\15802010.abf','KO',300,600
            '150929\15929004.abf','KO',0,300
            '151016\15o16006.abf','KO',0,300
            '151016\15o16009.abf','KO',0,300
            '151016\15o16013.abf','KO',0,300
            '151016\15o16023.abf','KO',0,300
            '151016\15o16027.abf','KO',0,300
            
            
            
            %last updated 10/20/15
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
    baseline = msbackadj(time,dinv,'StepSize',winStepSize,'WindowSize',winStepSize);
    d = baseline;
    d = d*-1;
    
    %only analyze noted start and end times
    d = d(time >= bl_start & time <= bl_end);
    time = time(time >= bl_start & time <= bl_end);
   
    %get ISIs
    [pks,locs]=findISCpeaks(d,time,[bl_start bl_end]);
    ISC_data{i,2} = files{i,2}; % stores condition
    ISC_data{i,3} = pks;
    ISC_data{i,4}= mean(ISC_data{i,3});
    ISC_data{i,5} = locs;
    ISC_data{i,6} = size(pks,1)/(bl_end-bl_start); %frequency
    ISC_data{i,7} = trapz(time,d)/(bl_end-bl_start);
    ISC_data{i,8}=d;
    ISC_data{i,9}=time;
    
    
    if strcmp(ISC_data{i,2},'WT')
        WT_count = WT_count + 1;
    elseif strcmp(ISC_data{i,2},'WTLM')
        WTLM_count = WTLM_count + 1;
    elseif strcmp(ISC_data{i,2},'KO')
        KO_count = KO_count + 1;
    end
    
end

WT_c = 0;
WTLM_c = 0;
KO_c = 0;
h(1) = figure; %WT
h(2) = figure; %WTLM
h(3) = figure; %KO

for i=1:size(files,1)
    time = ISC_data{i,9};
    d = ISC_data{i,8};
    
    if strcmp(ISC_data{i,2},'WT')
        figure(h(1));
        subplot(WT_count,1,WT_c+1)
        plot(time,d)
        WT_c = WT_c + 1;
    elseif strcmp(ISC_data{i,2},'WTLM')
        figure(h(2));
        subplot(WTLM_count,1,WTLM_c+1)
        plot(time,d)
        WTLM_c = WTLM_c + 1;
    elseif strcmp(ISC_data{i,2},'KO')
       figure(h(3));
        subplot(KO_count,1,KO_c+1)
        plot(time,d)
        KO_c = KO_c + 1;
    end
    axis([-inf inf -1500 200]);
end