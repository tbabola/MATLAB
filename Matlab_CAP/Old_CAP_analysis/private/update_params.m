function update_params;	
global Stimuli root_dir

filename = fullfile(root_dir,'CAP_analysis','private','get_analysis_ins.m');
fid = fopen(filename,'wt+');

fprintf(fid,'%s\n\n','%CAP Analysis Instruction Block');
fprintf(fid,'%s%d%s\n','Stimuli = struct(''cal_pic'',',Stimuli.cal_pic,', ...');
fprintf(fid,'\t%s%d%s\n','''del_pic'',',Stimuli.del_pic,', ...');
fprintf(fid,'\t%s%s%s\n','''abr_pic'',''',Stimuli.abr_pic,''', ...');

if strncmp(lower(Stimuli.start_resp),'a',1)
    fprintf(fid,'\t%s\n','''start_resp'',''auto'', ...');
else
    fprintf(fid,'\t%s%5.2f%s\n','''start_resp'',',Stimuli.start_resp,', ...');
end
if strncmp(lower(Stimuli.window_resp),'a',1)
    fprintf(fid,'\t%s\n','''window_resp'',''auto'', ...');
else
    fprintf(fid,'\t%s%5.2f%s\n','''window_resp'',',Stimuli.window_resp,', ...');
end
if strncmp(lower(Stimuli.start_back),'a',1)
    fprintf(fid,'\t%s\n','''start_back'',''auto'', ...');
else
    fprintf(fid,'\t%s%5.2f%s\n','''start_back'',',Stimuli.start_back,', ...');
end
if strncmp(lower(Stimuli.window_back),'a',1)
    fprintf(fid,'\t%s\n','''window_back'',''auto'', ...');
else
    fprintf(fid,'\t%s%5.2f%s\n','''window_back'',',Stimuli.window_back,', ...');
end
if strncmp(lower(Stimuli.scale),'a',1)
    fprintf(fid,'\t%s\n','''scale'',''auto'', ...');
else
    fprintf(fid,'\t%s%5.2f%s\n','''scale'',',Stimuli.scale,', ...');
end
fprintf(fid,'\t%s%d%s\n','''automatic'',',Stimuli.automatic,', ...');
fprintf(fid,'\t%s%s%s\n','''mode'',''',Stimuli.mode,''', ...');
fprintf(fid,'\t%s%s%s\n','''dir'',''',Stimuli.dir,''');');

fclose(fid);
