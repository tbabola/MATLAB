%Repair Analysis Instruction Block

function instruct_error;	
global Stimuli root_dir data_dir

filename = fullfile(root_dir,'cap','private','get_averaging_ins.m');
fid = fopen(filename,'wt+');

fprintf(fid,'%s\n\n','%Signal Averager Instruction Block');
fprintf(fid,'%s%d%s\n','Stimuli = struct(''freq_hz'',',16000,', ...');
fprintf(fid,'\t%s%d%s\n','''play_duration'',',5,', ...');
fprintf(fid,'\t%s%d%s\n','''record_duration'',',50,', ...');
fprintf(fid,'\t%s%d%s\n','''SampRate'',',195.313,', ...');
fprintf(fid,'\t%s%d%s\n','''pulses_per_sec'',',10,', ...');
fprintf(fid,'\t%s%d%s\n','''rise_fall'',',0.5,', ...');
fprintf(fid,'\t%s%d%s\n','''naves'',',100,', ...');
fprintf(fid,'\t%s%d%s\n','''db_atten'',',0,', ...');
fprintf(fid,'\t%s%d%s\n','''reject'',',1,', ...');
fprintf(fid,'\t%s%d%s\n','''masker_freq_hz'',',NaN,', ...');
fprintf(fid,'\t%s%d%s\n','''masker_duration'',',100,', ...');
fprintf(fid,'\t%s%d%s\n','''masker_delay_ms'',',100,', ...');
fprintf(fid,'\t%s%d%s\n','''masker_db_atten'',',0,', ...');
fprintf(fid,'\t%s%d%s\n','''amp_gain'',',10000,', ...');
fprintf(fid,'\t%s%\n','''automatic'',''no'');');

fclose(fid);

errstr = sprintf('%s\n%s','Corrupted instructions have been repaired.','Correct your parameters.');
uiwait(errordlg(errstr,'Averager Error'));

