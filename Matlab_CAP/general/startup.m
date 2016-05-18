function startup
global root_dir data_dir home_dir NelData

root_dir = fileparts(fileparts(which('startup')));
home_dir = fileparts(root_dir);
data_dir = fullfile(home_dir,'ExpData');

addpath(fullfile(root_dir,'general'));
addpath(fullfile(root_dir,'file_manager'));
addpath(fullfile(root_dir,'cap'));
addpath(fullfile(root_dir,'cap_analysis'));
addpath(fullfile(root_dir,'SetAmp'));

get_user_info;

%--------------------------------------------------------------------------
%may need to copy calibration file from general folder to data dir
destination = fullfile(data_dir,NelData.General.CurDataDir,'cal_p001.m');
if ~exist(destination,'file')
    if strncmp(NelData.General.speaker,'Radioshack',5)
        success = copyfile('cal_p001_rs.m',destination);
    elseif strncmp(NelData.General.speaker,'Fostex',5)
        success = copyfile('cal_p001_fx.m',destination);
    elseif strncmp(NelData.General.speaker,'Pyramid',5)
        success = copyfile('cal_p001_py.m',destination);
    elseif strncmp(NelData.General.speaker,'Tannoy',5)
        success = copyfile('cal_p001_tn.m',destination);
    elseif strncmp(NelData.General.speaker,'Vifa',4)   %GQ 01-08-15 added
        success = copyfile('cal_p001_vifa.m',destination);
    else
        success = copyfile('cal_p001.m',destination);
    end
    if success
        d = dir(fullfile(data_dir,NelData.General.CurDataDir));
       % d = dir(fullfile(data_dir,NelData.General.CurDataDir));
        fnum = length(d(find([d.isdir]==0)));
        anfiles = length(find(strncmp({d.name},'CAP',3)));
        NelData.General.fnum = fnum - anfiles;
        UpdateExplist(NelData.General.fnum);
    else
        warndlg('Calibration file wasn''t copied to data directory.','File Manager');
    end
end
%--------------------------------------------------------------------------
 %GQ 01-08-15 modified
if strncmp(NelData.General.speaker,'Fostex',5) | strncmp(NelData.General.speaker,'Vifa',4)
    NelData.General.Volts = SetAmp;
    UpdateExplist(NelData.General.fnum);
end

cap;