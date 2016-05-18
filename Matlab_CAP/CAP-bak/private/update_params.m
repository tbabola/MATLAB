function update_params;	
global Stimuli root_dir					

fid = fopen(fullfile(root_dir,'cap','private','get_averaging_ins.m'),'wt');

fprintf(fid,'%s\n\n','%Signal Averager Instruction Block');
fprintf(fid,'%s%6.3f%s\n','Stimuli = struct(''freq_hz'',',Stimuli.freq_hz,', ...');
fprintf(fid,'\t%s%6.3f%s\n'  ,'''play_duration'', ',Stimuli.play_duration,', ...');
fprintf(fid,'\t%s%6.3f%s\n'  ,'''record_duration'',',Stimuli.record_duration,', ...');
fprintf(fid,'\t%s%6.3f%s\n'  ,'''SampRate'',',Stimuli.SampRate,', ...');
fprintf(fid,'\t%s%6.3f%s\n'  ,'''pulses_per_sec'',  ',Stimuli.pulses_per_sec,', ...');
fprintf(fid,'\t%s%6.3f%s\n'  ,'''rise_fall'',  ',Stimuli.rise_fall,', ...');
fprintf(fid,'\t%s%6.3f%s\n'  ,'''naves'', ',Stimuli.naves,', ...');
fprintf(fid,'\t%s%6.3f%s\n'  ,'''db_atten'', ',Stimuli.db_atten,', ...');
fprintf(fid,'\t%s%6.3f%s\n'  ,'''reject'',  ',Stimuli.reject,', ...');
fprintf(fid,'\t%s%6.3f%s\n'  ,'''masker_freq_hz'',  ',Stimuli.masker_freq_hz,', ...');
fprintf(fid,'\t%s%6.3f%s\n'  ,'''masker_duration'', ',Stimuli.masker_duration,', ...');
fprintf(fid,'\t%s%6.3f%s\n'  ,'''masker_delay_ms'',  ',Stimuli.masker_delay_ms,', ...');
fprintf(fid,'\t%s%6.3f%s\n'  ,'''masker_db_atten'',  ',Stimuli.masker_db_atten,', ...');
fprintf(fid,'\t%s%6.3f%s\n'  ,'''amp_gain'',  ',Stimuli.amp_gain,', ...');
fprintf(fid,'\t%s%s%s\n'  ,'''automatic'',  ''',Stimuli.automatic,''');');

fclose(fid);

cap('return');
