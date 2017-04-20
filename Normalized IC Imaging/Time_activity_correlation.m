[~,str] = dos('dir "M:\Bergles Lab Data\RecordingsAndImaging\*.czi" /s');
str= strrep(str,',','');
rgx = '(\d{2}/\d{2}/\d{4})\s{2}(\d{2}):(\d{2})\s([AP]M)\s*\d*\s*Experiment-(\d*)';
tkn = regexp(str,rgx,'tokens');
%InVivo.dates = tkn{:,1};
%cell2m

date = [];
time1 = [];
time2 = [];
time = [];
experiment = [];

for i=1:size(tkn,2)
    date = {date; tkn{i}{1}};
    time1 = [time1; str2num(tkn{i}{2})];
    ampm = tkn{i}{4};
     if strcmp(ampm,'PM') && time1(end) < 12
         time1(end) = time1(end)+12;
     end
    time2 = [time2; str2num(tkn{i}{3})];
    time = [time; str2num([num2str(time1(end)) sprintf('%02d',(time2(end)))])];
    experiment = [experiment; str2num(tkn{i}{5})];
end

%%Next part of the code}
%dirToCheck = {'
%listing = dir('M:\Bergles Lab Data\Projects\In vivo imaging\*.m')

paths = {'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-265-P7_Wildtype_PCA\ICinfo16_dFoF.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-314-P6_Wildtype_PCA\ICinfo16_dFoF.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-330_processed\ICinfo16_dFoF.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-337-ds_PCApro\ICinfo16_dFoF.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-342_P2ry1het_ds.tif_PCA\ICinfo16_dFoF.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-495-P7-Snap25GC6s_Wildtype_PCA\ICinfo16_dFoF.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\Unilateral Ablations\Right Ablations\DUP_Experiment-373_processed\ICinfo16_dFoF.mat';
              % very weak signal 'M:\Bergles Lab Data\Projects\In vivo imaging\Unilateral Ablations\Right Ablations\DUP_Experiment-375-Rabl_ds.tif_PCA\ICinfo_PCA.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\Unilateral Ablations\Right Ablations\DUP_Experiment-378_ds.tif_PCA\ICinfo16_dFoF.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\Unilateral Ablations\Right Ablations\DUP_Experiment-385_dstif.tif_PCA\ICinfo16_dFoF.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\Unilateral Ablations\Right Ablations\DUP_Experiment-387_Rabl_ds.tif_PCA\ICinfo16_dFoF.mat';
            'M:\Bergles Lab Data\Projects\In vivo imaging\Unilateral Ablations\Right Ablations\DUP_Experiment-648_Rabl\ICinfo16_dFoF.mat';
            %'M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-571_P6-Snap25GC6s_PCA\ICinfo16_dFoF.mat'
            'M:\Bergles Lab Data\Projects\In vivo imaging\Unilateral Ablations\Left Ablations\DUP_Experiment-320_processed\ICinfo16_dFoF.mat';
               'M:\Bergles Lab Data\Projects\In vivo imaging\Unilateral Ablations\Left Ablations\DUP_Experiment-321_processed\ICinfo16_dFoF.mat';
               'M:\Bergles Lab Data\Projects\In vivo imaging\Unilateral Ablations\Left Ablations\DUP_Experiment-323_processed\ICinfo16_dFoF.mat';
               'M:\Bergles Lab Data\Projects\In vivo imaging\Unilateral Ablations\Left Ablations\DUP_Experiment-325_processed\ICinfo16_dFoF.mat';
               'M:\Bergles Lab Data\Projects\In vivo imaging\Unilateral Ablations\Left Ablations\DUP_Experiment-336_processed\ICinfo16_dFoF.mat';
               'M:\Bergles Lab Data\Projects\In vivo imaging\vGluT3 KO\DUP_Experiment-496-P7-Snap25GC6s_vGluT3_PCA\ICinfo16_dFoF.mat';
             'M:\Bergles Lab Data\Projects\In vivo imaging\vGluT3 KO\DUP_Experiment-545_P8_Snap25GC6s_vGluT3_matreg_PCA\ICinfo16_dFoF.mat';
             'M:\Bergles Lab Data\Projects\In vivo imaging\vGluT3 KO\DUP_Experiment-593-Snap25GC6s_vGluT3KO_PCA\ICinfo16_dFoF.mat';
             'M:\Bergles Lab Data\Projects\In vivo imaging\vGluT3 KO\DUP_Experiment-606_Snap25GC6s_vGluT3KO_PCA\ICinfo16_dFoF.mat';
             'M:\Bergles Lab Data\Projects\In vivo imaging\vGluT3 KO\DUP_Experiment-607_Snap25GC6s_vGluT3KO_PCA\ICinfo16_dFoF.mat'
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
    %type{i} = {type; tkn2}
end

for i=1:size(file_activity,1)
  expNum = file_activity(i,1);
  ind = find(experiment == expNum);
  if size(ind,1) > 1
      ind = ind(1)
  end
  file_activity(i,3) = time(ind);
end

figure;
plot(file_activity(:,3),file_activity(:,2)/10,'o');
ylim([0 20]);
fit = polyfit(file_activity(:,3),file_activity(:,2)/10,1);
hold on;
plot(file_activity(:,3),polyval(fit,file_activity(:,3)));