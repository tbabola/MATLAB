%Script to find ABR peaks

base = 'D:\Bergles Lab Data\RecordingsAndImaging\'
%click files
files = {'150528\tab-2015_05_28-ABR\EPavg_p037.m'
        '150608\tab-2015_06_08-ABR3\EPavg_p002.m'
        '150608\tab-2015_06_08-ABR3\EPavg_p034.m'
        '150608\tab-2015_06_08-ABR3\EPavg_p066.m'
        '150615\tab-2015_06_15-ABR\EPavg_p002.m'
        '150501\tb-2015_05_01-ABR_P2RY1KO\EPavg_p002.m' 
        '150528\tab-2015_05_28-ABR\EPavg_p004.m'
        '150609\tab-2015_06_09-ABR6\EPavg_p025.m'
        '150615\tab-2015_06_15-ABR\EPavg_p037.m' 
        '150615\tab-2015_06_15-ABR\EPavg_p067.m' 
        '150615\tab-2015_06_15-ABR\EPavg_p097.m' 
        '150615\tab-2015_06_15-ABR\EPavg_p129.m' 
        '150615\tab-2015_06_15-ABR\EPavg_p161.m' };

    condition = [0
        0
        0
        0
        0
        1
        1
        1
        1
        1
        1
        1
        1];
    
for i=1:size(files,1)
    filepath = strcat(base,files(i));
    display(filepath);
    [pathstr, name] = fileparts(char(filepath));
    olddir = cd(pathstr);
    
    x = eval(name);
    [ time , d ] = extractABR(x);
    figure;
    if  condition(i)==0
        plot(time,d,'Color','r');
    else
        plot(time,d,'Color','b');
    end
    axis([0 15 -5 5]);
    
end

%x = EPavg_p038;
%

%figure;
%plot(time,d);
%hold on;
%threshold = input('Select threshold\n');
%%[ pks , locs ] = findpeaks( d , time , 'MinPeakHeight', threshold);
%plot(locs,pks,'+');
%%locsfour = zeros(1,4);
%locsfour = locs(1:4);

%locsfour