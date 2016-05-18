%Script to find ABR peaks

base = 'D:\Bergles Lab Data\RecordingsAndImaging\'

%click files
%wt
wt = 'EPavg_p%03d.m';
wt_dir = '150615\tab-2015_06_15-ABR\';
wt_ind = [97:2:103];
%KO
ko = 'EPavg_p%03d.m'
ko_dir = '150615\tab-2015_06_15-ABR\'
ko_ind = [129:2:135];

figure;
for i=1:size(wt_ind,2)
    wt_file = sprintf(wt,wt_ind(i));
    filepath = strcat(base,wt_dir,wt_file);
    [pathstr, name] = fileparts(char(filepath));
    olddir = cd(pathstr);
    
    x = eval(name);
    [ time , d ] = extractABR(x);

    subplot(size(wt_ind,2),2,2*(i-1)+1);
    plot(time,d);
    axis([0 15 -5 5]);
    axis off;
end

for i=1:size(ko_ind,2)
    ko_file = sprintf(ko,ko_ind(i));
    filepath = strcat(base,ko_dir,ko_file);
    
    [pathstr, name] = fileparts(char(filepath));
    olddir = cd(pathstr);
    
    x = eval(name);
    [ time , d ] = extractABR(x);

    subplot(size(wt_ind,2),2,2*i);
    plot(time,d);
    axis([0 15 -5 5]);
    if i > 1
     axis off;
    end
end