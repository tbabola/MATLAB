function get_user_info

global NelData data_dir

explist;

user = {''}; title = 'User Login';
while ((isempty(user) | isempty(user{1})))
    user = lower(inputdlg({['User Name' char(10) '(e.g.; cap, bjm):']},title,1,{NelData.General.User},'on'));
    title = 'Please enter NON-EMPTY login name';
end
if (strcmp(NelData.General.User,user{1}))
    reactivate = 'Yes';
else
    reactivate = 'No';
end
NelData.General.User = user{1};
NelData.General.CurDataDir = choose_data_dir(reactivate);

d = dir(fullfile(data_dir,NelData.General.CurDataDir));
%d = dir(fullfile(data_dir,NelData.General.CurDataDir));

fnum = length(d(find([d.isdir]==0)));
anfiles = length(find(strncmp({d.name},'CAP',3)));
NelData.General.fnum = fnum - anfiles;

UpdateExplist(NelData.General.fnum);

%GQ 1-8-15 modified
ButtonName=questdlg('What is the speaker selection?', ...
    'Get Calibration', ...
    'Fostex','Vifa','Fostex');


switch ButtonName,
    case 'Fostex',
        NelData.General.speaker = 'Fostex';
    case 'Vifa',
        NelData.General.speaker = 'Vifa';
end % switch