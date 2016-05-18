function cap_analysis(command_str,parm_num)

%This function computes an ABR threshold based on series of AVERAGER files.

global FIG Stimuli root_dir data_dir analysis

if nargin < 1

    %CREATING STRUCTURES HERE
    PROG = struct('name','CAP.m','date',date,'version','rp2 v2.0');

    push = cell2struct(cell(1,5),{'process','print','close','edit','auto'},2);
    ax1  = cell2struct(cell(1,7),{'axes','line1','line2','line3','xlab','ylab','title'},2);
    ax2  = cell2struct(cell(1,3),{'axes','xlab','ylab'},2);
    abrs  = cell2struct(cell(1,20),{'abr1','abr2','abr3','abr4','abr5','abr6','abr7','abr8','abr9','abr10', ...
        'abr11','abr12','abr13','abr14','abr15','abr16','abr17','abr18','abr19','abr20'},2);
    rwins  = cell2struct(cell(1,20),{'rwin1','rwin2','rwin3','rwin4','rwin5','rwin6','rwin7','rwin8','rwin9','rwin10', ...
        'rwin11','rwin12','rwin13','rwin14','rwin15','rwin16','rwin17','rwin18','rwin19','rwin20'},2);
    bwins  = cell2struct(cell(1,20),{'bwin1','bwin2','bwin3','bwin4','bwin5','bwin6','bwin7','bwin8','bwin9','bwin10', ...
        'bwin11','bwin12','bwin13','bwin14','bwin15','bwin16','bwin17','bwin18','bwin19','bwin20'},2);
    eflag = cell2struct(cell(1,6),{'freq_hz','db_atten','masker_present','masker_freq_hz','masker_db_atten','masker_delay_ms'},2);
    FIG = struct('handle',[],'push',push,'ax1',ax1,'ax2',ax2,'abrs',abrs,'rwins',rwins,'bwins',bwins,'eflag',eflag,'parm_text',[],'dir_text',[]);

    try
        get_analysis_ins; %script creates struct Stimuli
    catch
        instruct_error;
        get_analysis_ins; %script creates struct Stimuli
    end

    if ~isfield(Stimuli,'mode') %check last field to determine complete Stimuli struct
        instruct_error;
        get_analysis_ins; %script creates struct Stimuli
    end
        
    FIG.handle = figure('NumberTitle','off','Name','CAP Analysis','Units','normalized','Visible','off','position',[0 0 1 .95],'CloseRequestFcn','cap_analysis(''close'');');
    colordef none;
    whitebg('w');

    FIG.push.process = uicontrol(FIG.handle,'callback','cap_analysis(''process'');','style','pushbutton','Units','normalized','position',[.05 .85 .1 .05],'string','Process');
    FIG.push.print   = uicontrol(FIG.handle,'callback','cap_analysis(''print'');','style','pushbutton','Units','normalized','position',[.2125 .85 .1 .05],'string','Print');
    FIG.push.file    = uicontrol(FIG.handle,'callback','cap_analysis(''file'');','style','pushbutton','Units','normalized','position',[.375 .85 .1 .05],'string','Save as File');
    FIG.push.edit    = uicontrol(FIG.handle,'style','edit','Units','normalized','position',[.3 .06 .1 .04],'horizontalalignment','left','string',[],'FontSize',12);
    FIG.push.auto    = uicontrol(FIG.handle,'callback','cap_analysis(''automatic'');','style','checkbox','Units','normalized','position',[.15 .06 .1 .04],'horizontalalignment','left','string','Automatic','FontSize',12,'value',Stimuli.automatic);

    FIG.ax1.axes = axes('Position',[.1 .45 .35 .3]);
    FIG.ax1.line1 = plot(0,0,'-','LineWidth',1,'Visible','off');
    set(FIG.ax1.line1,'Color',[0 0 0]);
    hold on;
    FIG.ax1.line2 = plot(0,0,'o','Visible','off');
    set(FIG.ax1.line2,'Color',[.2 .2 .2]);
    FIG.ax1.line3 = plot(0,0,'--','LineWidth',1,'Visible','off');
    set(FIG.ax1.line3,'Color',[.2 .2 .2]);
    FIG.ax1.xlab = xlabel('Signal level (dB SPL)','FontSize',14);
    FIG.ax1.ylab = ylabel('CAP (\muVolts)','FontSize',14,'Interpreter','tex');
    FIG.ax1.title = title('CAP Analysis','FontSize',14);

    axes('Position',[.1 .1 .35 .4]);
    axis('off');
    %    text(.2,.65,'Directory:','fontsize',10,'color','k','horizontalalignment','left','VerticalAlignment','middle');
    text(.2,.57,'Calibration File:','fontsize',10,'color','k','horizontalalignment','left','VerticalAlignment','middle');
    text(.2,.52,'Delay Reference File:','fontsize',10,'color','k','horizontalalignment','left','VerticalAlignment','middle');
    text(.2,.47,'CAP Files:','fontsize',10,'color','k','horizontalalignment','left','VerticalAlignment','middle');
    text(.2,.40,'Signal Min:','fontsize',10,'color','k','horizontalalignment','left','VerticalAlignment','middle');
    text(.2,.36,'Signal Window:','fontsize',10,'color','k','horizontalalignment','left','VerticalAlignment','middle');
    text(.2,.29,'Background Min:','fontsize',10,'color','k','horizontalalignment','left','VerticalAlignment','middle');
    text(.2,.25,'Background Window:','fontsize',10,'color','k','horizontalalignment','left','VerticalAlignment','middle');
    text(.2,.18,'YScale:','fontsize',10,'color','k','horizontalalignment','left','VerticalAlignment','middle');
    text(.2,.11,'Mode:','fontsize',10,'color','k','horizontalalignment','left','VerticalAlignment','middle');

    FIG.parm_txt(1)  = text(.8,.57,num2str(Stimuli.cal_pic),'fontsize',10,'color',[.2 .2 .2],'horizontalalignment','right','buttondownfcn','cap_analysis(''stimulus'',1);');
    FIG.parm_txt(10) = text(.8,.52,num2str(Stimuli.del_pic),'fontsize',10,'color',[.2 .2 .2],'horizontalalignment','right','buttondownfcn','cap_analysis(''stimulus'',10);');
    FIG.parm_txt(2)  = text(.8,.47,num2str(Stimuli.abr_pic),'fontsize',10,'color',[.2 .2 .2],'horizontalalignment','right','buttondownfcn','cap_analysis(''stimulus'',2);');
    if strncmp(Stimuli.start_resp,'a',1)
        Stimuli.start_resp = 'auto';
        txt = Stimuli.start_resp;
    else
        txt = num2str(Stimuli.start_resp);
    end
    FIG.parm_txt(3)  = text(.8,.40,txt,'fontsize',10,'color',[.2 .2 .2],'horizontalalignment','right','buttondownfcn','cap_analysis(''stimulus'',3);');
    if strncmp(Stimuli.window_resp,'a',1)
        Stimuli.window_resp = 'auto';
        txt = Stimuli.window_resp;
    else
        txt = num2str(Stimuli.window_resp);
    end
    FIG.parm_txt(4)  = text(.8,.36,txt,'fontsize',10,'color',[.2 .2 .2],'horizontalalignment','right','buttondownfcn','cap_analysis(''stimulus'',4);');
    if strncmp(Stimuli.start_back,'a',1)
        Stimuli.start_back = 'auto';
        txt = Stimuli.start_back;
    else
        txt = num2str(Stimuli.start_back);
    end
    FIG.parm_txt(5)  = text(.8,.29,txt,'fontsize',10,'color',[.2 .2 .2],'horizontalalignment','right','buttondownfcn','cap_analysis(''stimulus'',5);');
    if strncmp(Stimuli.window_back,'a',1)
        Stimuli.window_back = 'auto';
        txt = Stimuli.window_back;
    else
        txt = num2str(Stimuli.window_back);
    end
    FIG.parm_txt(6)  = text(.8,.25,txt,'fontsize',10,'color',[.2 .2 .2],'horizontalalignment','right','buttondownfcn','cap_analysis(''stimulus'',6);');
    if strncmp(Stimuli.scale,'a',1)
        Stimuli.scale = 'auto';
        txt = Stimuli.scale;
    else
        txt = num2str(Stimuli.scale);
    end
    FIG.parm_txt(7)  = text(.8,.18,txt,     'fontsize',10,'color',[.2 .2 .2],'horizontalalignment','right','buttondownfcn','cap_analysis(''stimulus'',7);');
    FIG.parm_txt(9)  = text(.8,.1,Stimuli.mode,               'fontsize',10,'color',[.2 .2 .2],'horizontalalignment','right','buttondownfcn','cap_analysis(''stimulus'',9);');

    FIG.dir_txt = text(.8,.65,Stimuli.dir,'fontsize',10,'color',[.2 .2 .2],'horizontalalignment','right','buttondownfcn','cap_analysis(''directory'');','Interpreter','none');

    FIG.ax2.axes = axes('Position',[.55 .2 .35 .7]);
    FIG.rwins.rwin1 = plot(0,0,'-','LineWidth',1,'Visible','off');
    set(FIG.rwins.rwin1,'Color',[.2 .2 .2]);
    hold on;
    FIG.bwins.bwin1 = plot(0,0,'-','LineWidth',1,'Visible','off');
    set(FIG.bwins.bwin1,'Color',[.2 .2 .2]);
    FIG.abrs.abr1 = plot(0,0,'-','LineWidth',1,'Visible','off');
    set(FIG.abrs.abr1,'Color',[0 0 0]);
    for i = 2:20
        eval(['FIG.rwins.rwin' num2str(i) ' = plot(0,0,''-'',''LineWidth'',1,''Visible'',''off'');']);
        eval(['set(FIG.rwins.rwin' num2str(i) ',''Color'',[.2 .2 .2]);']);
        eval(['FIG.bwins.bwin' num2str(i) ' = plot(0,0,''-'',''LineWidth'',1,''Visible'',''off'');']);
        eval(['set(FIG.bwins.bwin' num2str(i) ',''Color'',[.2 .2 .2]);']);
        eval(['FIG.abrs.abr' num2str(i) ' = plot(0,0,''-'',''LineWidth'',1,''Visible'',''off'');']);
        eval(['set(FIG.abrs.abr' num2str(i) ',''Color'',[0 0 0]);']);
    end
    FIG.ax2.xlab = xlabel('Time (msec)','FontSize',14);
    FIG.ax2.ylab = ylabel('Signal level (dB SPL)','FontSize',14,'Interpreter','tex');

    set(FIG.handle,'Userdata',struct('handles',FIG));
    set(FIG.handle,'Visible','on');
    drawnow;

elseif strcmp(command_str,'automatic')
    if ~get(FIG.push.auto,'value')
        %leave auto mode
        new_value = 1;
        Stimuli.start_resp = new_value;  set(FIG.parm_txt(3),'string',num2str(new_value));
        new_value = 5;
        Stimuli.window_resp = new_value; set(FIG.parm_txt(4),'string',num2str(new_value));
        new_value = 20;
        Stimuli.start_back = new_value;  set(FIG.parm_txt(5),'string',num2str(new_value));
        new_value = 5;
        Stimuli.window_back = new_value; set(FIG.parm_txt(6),'string',num2str(new_value));
        new_value = 5;
        Stimuli.scale = new_value;       set(FIG.parm_txt(7),'string',num2str(new_value));
        Stimuli.automatic = 0;
    else
        %enter auto mode
        new_value = 'auto';
        Stimuli.start_resp = new_value;  set(FIG.parm_txt(3),'string',new_value);
        Stimuli.window_resp = new_value; set(FIG.parm_txt(4),'string',new_value);
        Stimuli.start_back = new_value;  set(FIG.parm_txt(5),'string',new_value);
        Stimuli.window_back = new_value; set(FIG.parm_txt(6),'string',new_value);
        Stimuli.scale = new_value;       set(FIG.parm_txt(7),'string',new_value);
        Stimuli.automatic = 1;
    end

elseif strcmp(command_str,'stimulus')
    if parm_num == 1
        warndlg('Do not change calibration picture!','Analysis Error');
        set(FIG.push.edit,'string',[]);
    elseif length(get(FIG.push.edit,'string'))
        new_value = get(FIG.push.edit,'string');
        set(FIG.push.edit,'string',[]);
        switch parm_num
            case 2,
                Stimuli.abr_pic = new_value;
            case 3,
                if strncmp(lower(new_value),'a',1),
                    new_value = 'auto';
                    Stimuli.start_resp = 'auto';
                else
                    Stimuli.start_resp = str2num(new_value);
                    Stimuli.automatic = 0;
                end
            case 4,
                if strncmp(lower(new_value),'a',1),
                    new_value = 'auto';
                    Stimuli.window_resp = 'auto';
                else
                    Stimuli.window_resp = str2num(new_value);
                    Stimuli.automatic = 0;
                end
            case 5,
                if strncmp(lower(new_value),'a',1),
                    new_value = 'auto';
                    Stimuli.start_back = 'auto';
                else
                    Stimuli.start_back = str2num(new_value);
                    Stimuli.automatic = 0;
                end
            case 6,
                if strncmp(lower(new_value),'a',1),
                    new_value = 'auto';
                    Stimuli.window_back = 'auto';
                else
                    Stimuli.window_back = str2num(new_value);
                    Stimuli.automatic = 0;
                end
            case 7,
                if strncmp(lower(new_value),'a',1),
                    new_value = 'auto';
                    Stimuli.scale = 'auto';
                else
                    Stimuli.scale = str2num(new_value);
                    Stimuli.automatic = 0;
                end
            case 8,
                %not used
            case 9,
                %disabled, let program find proper analysis
                new_value = Stimuli.mode;
                %------------------------------------------
                if strncmp(lower(new_value),'t',1),
                    new_value = 'threshold';
                    Stimuli.mode = 'threshold';
                elseif strncmp(lower(new_value),'d',1),
                    new_value = 'delay';
                    Stimuli.mode = 'delay';
                elseif strncmp(lower(new_value),'m',1),
                    new_value = 'masker';
                    Stimuli.mode = 'masker';
                end
            case 10,
                Stimuli.del_pic = str2num(new_value);
        end
        set(FIG.parm_txt(parm_num),'string',new_value);
        if ~Stimuli.automatic
            set(FIG.push.auto,'value',0);
        end
    else
        set(FIG.push.edit,'string','ERROR');
    end

elseif strcmp(command_str,'directory')
    Stimuli.dir = get_directory;
    set(FIG.dir_txt,'string',Stimuli.dir);

elseif strcmp(command_str,'process')
        [error] = thresh_calc;

elseif strcmp(command_str,'print')
    set(gcf,'PaperOrientation','Landscape','PaperPosition',[0 0 11 8.5]);
    if ispc
        print('-dwinc','-r200','-noui');
    else
        print('-dpsc','-r200','-noui');
    end

elseif strcmp(command_str,'file')
    pic_dir = fullfile(data_dir,'pictures');
    if ~exist(pic_dir)
        mkdir(data_dir,'pictures');
    end

    filename = inputdlg('Name the file:','File Manager',1);
    if isempty(filename)
        warndlg('File not saved.');
    else
        set(gcf,'PaperOrientation','Portrait','PaperPosition',[0 0 11 8.5]);
        print('-depsc','-noui',fullfile(pic_dir,char(filename))); %crashes this computer!!!!
        uiwait(msgbox('File has been saved.','File Manager','modal'));
    end

elseif strcmp(command_str,'close')
    update_params;
    closereq;
end
