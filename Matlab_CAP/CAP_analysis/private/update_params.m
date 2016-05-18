function update_params(handles);	

filename = fullfile(fileparts(which('cap_analysis')),'private','get_analysis_ins.m');
fid = fopen(filename,'wt+');

fprintf(fid,'%s\n\n','function Params = get_analysis_ins');
fprintf(fid,'%s\n\n','%CAP Analysis Instruction Block');
fprintf(fid,'%s%s%s\n','Params = struct(''cal_pic'',''',get(handles.cal_pic,'String'),''', ...');
fprintf(fid,'\t%s%s%s\n','''abr_pic'',''',get(handles.abr_pic,'String'),''', ...');

if strncmpi(get(handles.start_resp,'String'),'a',1)
    fprintf(fid,'\t%s\n','''start_resp'',''auto'', ...');
else
    fprintf(fid,'\t%s%s%s\n','''start_resp'',''',get(handles.start_resp,'String'),''', ...');
end
if strncmp(lower(handles.window_resp),'a',1)
    fprintf(fid,'\t%s\n','''window_resp'',''auto'', ...');
else
    fprintf(fid,'\t%s%s%s\n','''window_resp'',''',get(handles.window_resp,'String'),''', ...');
end
if strncmp(lower(handles.start_back),'a',1)
    fprintf(fid,'\t%s\n','''start_back'',''auto'', ...');
else
    fprintf(fid,'\t%s%s%s\n','''start_back'',''',get(handles.start_back,'String'),''', ...');
end
if strncmp(lower(handles.window_back),'a',1)
    fprintf(fid,'\t%s\n','''window_back'',''auto'', ...');
else
    fprintf(fid,'\t%s%s%s\n','''window_back'',''',get(handles.window_back,'String'),''', ...');
end
if strncmp(lower(handles.scale),'a',1)
    fprintf(fid,'\t%s\n','''scale'',''auto'', ...');
else
    fprintf(fid,'\t%s%s%s\n','''scale'',''',get(handles.scale,'String'),''', ...');
end
%fprintf(fid,'\t%s%s%s\n','''dir'',''',get(handles.params.dir,'String'),''');');
fprintf(fid,'\t%s%s%s\n','''dir'',''',handles.params.dir,''');');

fclose(fid);
