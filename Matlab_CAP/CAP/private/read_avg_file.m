function [error] = read_avg_file%Program to read previous calibration files within CALIBRATIONglobal FIG NelData data_dircur_dir = cd(fullfile(data_dir,NelData.General.CurDataDir));filterspec = '*.m';[data_file cur_dir] = uigetfile(filterspec,'Calibration Files');if data_file    cd(cur_dir);    command_line = sprintf('%s%s%c','[x]=',strrep(data_file,'.m',''),';');    eval(command_line);    filename = sprintf('%s%3d%c','ARCHIVE(',x.General.picture_number,')');    set(FIG.ax2.ProgData,'Color',[.8 .8 .8],'String',{x.General.program_name x.General.date filename});    if findstr(upper(x.General.program_name),'CAP'),        set(FIG.ax2.ProgMess,'String','Inspecting data file...');                if x.Stimuli.freq_hz == 0,            stim_txt = 'click';        else            stim_txt = num2str(x.Stimuli.freq_hz);        end                set(FIG.ax3.ParamData1,'Color',[.8 .8 .8],'String',{stim_txt});        set(FIG.ax3.ParamData2,'Color',[.8 .8 .8],'String',{x.Stimuli.db_atten});        set(FIG.ax3.ParamData3,'Color',[.8 .8 .8],'String',{x.Stimuli.masker_freq_hz});        set(FIG.ax3.ParamData4,'Color',[.8 .8 .8],'String',{x.Stimuli.masker_delay_ms});        set(FIG.ax3.ParamData5,'Color',[.8 .8 .8],'String',{x.Stimuli.masker_db_atten});        set(FIG.ax1.axes,'XLim',[0 x.Stimuli.record_duration]);        ylimup = max(0.01,ceil(max(x.AverageData(:,4))*12)/10);        ylimdown = min(0.01,floor(min(x.AverageData(:,4))*12)/10);        set(FIG.ax1.axes,'YLim',[ylimdown ylimup]);        set(FIG.ax1.axes,'YTick',[ylimdown ylimup]);        set(FIG.ax1.line1,'XData',x.AverageData(:,1),'YData',x.AverageData(:,4));        drawnow;    else        set(FIG.ax1.line1,'XData',0,'YData',0);        set(FIG.ax2.ProgMess,'String','Not an AVERAGER file!');    endelse    warndlg('No file was selected!','Analysis Manager',1);end