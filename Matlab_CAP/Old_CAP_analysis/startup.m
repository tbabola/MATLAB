function startup
global root_dir data_dir home_dir NelData

root_dir = fileparts(which('startup'));
home_dir = fileparts(root_dir);
data_dir = fullfile(home_dir,'ExpData');

addpath(root_dir);

cap_analysis;