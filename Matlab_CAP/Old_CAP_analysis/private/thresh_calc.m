function [error] = thresh_calcglobal FIG Stimuli ABRmag root_dir data_dir analysiserror = [];for i = 1:20    eval(['set(FIG.abrs.abr' num2str(i) ' ,''Visible'',''off'');']);    eval(['set(FIG.rwins.rwin' num2str(i) ' ,''Visible'',''off'');']);    eval(['set(FIG.bwins.bwin' num2str(i) ' ,''Visible'',''off'');']);endset(FIG.ax1.line1,'Visible','off');set(FIG.ax1.line2,'Visible','off');set(FIG.ax1.line3,'Visible','off');cur_dir = cd(fullfile(data_dir,Stimuli.dir));CalibFile = ['cal_p00' num2str(Stimuli.cal_pic)];while length(CalibFile) > 10,    CalibFile = strrep(CalibFile,'p0','p');endif ~exist([CalibFile],'file')    CalibFile = 'p0001_calib';endcommand_line = sprintf('%s%s%c','[xcal]=',CalibFile,';');eval(command_line);%parse ABR picture sequence[picnums] = ParseInputPicString(Stimuli.abr_pic);analysis_fnam = ['CAP_analysis_p' strrep(Stimuli.abr_pic,'-','_') '.m'];num_files = length(picnums);ABRmag = zeros(num_files,6);max_resp = 0;for file = 1:num_files    index = picnums(file);    EPfile = ['EPavg_p00' num2str(index)];    while length(EPfile) > 10,        EPfile = strrep(EPfile,'p0','p');    end    if ~exist([EPfile],'file')        warndlg([EPfile ' not found in data directory.']);        return    end    command_line = sprintf('%s%s%c','[x]=',EPfile,';');    eval(command_line);    if file == 1        ButtonName = [];        eflag.freq_hz = 0;        eflag.db_atten = 0;        eflag.masker_present = 0;        eflag.masker_freq_hz = 0;        eflag.masker_db_atten = 0;        eflag.masker_delay_ms = 0;                set(FIG.ax2.axes,'xlim',[0 max(x.AverageData(:,1))]);        freq_check = x.Stimuli.freq_hz;        db_atten_check = x.Stimuli.db_atten;        masker_freq_check = x.Stimuli.masker_freq_hz;        masker_atten_check = x.Stimuli.masker_db_atten;        masker_delay_check = x.Stimuli.masker_delay_ms;        DATE_STR = x.General.date;        DATE_STR = x.General.date;        if freq_check,            freq_loc = find(xcal.CalibData(:,1)>=(freq_check/1000));            freq_lev = xcal.CalibData(freq_loc(1),2);        else            %click calibration on 4/6/06            %using peak equivalent SPL            %indicates baseline to peak amplitude of click is 3 dB above tone            %matching tone calibration was 65 dB SPL - 10 dB at 2k            %click is 55 + 3 dB at 0 dB attenuation            %see Burkhard (1984) for details            freq_lev = 58;        end        if isfinite(masker_freq_check)            masker_loc = find(xcal.CalibData(:,1)>=(masker_freq_check/1000));            masker_lev = xcal.CalibData(masker_loc(1),2);        end    end           if x.Stimuli.freq_hz ~= freq_check,        eflag.freq_hz = 1;    end    if x.Stimuli.db_atten ~= db_atten_check,        eflag.db_atten = 1;    end    if isfinite(x.Stimuli.masker_freq_hz)        if isnan(masker_freq_check)            eflag.masker_freq_hz = 1;        else            eflag.masker_present = 1;        end    else        if isfinite(masker_freq_check)            eflag.masker_freq_hz = 1;        end    end    if x.Stimuli.masker_db_atten ~= masker_atten_check,        eflag.masker_db_atten = 1;    end    if x.Stimuli.masker_delay_ms ~= masker_delay_check,        eflag.masker_delay_ms = 1;    end        if eflag.freq_hz,        warndlg('Different signal frequencies.');        return    elseif eflag.masker_freq_hz,        warndlg('Different masker frequencies.');        return    end        if strncmp(lower(Stimuli.start_resp),'a',1)        if isfinite(x.Stimuli.masker_freq_hz)            if ~isfield(x.Stimuli,'masker_duration')                x.Stimuli.masker_duration = 100;            end            start_resp(file) = x.Stimuli.masker_delay_ms + x.Stimuli.masker_duration;        else            start_resp(file) = 1;        end    else        start_resp(file) = Stimuli.start_resp;    end    if strncmp(lower(Stimuli.window_resp),'a',1)        window_resp = 5;    else        window_resp = Stimuli.window_resp;    end    if strncmp(lower(Stimuli.window_back),'a',1)        window_back = 5;    else        window_back = Stimuli.window_back;    end    if strncmp(lower(Stimuli.start_back),'a',1)        start_back(file) = x.Stimuli.record_duration - window_back;    else        start_back(file) = Stimuli.start_back;    end    end_resp(file) = start_resp(file)+window_resp;    end_back(file) = start_back(file)+window_back;        plotx(:,file) =  x.AverageData(:,1);    ploty(:,file) =  x.AverageData(:,4);    fstrsp = max(find(x.AverageData(:,1)<=start_resp(file)));    lstrsp = min(find(x.AverageData(:,1)>=end_resp(file)));    fstbck = max(find(x.AverageData(:,1)<=start_back(file)));    lstbck = min(find(x.AverageData(:,1)>=end_back(file)));    ABRmag(file,1) = freq_lev - x.Stimuli.db_atten;    ABRmag(file,2) = max(x.AverageData(fstrsp:lstrsp,4)) - min(x.AverageData(fstrsp:lstrsp,4));    ABRmag(file,3) = max(x.AverageData(fstbck:lstbck,4)) - min(x.AverageData(fstbck:lstbck,4));        if isfinite(x.Stimuli.masker_freq_hz)        ABRmag(file,5) = masker_lev - x.Stimuli.masker_db_atten;        ABRmag(file,6) = x.Stimuli.masker_delay_ms;    endend%determine type of analysisif ~eflag.masker_present    Stimuli.mode = 'threshold';    set(FIG.parm_txt(9),'string',Stimuli.mode);elseif eflag.masker_db_atten & ~eflag.masker_delay_ms    Stimuli.mode = 'masker';    set(FIG.parm_txt(9),'string',Stimuli.mode);elseif ~eflag.masker_db_atten & eflag.masker_delay_ms    Stimuli.mode = 'delay';    set(FIG.parm_txt(9),'string',Stimuli.mode);else    warndlg('Improper stimulus configuration','Analysis Error')    returnendif strncmp(Stimuli.mode,'m',1) %mode defines details of analysis    param_of_interest = 5;    set(FIG.ax2.ylab,'String','Masker level (dB SPL)');elseif strncmp(Stimuli.mode,'d',1)    param_of_interest = 6;    set(FIG.ax2.ylab,'String','Masker delay (msec)');else    param_of_interest = 1;    set(FIG.ax2.ylab,'String','Signal level (dB SPL)');endif strncmp(lower(Stimuli.scale),'a',1)    max_resp = max(ABRmag(:,2));else    max_resp = Stimuli.scale;end[y,stack] = sort(ABRmag(:,param_of_interest));for file = 1:num_files    index = stack(file);    offset = max_resp * file - mean(mean(ploty)); %remove DC and shift by max response    xdat = plotx(:,index);    ydat = ploty(:,index) + offset;    eval(['set(FIG.abrs.abr' num2str(file) ',''xdata'',xdat,''ydata'',ydat,''Visible'',''on'');']);    xdat1 = [start_resp(index) end_resp(index) end_resp(index) start_resp(index) start_resp(index)];    xdat2 = [start_back(index) end_back(index) end_back(index) start_back(index) start_back(index)];    ymin = mean(ydat)-max_resp/2.2;    ymax = mean(ydat)+max_resp/2.2;    ydat = [ymin ymin ymax ymax ymin];    eval(['set(FIG.rwins.rwin' num2str(file) ',''xdata'',xdat1,''ydata'',ydat,''Visible'',''on'');']);    eval(['set(FIG.bwins.bwin' num2str(file) ',''xdata'',xdat2,''ydata'',ydat,''Visible'',''on'');']);end%set(FIG.ax2.axes,'XTick',[0:5:100]);set(FIG.ax2.axes,'YLim',[0 max_resp*(num_files+1)],'YTick',[max_resp:max_resp:max_resp*num_files],'YTickLabel',round(y));hold off;thresh_mag = mean(ABRmag(:,3)) + 2*std(ABRmag(:,3));ABRmag(1:num_files,4) = thresh_mag;if strncmp(lower(Stimuli.mode),'d',1)    DelayRefFile = [];    while isempty(DelayRefFile)        DelayRefFile = ['EPavg_p00' num2str(Stimuli.del_pic)];        while length(DelayRefFile) > 10,            DelayRefFile = strrep(DelayRefFile,'p0','p');        end                if ~exist([DelayRefFile],'file')            DelayRefFile = [];            prompt={'Enter the filenumber for no masker response (0=abort):'};            name='Missing reference file';            defaultanswer={'0'};            Stimuli.del_pic=inputdlg(prompt,name,numlines,defaultanswer);        end    end    command_line = sprintf('%s%s%c','[xdel]=',DelayRefFile,';');    eval(command_line);    if xdel.Stimuli.freq_hz ~= freq_check,        warndlg('Different signal frequency in reference file.');        return    end    time = find(xdel.AverageData(:,1)<=window_resp);    maxresp = max(xdel.AverageData(time,4));    minresp = min(xdel.AverageData(time,4));    refmag = maxresp - minresp;    ABRmag(1:num_files,7) = refmag;        recovery_mag = (refmag-ABRmag(:,2))/refmag;    ABRmag(1:num_files,8) = recovery_mag;    ABRmag = sortrows(ABRmag,param_of_interest);        %plot recovery function    set(FIG.ax1.axes,'ylim',[-0.2 1.2]);    set(FIG.ax1.line1,'xdata',ABRmag(:,param_of_interest),'ydata',ABRmag(:,8),'Visible','on');    text1 = sprintf('%s %4.1f %s\n','Reference mag is',refmag,'\muVolts');    else    ABRmag = sortrows(ABRmag,param_of_interest);    yes_thresh = 0;    for index = 1:num_files-1,        if (ABRmag(index,2) <= thresh_mag) & (ABRmag(index+1,2) >= thresh_mag), %find points that bracket 50% hit rate            pts = index;            yes_thresh = 1;        end    end        %calculate threshold    if yes_thresh,        hi_loc  = ABRmag(pts,  1);        lo_loc  = ABRmag(pts+1,1);        hi_resp = ABRmag(pts,  2);        lo_resp = ABRmag(pts+1,2);        slope  = (thresh_mag - lo_resp) / (hi_resp - lo_resp);        thresh_lev = slope * (hi_loc - lo_loc) + lo_loc;    else        thresh_lev = NaN;    end        %plot mag functions        set(FIG.ax1.axes,'ylim',[0 1.1*max_resp]);    set(FIG.ax1.line1,'xdata',ABRmag(:,param_of_interest),'ydata',ABRmag(:,2),'Visible','on');    set(FIG.ax1.line2,'xdata',ABRmag(:,param_of_interest),'ydata',ABRmag(:,3),'Visible','on');    set(FIG.ax1.line3,'xdata',ABRmag(:,param_of_interest),'ydata',ABRmag(:,4),'Visible','on');    text1 = sprintf('%s %4.1f %s\n','Threshold is',thresh_lev,'dB SPL');endif strncmp(Stimuli.mode,'m',1) %mode defines details of analysis    set(FIG.ax1.xlab,'String','Masker level (dB SPL)');    set(FIG.ax1.axes,'xscale','linear');    set(FIG.ax2.ylab,'String','Masker level (dB SPL)');    proc = sprintf('%s','(Masking procedure)');    text2 = sprintf('%4.1f %s %4.1f %s %s',freq_check/1000,'kHz signal with',masker_freq_check/1000,'kHz masker',proc);elseif strncmp(Stimuli.mode,'d',1)    set(FIG.ax1.xlab,'String','Masker delay (msec)');    set(FIG.ax1.axes,'xscale','log');    set(FIG.ax2.ylab,'String','Masker delay (msec)');    proc = sprintf('%s','(Delay procedure)');    text2 = sprintf('%4.1f %s %4.1f %s %s',freq_check/1000,'kHz signal with',masker_freq_check/1000,'kHz masker',proc);else    set(FIG.ax1.xlab,'String','Signal level (dB SPL)');    set(FIG.ax1.axes,'xscale','linear');    set(FIG.ax2.ylab,'String','Signal level (dB SPL)');    proc = sprintf('%s','(Threshold procedure)');    if freq_check,        text2 = sprintf('%4.1f %s %s',freq_check/1000,'kHz tone',proc);    else        text2 = sprintf('%s %s','Click',proc);    endendset(FIG.ax1.title,'string',[text1 text2]);drawnow;%write output to file for future analysisfilename = fullfile(data_dir,Stimuli.dir,analysis_fnam);fid = fopen(filename,'wt+');fprintf(fid,'%s\n\n','%CAP Analysis Results');fprintf(fid,'%s %s\n\n','function x =',strtok(analysis_fnam,'.m'));fprintf(fid,'%s%d %s\n','x = struct(''Stimuli'',{struct(''cal_pic'',',Stimuli.cal_pic,'...');fprintf(fid,'%s%d %s\n',',''del_pic'',',Stimuli.del_pic,'...');fprintf(fid,'%s%s %s\n',',''abr_pic'',''',Stimuli.abr_pic,'''...');if strncmp(lower(Stimuli.start_resp),'a',1)    fprintf(fid,'%s\n',',''start_resp'',''auto''...');else    fprintf(fid,'%s%5.2f %s\n',',''start_resp'',',Stimuli.start_resp,'...');endif strncmp(lower(Stimuli.window_resp),'a',1)    fprintf(fid,'%s\n',',''window_resp'',''auto''...');else    fprintf(fid,'%s%5.2f %s\n',',''window_resp'',',Stimuli.window_resp,'...');endif strncmp(lower(Stimuli.start_back),'a',1)    fprintf(fid,'%s\n',',''start_back'',''auto''...');else    fprintf(fid,'%s%5.2f %s\n',',''start_back'',',Stimuli.start_back,'...');endif strncmp(lower(Stimuli.window_back),'a',1)    fprintf(fid,'%s\n',',''window_back'',''auto''...');else    fprintf(fid,'%s%5.2f %s\n',',''window_back'',',Stimuli.window_back,'...');endif strncmp(lower(Stimuli.scale),'a',1)    fprintf(fid,'%s\n',',''scale'',''auto''...');else    fprintf(fid,'%s%5.2f %s\n',',''scale'',',Stimuli.scale,'...');endfprintf(fid,'%s%d %s\n',',''automatic'',',Stimuli.automatic,'...');fprintf(fid,'%s%s %s\n',',''mode'',''',Stimuli.mode,'''...');fprintf(fid,'%s%s %s\n',',''dir'',''',Stimuli.dir,'''...');fprintf(fid,'%s\n',')} ...');fprintf(fid,'%s\n%s',',''ABRmag'', {[...','%');[r,c] = size(ABRmag);labs = {'StmLev' 'CAPmag' 'BACmag' 'TwoSDs' 'MasLev' 'MasDel' 'REFmag' 'RECmag'};for index = 1:c    fprintf(fid,' %s',char(labs(index)));endfor index = 1:r    fprintf(fid,'\n%s','[');    fprintf(fid,'%7.2f',ABRmag(index,:));    fprintf(fid,'%s','];');endfprintf(fid,'\n%s\n',']});');fclose(fid);% end GetAllPics subfunction%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~function [picnums] = ParseInputPicString(picst)% Takes the input number string (eg, '5-7,9') and turns it into an array% of picture numbers, picnums=[5,6,7,9]c='0';i=0;j=1;numpics=1;dashflag=0;while i<length(picst)    while c~='-' & c~=',' & i+j~=length(picst)+1        b(j)=picst(i+j);        c=b(j);        j=j+1;    end    if c=='-' | c==','        b=b(1:end-1);    end    if dashflag==1        try            upto=str2num(b);        catch            error('Can''t parse picture numbers.');        end        numdash=upto-picnums(numpics-1);        for k=1:numdash            picnums(k+numpics-1)=picnums(numpics-1)+k;        end        numpics=length(picnums);    else  % if dashflag==1        try            picnums(numpics)=str2num(b);        catch            error('Can''t parse picture numbers!\n');        end    end    clear b;    i=i+j-1;    j=1;    if c=='-'        dashflag=1;    else        dashflag=0;    end    c='0';    numpics=numpics+1;end  % while i<length(picst)