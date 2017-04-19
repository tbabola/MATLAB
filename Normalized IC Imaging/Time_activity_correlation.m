% [~,str] = dos('dir "M:\Bergles Lab Data\RecordingsAndImaging\*.czi" /s');
% str tkn= strrep(str,',','');
% rgx = '(\d{2}/\d{2}/\d{4})\s{2}(\d{2}):(\d{2})\s([AP]M)\s*\d*\s*Experiment-(\d*)';
% tkn = regexp(str,rgx,'tokens');
% InVivo.dates = tkn{:,1};
%cell2m
% 
% date = [];
% time1 = [];
% time2 = [];
% time = [];
% experiment = [];
% 
% for i=1:size(tkn,2)
%     date = {date; tkn{i}{1}};
%     time1 = [time1; str2num(tkn{i}{2})];
%     ampm = tkn{i}{4};
%      if strcmp(ampm,'PM') && time1(end) < 12
%          time1(end) = time1(end)+12;
%      end
%     time2 = [time2; str2num(tkn{i}{3})];
%     time = [time; str2num([num2str(time1(end)) sprintf('%02d',(time2(end)))])];
%     experiment = [experiment; str2num(tkn{i}{5})];
% end

%%Next part of the code}
%dirToCheck = {'
%listing = dir('M:\Bergles Lab Data\Projects\In vivo imaging\*.m')

paths = {'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-265-P7_Wildtype_PCA\ICinfo16_dFoF.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-314-P6_Wildtype_PCA\ICinfo16_dFoF.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-330_processed\ICinfo16_dFoF.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-337-ds_PCApro\ICinfo16_dFoF.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-342_P2ry1het_ds.tif_PCA\ICinfo16_dFoF.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-495-P7-Snap25GC6s_Wildtype_PCA\ICinfo16_dFoF.mat';
            %'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-571_P6-Snap25GC6s_PCA\ICinfo16_dFoF.mat'
            };

file_activity=[];
type = {};

for i=1:size(paths,1)
    load(paths{i});
    disp(paths{i});
    rgx = 'Experiment-(\d*)';
    tkn = regexp(paths{i},rgx,'tokens');
    tkn = str2num(tkn{1}{1});
    rgx = 'imaging\(\w*)';
    tkn2 = regexp(paths{i},rgx,'tokens');
    
    [filePath name ext] = fileparts(paths{i});
    [stats, pkData] = findICpeaksdFoF(ICsignal,filePath,'PCA',0);
    file_activity(i,1:2)=[tkn stats{1,7}]
    type{i} = {type; tkn2}
end
  

 
