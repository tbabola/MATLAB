function view_params(command_str,txt_num)
global Stimuli View root_dir

if nargin < 1	
    
    curr_dir = cd(fullfile(root_dir,'cap','private'));
    %CREATING STRUCTURES HERE
    push = cell2struct(cell(1,3),{'default','update','edit'},2);
    View = struct('handle',[],'push',push,'parm_txt',[]);
    
    %MAKING FIGURE AND INTERFACE
    View.handle = figure('NumberTitle','off','Name','Parameters','Units','normalized','position',[.25 .2 .5 .6]);
    axes('Position',[0 0 1 1]);
    axis('off');
    
    text(.445,.75,'Playback','fontsize',12,'fontweight','bold','color','k','horizontalalignment','right','VerticalAlignment','middle','EraseMode','none');
    text(.445,.70,'Freq (Hz):','fontsize',10,'color','k','horizontalalignment','right','VerticalAlignment','middle','EraseMode','none');
    text(.445,.67,'Duration (msec):','fontsize',10,'color','k','horizontalalignment','right','VerticalAlignment','middle','EraseMode','none');
    text(.445,.64,'Rise/Fall (msec):','fontsize',10,'color','k','horizontalalignment','right','VerticalAlignment','middle','EraseMode','none');
    text(.6,.64,num2str(Stimuli.rise_fall), 'fontsize',10,'color','k','horizontalalignment','right','VerticalAlignment','middle','EraseMode','none');
    text(.445,.61,'Pulses/sec:','fontsize',10,'color','k','horizontalalignment','right','VerticalAlignment','middle','EraseMode','none');
    text(.445,.58,'Attenuation (dB):','fontsize',10,'color','k','horizontalalignment','right','VerticalAlignment','middle','EraseMode','none');
    text(.445,.48,'Record','fontsize',12,'fontweight','bold','color','k','horizontalalignment','right','VerticalAlignment','middle','EraseMode','none');
    text(.445,.43,'Duration (msec):','fontsize',10,'color','k','horizontalalignment','right','VerticalAlignment','middle','EraseMode','none');
    text(.445,.40,'Samp Rate (kHz):','fontsize',10,'color','k','horizontalalignment','right','VerticalAlignment','middle','EraseMode','none');
    text(.6,.40,num2str(Stimuli.SampRate),'fontsize',10,'color','k','horizontalalignment','right','VerticalAlignment','middle','EraseMode','none');
    text(.445,.37,'Num Averages:','fontsize',10,'color','k','horizontalalignment','right','VerticalAlignment','middle','EraseMode','none');
    text(.445,.34,'Reject Limit:','fontsize',10,'color','k','horizontalalignment','right','VerticalAlignment','middle','EraseMode','none');
    text(.445,.31,'Amplifier Gain:','fontsize',10,'color','k','horizontalalignment','right','VerticalAlignment','middle','EraseMode','none');
    text(.445,.28,'Automatic Sampling:','fontsize',10,'color','k','horizontalalignment','right','VerticalAlignment','middle','EraseMode','none');
    text(.445,.18,'Masker','fontsize',12,'fontweight','bold','color','k','horizontalalignment','right','VerticalAlignment','middle','EraseMode','none');
    text(.445,.13,'Freq (Hz):','fontsize',10,'color','k','horizontalalignment','right','VerticalAlignment','middle','EraseMode','none');
    text(.445,.10,'Duration (msec):','fontsize',10,'color','k','horizontalalignment','right','VerticalAlignment','middle','EraseMode','none');
    text(.445,.07,'Delay (ms):','fontsize',10,'color','k','horizontalalignment','right','VerticalAlignment','middle','EraseMode','none');
    text(.445,.04,'Attenuation (dB):','fontsize',10,'color','k','horizontalalignment','right','VerticalAlignment','middle','EraseMode','none');
   
    if Stimuli.freq_hz == 0,
        stim_txt = 'click';
    else
        stim_txt = num2str(Stimuli.freq_hz);
    end
    View.parm_txt(1)  = text(.6,.70,stim_txt, 'fontsize',10,'color',[.1 .1 .6],'horizontalalignment','right','VerticalAlignment','middle','EraseMode','normal','buttondownfcn','view_params(''Stimuli'',1);');
    View.parm_txt(2)  = text(.6,.67,num2str(Stimuli.play_duration), 'fontsize',10,'color',[.1 .1 .6],'horizontalalignment','right','VerticalAlignment','middle','EraseMode','normal','buttondownfcn','view_params(''Stimuli'',2);');
    View.parm_txt(3)  = text(.6,.43,num2str(Stimuli.record_duration),'fontsize',10,'color',[.1 .1 .6],'horizontalalignment','right','VerticalAlignment','middle','EraseMode','normal','buttondownfcn','view_params(''Stimuli'',3);');
    View.parm_txt(4)  = text(.6,.61,num2str(Stimuli.pulses_per_sec), 'fontsize',10,'color',[.1 .1 .6],'horizontalalignment','right','VerticalAlignment','middle','EraseMode','normal','buttondownfcn','view_params(''Stimuli'',4);');
    View.parm_txt(5)  = text(.6,.37,num2str(Stimuli.naves),'fontsize',10,'color',[.1 .1 .6],'horizontalalignment','right','VerticalAlignment','middle','EraseMode','normal','buttondownfcn','view_params(''Stimuli'',5);');
    View.parm_txt(6)  = text(.6,.58,num2str(Stimuli.db_atten), 'fontsize',10,'color',[.1 .1 .6],'horizontalalignment','right','VerticalAlignment','middle','EraseMode','normal','buttondownfcn','view_params(''Stimuli'',6);');
    View.parm_txt(7)  = text(.6,.31,num2str(Stimuli.amp_gain), 'fontsize',10,'color',[.1 .1 .6],'horizontalalignment','right','VerticalAlignment','middle','EraseMode','normal','buttondownfcn','view_params(''Stimuli'',7);');
    View.parm_txt(8)  = text(.6,.34,num2str(Stimuli.reject), 'fontsize',10,'color',[.1 .1 .6],'horizontalalignment','right','VerticalAlignment','middle','EraseMode','normal','buttondownfcn','view_params(''Stimuli'',8);');
if isnan(Stimuli.masker_freq_hz)
    View.parm_txt(9)  = text(.6,.13,num2str('not used'), 'fontsize',10,'color',[.8 .8 .8],'horizontalalignment','right','VerticalAlignment','middle','EraseMode','normal','buttondownfcn','view_params(''Stimuli'',9);');
    View.parm_txt(13)  = text(.6,.10,num2str('not used'), 'fontsize',10,'color',[.8 .8 .8],'horizontalalignment','right','VerticalAlignment','middle','EraseMode','normal','buttondownfcn','view_params(''Stimuli'',13);');
    View.parm_txt(10)  = text(.6,.07,num2str('not used'), 'fontsize',10,'color',[.8 .8 .8],'horizontalalignment','right','VerticalAlignment','middle','EraseMode','normal','buttondownfcn','view_params(''Stimuli'',10);');
    View.parm_txt(11)  = text(.6,.04,num2str('not used'), 'fontsize',10,'color',[.8 .8 .8],'horizontalalignment','right','VerticalAlignment','middle','EraseMode','normal','buttondownfcn','view_params(''Stimuli'',11);');
else
    View.parm_txt(9)  = text(.6,.13,num2str(Stimuli.masker_freq_hz), 'fontsize',10,'color',[.1 .1 .6],'horizontalalignment','right','VerticalAlignment','middle','EraseMode','normal','buttondownfcn','view_params(''Stimuli'',9);');
    View.parm_txt(13)  = text(.6,.10,num2str(Stimuli.masker_duration), 'fontsize',10,'color',[.1 .1 .6],'horizontalalignment','right','VerticalAlignment','middle','EraseMode','normal','buttondownfcn','view_params(''Stimuli'',13);');
    View.parm_txt(10)  = text(.6,.07,num2str(Stimuli.masker_delay_ms), 'fontsize',10,'color',[.1 .1 .6],'horizontalalignment','right','VerticalAlignment','middle','EraseMode','normal','buttondownfcn','view_params(''Stimuli'',10);');
    View.parm_txt(11)  = text(.6,.04,num2str(Stimuli.masker_db_atten), 'fontsize',10,'color',[.1 .1 .6],'horizontalalignment','right','VerticalAlignment','middle','EraseMode','normal','buttondownfcn','view_params(''Stimuli'',11);');
end
View.parm_txt(12)  = text(.6,.28,Stimuli.automatic, 'fontsize',10,'color',[.1 .1 .6],'horizontalalignment','right','VerticalAlignment','middle','EraseMode','normal','buttondownfcn','view_params(''Stimuli'',12);');
    
    
    View.push.default = uicontrol(View.handle,'callback','view_params(''defs'',0);','style','pushbutton','Units','normalized','position',[.1 .85 .3 .075],'string','Defaults');
    View.push.update  = uicontrol(View.handle,'callback','view_params(''update'',0);','style','pushbutton','Units','normalized','position',[.6 .85 .3 .075],'Enable','off','ForegroundColor','r','string','Update');
    View.push.edit    = uicontrol(View.handle,'style','edit','Units','normalized','position',[.7 .375 .2 .075],'string',[],'FontSize',12);															
    
    set(View.handle,'Userdata',struct('handles',View));    
    
elseif strcmp(command_str,'Stimuli')
    if length(get(View.push.edit,'string'))
        set(View.push.update,'Enable','on');
        set(View.parm_txt(txt_num),'String',get(View.push.edit,'string'));
        switch txt_num
        case 1,
             new_value = get(View.push.edit,'string');
             if strncmp(new_value,'c',1),
                Stimuli.freq_hz = 0;
                set(View.parm_txt(1),'String','click');
            else
                Stimuli.freq_hz = str2num(new_value);
                set(View.parm_txt(1),'String',new_value);
            end
        case 2,
            Stimuli.play_duration = str2num(get(View.push.edit,'string'));
        case 3,
            Stimuli.record_duration = str2num(get(View.push.edit,'string'));
        case 4,
            prate = str2num(get(View.push.edit,'string'));
            if rem(prate,2),
                errordlg('Pulses/sec must be a multiple of 2.','Parameter Error');
                set(View.parm_txt(4),'String',num2str(Stimuli.pulses_per_sec));
            else
                Stimuli.pulses_per_sec = prate;
            end
        case 5,
            Stimuli.naves = str2num(get(View.push.edit,'string'));
        case 6,
            Stimuli.db_atten = str2num(get(View.push.edit,'string'));
        case 7,
            Stimuli.amp_gain = str2num(get(View.push.edit,'string'));
        case 8,
            Stimuli.reject = str2num(get(View.push.edit,'string'));
        case 9,
            Stimuli.masker_freq_hz = str2num(get(View.push.edit,'string'));
            if isnan(Stimuli.masker_freq_hz)
                set(View.parm_txt(9),'String','not used','Color',[.8 .8 .8]);
                set(View.parm_txt(10),'String','not used','Color',[.8 .8 .8]);
                set(View.parm_txt(11),'String','not used','Color',[.8 .8 .8]);
                set(View.parm_txt(13),'String','not used','Color',[.8 .8 .8]);
            else
                set(View.parm_txt(9),'String',[Stimuli.masker_freq_hz],'Color',[.1 .1 .6]);
                set(View.parm_txt(13),'String',[Stimuli.masker_duration],'Color',[.1 .1 .6]);
                set(View.parm_txt(10),'String',[Stimuli.masker_delay_ms],'Color',[.1 .1 .6]);
                set(View.parm_txt(11),'String',[Stimuli.masker_db_atten],'Color',[.1 .1 .6]);
            end
        case 10,
            Stimuli.masker_delay_ms = str2num(get(View.push.edit,'string'));
        case 11,
            Stimuli.masker_db_atten = str2num(get(View.push.edit,'string'));
        case 12,
             new_value = get(View.push.edit,'string');
             if strncmp(new_value,'y',1),
                Stimuli.automatic = 'yes';
                set(View.parm_txt(12),'String','yes');
            else
                Stimuli.automatic = 'no';
                set(View.parm_txt(12),'String','no');
            end
        case 13,
            Stimuli.masker_duration = str2num(get(View.push.edit,'string'));
        end
        set(View.push.edit,'String',[]);
    else
        set(View.push.edit,'String','ERROR');
    end
    
elseif strcmp(command_str,'defs')
    set(View.push.update,'Enable','on');
    Stimuli = struct('freq_hz', 0, ...
        'play_duration',  5, ...
        'record_duration',30, ...
        'SampRate',      100, ...
        'pulses_per_sec', 10, ...
        'rise_fall',     0.5, ...
        'naves',         500, ...
        'db_atten',       20, ...
        'reject',          3, ...
        'masker_freq_hz',  0, ...
        'masker_duration',100, ...
        'masker_delay_ms', 0, ...
        'masker_db_atten',120, ...
        'amp_gain',   300000, ...
        'automatic',   'no');
    
    set(View.parm_txt(1),'String',num2str(Stimuli.freq_hz));
    set(View.parm_txt(2),'String',num2str(Stimuli.play_duration));
    set(View.parm_txt(3),'String',num2str(Stimuli.record_duration));
    set(View.parm_txt(4),'String',num2str(Stimuli.pulses_per_sec));
    set(View.parm_txt(5),'String',num2str(Stimuli.naves));
    set(View.parm_txt(6),'String',num2str(Stimuli.db_atten));
    set(View.parm_txt(7),'String',num2str(Stimuli.amp_gain));
    set(View.parm_txt(8),'String',num2str(Stimuli.reject));
    set(View.parm_txt(9),'String',num2str(Stimuli.masker_freq_hz));
    set(View.parm_txt(13),'String',num2str(Stimuli.masker_duration));
    set(View.parm_txt(10),'String',num2str(Stimuli.masker_delay_ms));
    set(View.parm_txt(11),'String',num2str(Stimuli.masker_db_atten));
    set(View.parm_txt(12),'String',num2str(Stimuli.automatic));
    
elseif strcmp(command_str,'update')	
    update_params;
    closereq;
end
