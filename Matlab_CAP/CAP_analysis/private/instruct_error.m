%Repair Analysis Instruction Block

function instruct_error;	

prog_dir = fileparts(which('get_analysis_ins'));
home_dir = fileparts(prog_dir);
data_dir = fullfile(home_dir,'ExpData');

filename = fullfile(prog_dir,'private','get_analysis_ins.m');
fid = fopen(filename,'wt+');

fprintf(fid,'%s\n\n','function Params = get_analysis_ins');
fprintf(fid,'%s\n\n','%CAP Analysis Instruction Block');
fprintf(fid,'%s\n','Params = struct(''cal_pic'',''1'', ...');
fprintf(fid,'\t%s\n','''abr_pic'',''3-4'', ...');
fprintf(fid,'\t%s\n','''start_resp'',''auto'', ...');
fprintf(fid,'\t%s\n','''window_resp'',''auto'', ...');
fprintf(fid,'\t%s\n','''start_back'',''auto'', ...');
fprintf(fid,'\t%s\n','''window_back'',''auto'', ...');
fprintf(fid,'\t%s\n','''scale'',''auto'', ...');
fprintf(fid,'\t%s%s%s\n','''dir'',''',data_dir,''');');

fclose(fid);

errstr = sprintf('%s\n%s','Corrupted instructions have been repaired.','Correct your parameters.');
uiwait(errordlg(errstr,'Analysis Error'));

