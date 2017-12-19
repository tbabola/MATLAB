%% load
[fn dname] = uigetfile(dname);
[d,si,h] = abfload([dname fn]);
Fs = 1/(si*10^-6);
d = d(1:Fs*600+1);
[m,n] = size(d);
time = [1:1:m]/Fs;
%%
%thr = 2*std(d,1,1); 
thr = 70;
dp = msbackadj(time',d*-1,'WindowSize',100)*-1;
figure;plot(time,dp); hold on; plot(time,d); hold off;
[pks, locs] = findISCpeaks2(dp,time,thr);
[d_int,time_int] = integrateISCs(dp,time);

ISCstats.trace = d;
ISCstats.traceBL = dp;
ISCstats.time = time;
ISCstats.pks = pks;
ISCstats.locs = locs;
ISCstats.integral = -d_int(end) / time_int(end); %-pA/S

%%save
dirN = ['M:\Bergles Lab Data\Projects\In Vivo Imaging and VG3 Paper\In Vitro Experiments\ISCCurrents\' 'VG3 KO\'];
[pathstr, name, ext] = fileparts([dname fn]);
save([dirN 'ISCstats_' name '.mat'],'ISCstats');

%% group data
WTdir = 'M:\Bergles Lab Data\Projects\In Vivo Imaging and VG3 Paper\In Vitro Experiments\ISCCurrents\WT Littermate\';
KOdir = 'M:\Bergles Lab Data\Projects\In Vivo Imaging and VG3 Paper\In Vitro Experiments\ISCCurrents\VG3 KO\';

list = dir([WTdir '*.mat']);
m = size(list,1);
WTdata = table();
for i=1:m
    load([WTdir list(i).name]);
    WTdata = [WTdata; {list(i).name size(ISCstats.pks,1)/max(ISCstats.time)*60 ISCstats.integral mean(ISCstats.pks) median(ISCstats.pks) var(ISCstats.trace)}];
end
WTdata.Properties.VariableNames = {'File','Frequency','Integral','MeanAmp','MedianAmp','Variance'};

list = dir([KOdir '*.mat']);
m = size(list,1);
KOdata = table();
for i=1:m
    load([KOdir list(i).name]);
    KOdata = [KOdata; {list(i).name size(ISCstats.pks,1)/max(ISCstats.time)*60 ISCstats.integral mean(ISCstats.pks) median(ISCstats.pks) var(ISCstats.trace)}];
end
KOdata.Properties.VariableNames = {'File','Frequency','Integral','MeanAmp','MedianAmp','Variance'};

dirN = 'M:\Bergles Lab Data\Projects\In Vivo Imaging and VG3 Paper\In Vitro Experiments\ISCCurrents\VG3 KO\Group Data\';
save([dirN 'groupKOdata.mat'],'KOdata');
dirN = 'M:\Bergles Lab Data\Projects\In Vivo Imaging and VG3 Paper\In Vitro Experiments\ISCCurrents\WT Littermate\Group Data\';
save([dirN 'groupWTdata.mat'],'WTdata');




