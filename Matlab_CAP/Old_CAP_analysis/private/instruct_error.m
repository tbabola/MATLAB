%Repair Analysis Instruction Block

function instruct_error;	
global Stimuli root_dir data_dir

filename = fullfile(root_dir,'CAP_analysis','private','get_analysis_ins.m');
fid = fopen(filename,'wt+');

fprintf(fid,'%s\n\n','%CAP Analysis Instruction Block');
fprintf(fid,'%s%d%s\n','Stimuli = struct(''cal_pic'',',1,', ...');
fprintf(fid,'\t%s%d%s\n','''del_pic'',',2,', ...');
fprintf(fid,'\t%s\n','''abr_pic'',''3-4'', ...');
fprintf(fid,'\t%s\n','''start_resp'',''auto'', ...');
fprintf(fid,'\t%s\n','''window_resp'',''auto'', ...');
fprintf(fid,'\t%s\n','''start_back'',''auto'', ...');
fprintf(fid,'\t%s\n','''window_back'',''auto'', ...');
fprintf(fid,'\t%s\n','''scale'',''auto'', ...');
fprintf(fid,'\t%s%d%s\n','''automatic'',',1,', ...');
fprintf(fid,'\t%s\n','''mode'',''threshold'', ...');
fprintf(fid,'\t%s%s%s\n','''dir'',''',data_dir,''');');

fclose(fid);


errstr = sprintf('%s\n%s','Corrupted instructions have been repaired.','Correct your parameters.');
uiwait(errordlg(errstr,'Analysis Error'));

