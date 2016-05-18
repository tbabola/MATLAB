function dirname = get_directory

global data_dir Stimuli

home_dir = fileparts(fileparts(which('cap_analysis')));
data_dir = fullfile(home_dir,'ExpData');

d = dir(data_dir);
d = d(find([d.isdir]==1 & strncmp('.',{d.name},1)==0)); % Only directories which are not '.' nor '..'
str = {d.name};
[selection ok] = listdlg('Name', 'File Manager', ...
    'PromptString',   'Select an Existing Data Directory:',...
    'SelectionMode',  'single',...
    'ListSize',       [300,300], ...
    'OKString',       'Re-Activate', ...
    'CancelString',   'Create new Directory', ...
    'InitialValue',    1, ...
    'ListString',      str);
drawnow;
if (ok==0 | isempty(selection))
    dirname = Stimuli.dir;
else
    dirname = str{selection};
end
