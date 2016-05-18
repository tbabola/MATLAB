function cap(command_str)

%This is the main program for collecting averaged EP data.
% LQ 01/05/05, the system use RX6 instead of RP2, change all RP2 to RX6.
% add lines for PA5_3 and PA5_4 too
global PROG FIG Stimuli NelData AVdata root_dir data_dir COMM

if nargin < 1
    
    %CREATING STRUCTURES HERE
    %PROG = struct('name','CAP.m','date',date,'version','rp2 v2.0');
    PROG = struct('name','CAP.m','date',date,'version','rx6 v1.0');
    
    push = cell2struct(cell(1,6),{'stop','print','aver','params','recall','edit'},2);
    ax1  = cell2struct(cell(1,2),{'axes','line1'},2);
    ax2  = cell2struct(cell(1,4),{'axes','ProgHead','ProgData','ProgMess'},2);
    ax3  = cell2struct(cell(1,10),{'axes','ParamHead1','ParamHead2','ParamHead3','ParamHead4','ParamData1','ParamData2','ParamData3','ParamData4','ParamData5'},2);
    FIG = struct('handle',[],'push',push,'ax1',ax1,'ax2',ax2,'ax3',ax3);
    
    try
        get_averaging_ins; %script creates struct Stimuli
    catch
        instruct_error;
        get_averaging_ins;
    end
    if Stimuli.freq_hz == 0,
        stim_txt = 'click';
    else
        stim_txt = num2str(Stimuli.freq_hz);
    end

    d = dir(fullfile(data_dir,NelData.General.CurDataDir));    
    
    fnum = length(d(find([d.isdir]==0)));
    anfiles = length(find(strncmp({d.name},'CAP',3)));
    NelData.General.fnum = fnum - anfiles;
    fcheck = {''}; title = 'Check Picture';
    while ((isempty(fcheck) | isempty(fcheck{1})))
        fcheck = lower(inputdlg({'Last saved picture was:'},title,1,{num2str(NelData.General.fnum)},'on'));
        title = 'Please enter NON-EMPTY pic number';
    end                
    NelData.General.fnum = str2num(fcheck{1});
    UpdateExplist(NelData.General.fnum);

    
    
    
%     eval('explist');   %GQ 7-16-08 commented out because it causes
%     loading previous saved data
    
    FIG.handle = figure('NumberTitle','off','Name','Averager Interface','Units','normalized','Visible','off','position',[0 0 1 .95]);
    colordef none;
    whitebg('w');
    avplot;
    
    if ispc
        LoadTDT; %skip if running on a mac...
    end
    
    set(FIG.handle,'Visible','on');
    drawnow;
    
elseif strcmp(command_str,'params')
    view_params;
    
elseif strcmp(command_str,'return')
    set(FIG.ax1.axes,'XLim',[0 Stimuli.record_duration],'YLim',[-3.5 3.5]);
    set(FIG.ax1.axes,'YTick',[-3.5 0 3.5]);
    set(FIG.ax1.line1,'XData',0,'YData',0);
    fnum = NelData.General.fnum +1;
    set(FIG.ax2.ProgData,'string', {PROG.name PROG.date fnum},'color',[.1 .1 .6]);
    
    if ~Stimuli.freq_hz
        stim_txt = 'click';
    else
        stim_txt = num2str(Stimuli.freq_hz);
    end
    
    set(FIG.ax3.ParamData1,'string',{stim_txt},'color',[.1 .1 .6]);
    set(FIG.ax3.ParamData2,'string',{Stimuli.db_atten},'color',[.1 .1 .6]);
    if isnan(Stimuli.masker_freq_hz)
        set(FIG.ax3.ParamData3,'string',{'not used'},'color',[.8 .8 .8]);
        set(FIG.ax3.ParamData4,'string',{'not used'},'color',[.8 .8 .8]);
        set(FIG.ax3.ParamData5,'string',{'not used'},'color',[.8 .8 .8]);
    else
        set(FIG.ax3.ParamData3,'string',{Stimuli.masker_freq_hz},'color',[.1 .1 .6]);
        set(FIG.ax3.ParamData4,'string',{Stimuli.masker_delay_ms},'color',[.1 .1 .6]);
        set(FIG.ax3.ParamData5,'string',{Stimuli.masker_db_atten},'color',[.1 .1 .6]);
    end
    set(FIG.push.stop,'Enable','off');
    set(FIG.push.recall,'Enable','on');
    set(FIG.push.aver,'Enable','on');
    set(FIG.push.print,'Enable','on');
    set(FIG.push.params,'Enable','on');
    
elseif strcmp(command_str,'average')
    % Print Title and description.
    set(FIG.ax1.axes,'XLim',[0 Stimuli.record_duration],'YLim',[-3.5 3.5]);
    set(FIG.ax1.axes,'YTick',[-3.5 0 3.5]);
    fnum = NelData.General.fnum +1;
    set(FIG.ax2.ProgData,'string', {PROG.name PROG.date fnum},'color',[.1 .1 .6]);
    set(FIG.ax2.ProgMess,'String','Starting averaging routine...');
    
    
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % added by bjm 1/05 to allow autosampling 36 stims per freq
    
    if strcmp(Stimuli.automatic,'yes'),
        load auto;
        NewDirName = fullfile(data_dir,NelData.General.CurDataDir);
        d = dir(NewDirName);
        filenum = length(d(find([d.isdir]==0)));
        filesperfreq = length(auto.Stimuli.db_atten)*length(auto.Stimuli.noisenotch);
        filesthisfreq = mod(filenum-1,filesperfreq) +1;
        
        freqnum = ceil(filenum/filesperfreq);
        sattnum = mod(filenum-1,length(auto.Stimuli.db_atten)) +1;
        bandnum = ceil(filesthisfreq/length(auto.Stimuli.noisenotch));
        Stimuli.freq_hz = auto.Stimuli.freq_hz(freqnum);
        Stimuli.db_atten = auto.Stimuli.db_atten(sattnum);
        Stimuli.naves = auto.Stimuli.naves(sattnum);
        if bandnum <= length(auto.Stimuli.noisenotch),
            Stimuli.upedge = round(10^(log10(Stimuli.freq_hz)+log10(2)*(auto.Stimuli.noisenotch(bandnum)/2)));
            Stimuli.loedge = round(10^(log10(Stimuli.freq_hz)-log10(2)*(auto.Stimuli.noisenotch(bandnum)/2)));
        else
            Stimuli.upedge = 0;
            Stimuli.loedge = 0;
        end
        if bandnum <= length(auto.Stimuli.noiseatten),
            Stimuli.noiseatten = auto.Stimuli.noiseatten(bandnum);
        else
            Stimuli.noiseatten = 120;
        end
    end
    % End of auto setup
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    
    if Stimuli.freq_hz == 0,
        stim_txt = 'click';
    else
        stim_txt = num2str(Stimuli.freq_hz);
    end
    
    set(FIG.ax3.ParamData1,'string',{stim_txt},'color',[.1 .1 .6]);
    set(FIG.ax3.ParamData2,'string',{Stimuli.db_atten},'color',[.1 .1 .6]);
    if isnan(Stimuli.masker_freq_hz)
        set(FIG.ax3.ParamData3,'string',{'not used'},'color',[.8 .8 .8]);
        set(FIG.ax3.ParamData4,'string',{'not used'},'color',[.8 .8 .8]);
        set(FIG.ax3.ParamData5,'string',{'not used'},'color',[.8 .8 .8]);
    else
        set(FIG.ax3.ParamData3,'string',{Stimuli.masker_freq_hz},'color',[.1 .1 .6]);
        set(FIG.ax3.ParamData4,'string',{Stimuli.masker_delay_ms},'color',[.1 .1 .6]);
        set(FIG.ax3.ParamData5,'string',{Stimuli.masker_db_atten},'color',[.1 .1 .6]);
    end
    
    set(FIG.push.stop,'Enable','on');
    set(FIG.push.recall,'Enable','off');
    set(FIG.push.aver,'Enable','off');
    set(FIG.push.print,'Enable','off');
    set(FIG.push.params,'Enable','off');
    drawnow;
    
    %use these default values if no inputs are specified
    scale = Stimuli.amp_gain/1e6;
    if isfinite(Stimuli.pulses_per_sec)
        period = 1000/Stimuli.pulses_per_sec; %trigger interval in msecs
    elseif isfinite(Stimuli.isi)
        period = Stimuli.play_duration + Stimuli.isi;
    else
        warndlg('Can''t compute stimulation period.','Stimulus Error')
        return
    end
    if (Stimuli.record_duration-10) > period
        warndlg('Shorten record interval.','Stimulus Error')
        return
    end
    
    %Stimuli.SampRate = invoke(COMM.RX6,'GetSFreq')/1000;
    updateTDT;
    buf = ceil(Stimuli.record_duration*Stimuli.SampRate/20); %timeslice set to 20
    AVdata = zeros(buf,4);
    AVdata(:,1)= ([1:buf] / (Stimuli.SampRate/20))';
    set(FIG.ax1.line1,'XData',AVdata(:,1),'YData',AVdata(:,4));
    
    invoke(COMM.RX6,'SetTagVal','Npls',Stimuli.naves*2);
    invoke(COMM.RX6,'SetTagVal','ToneDur',Stimuli.play_duration);
    invoke(COMM.RX6,'SetTagVal','RecordDur',Stimuli.record_duration);
    invoke(COMM.RX6,'SetTagVal','ReadDur',period-Stimuli.record_duration);
    invoke(COMM.RX6,'SetTagVal','nAVG',Stimuli.naves/2);
    invoke(COMM.RX6,'SetTagVal','nSize',buf);
    invoke(COMM.RX6,'SetTagVal','reject',Stimuli.reject);
    invoke(COMM.RX6,'Run');
    
    %play-record loop
    set(FIG.ax2.ProgMess,'String','Averaging in progress...');
    invoke(COMM.RX6,'SoftTrg',1);
    tic;
    while toc<.5, drawnow; end
    invoke(COMM.RX6,'SoftTrg',2);
    
    numstm = 0;
    shiftready = 0;
    reps = ceil(Stimuli.naves/Stimuli.pulses_per_sec);
    for counter = 1:reps
        update = 1;
        while ~length(get(FIG.push.stop,'Userdata'))
            stage=invoke(COMM.RX6,'ReadTagV','Stage',0,1);
            curn=invoke(COMM.RX6,'ReadTagV','CurN',0,1);
            if (stage==1) & (~shiftready)
                shiftready = 1;
            elseif (stage==2) & (shiftready)
                numstm = numstm+2;
                invoke(COMM.RX6,'SetTagVal','Scale',mod(numstm,4)-1);
                shiftready = 0;
            end
            nGood=invoke(COMM.RX6,'ReadTagV','nGood',0,1);
            if nGood*2==Stimuli.naves
                update = 2;
                AVdata(:,2) = invoke(COMM.RX6,'ReadTagV','av_data',0,buf)'./nGood./scale;
                AVdata(:,3) = invoke(COMM.RX6,'ReadTagV','av_data',buf,buf)'./nGood./scale;
                AVdata(:,4) = (AVdata(:,2)+AVdata(:,3))/2;
                set(FIG.ax1.line1,'YData',AVdata(:,4));
                ylimup = max(0.01,ceil(max(AVdata(:,4))*12)/10);
                ylimdown = min(0.01,floor(min(AVdata(:,4))*12)/10);
                set(FIG.ax1.axes,'YLim',[ylimdown ylimup]);
                set(FIG.ax1.axes,'YTick',[ylimdown ylimup]);
                set(FIG.ax2.ProgMess,'String',nGood*2,'FontSize',32);
                drawnow;
                break
            elseif nGood*2==counter*Stimuli.pulses_per_sec & update
                update = 0;
                AVdata(:,2) = invoke(COMM.RX6,'ReadTagV','av_data',0,buf)'./nGood./scale;
                AVdata(:,3) = invoke(COMM.RX6,'ReadTagV','av_data',buf,buf)'./nGood./scale;
                AVdata(:,4) = (AVdata(:,2)+AVdata(:,3))/2;
                set(FIG.ax1.line1,'YData',AVdata(:,4));
                ylimup = max(0.01,ceil(max(AVdata(:,4))*12)/10);
                ylimdown = min(0.01,floor(min(AVdata(:,4))*12)/10);
                set(FIG.ax1.axes,'YLim',[ylimdown ylimup]);
                set(FIG.ax1.axes,'YTick',[ylimdown ylimup]);
                set(FIG.ax2.ProgMess,'String',counter*Stimuli.pulses_per_sec,'FontSize',32);
                drawnow;
                break
            end
            if update == 2, break; end
        end
    end
    if get(FIG.push.stop,'Userdata')
        set(FIG.ax2.ProgMess,'String','Stopping Averager...','FontSize',12);
    end
    
    invoke(COMM.PA5_1,'SetAtten',120.0);
    invoke(COMM.PA5_2,'SetAtten',120.0);
    invoke(COMM.PA5_3,'SetAtten',120.0);
    invoke(COMM.PA5_4,'SetAtten',120.0);
    invoke(COMM.RX6,'Halt');
    
    
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % added by bjm 1/05 to allow autosampling 36 stims per freq
    if strcmp(Stimuli.automatic,'yes') & ~length(get(FIG.push.stop,'Userdata')),
        ButtonName = 'Yes';
        comment = 'Data collected in auto mode.';
    else
        
        %************ Saving Data ******************
        nextpic = NelData.General.fnum +1;
        prompt = ['Save data as picture # ' num2str(nextpic)];
        ButtonName=questdlg(prompt, ...
            'Save Prompt', ...
            'Yes','No','Change#','Yes');
        
        switch ButtonName,
            case 'Yes',
                comment='No comment.';
            case 'Change#'
                comment='No comment';
                fcheck = {''}; title = 'Check Picture';
                while ((isempty(fcheck) | isempty(fcheck{1})))
                    fcheck = lower(inputdlg({'Save this picture as:'},title,1,{num2str(nextpic)},'on'));
                    title = 'Please enter NON-EMPTY pic number';
                end                
                NelData.General.fnum = str2num(fcheck{1})-1;
        end
    end
    
    if strcmp(ButtonName,'Yes') |  strcmp(ButtonName,'Change#'),        
        NelData.General.fnum = make_average_text_file(comment);
        UpdateExplist(NelData.General.fnum);
    end
    
    
    set(FIG.push.stop,'Enable','off');
    set(FIG.push.recall,'Enable','on');
    set(FIG.push.aver,'Enable','on');
    set(FIG.push.print,'Enable','on');
    set(FIG.push.params,'Enable','on');
    set(FIG.ax2.ProgMess,'String','Ready for input...','fontSize',12);
    drawnow;
    
    if strcmp(Stimuli.automatic,'yes') & ~length(get(FIG.push.stop,'Userdata')) ...
            if filenum < length(auto.Stimuli.freq_hz)*length(auto.Stimuli.db_atten)*length(auto.Stimuli.noisenotch),
            cap('average');
        else
            NewDirName = fullfile(data_dir,NelData.General.CurDataDir);
            if ~exist(fullfile(NewDirName,'auto.mat')),
                destination = fullfile(NewDirName,'auto.mat');
                success = copyfile(which('auto.mat'),destination);
                if ~success
                    ErrMsg = ['Cannot move automatic file structure file to ' NewDirName '.'];
                end
            end
        end
    end
    set(FIG.push.stop,'Userdata',[]);
    set(FIG.push.mag,'Userdata',0);
    set(FIG.push.mag,'String','Zoom In');
    set(FIG.ax1.axes,'XLim',[0 Stimuli.record_duration]);
    
elseif strcmp(command_str,'masker_freq_hz')
    new_value = get(FIG.push.edit,'string');
    set(FIG.push.edit,'string',[]);
    if length(new_value),
        userinput = str2num(new_value);
        if strcmp(lower(new_value),'nan')
            Stimuli.masker_freq_hz = userinput;
            set(FIG.ax3.ParamData3,'String','not used','Color',[.8 .8 .8]);
            eval('update_params');
        elseif userinput>=0 & userinput<=100000,
            Stimuli.masker_freq_hz = userinput;
            set(FIG.ax3.ParamData3,'String',new_value);
            eval('update_params');
        else
            set(FIG.push.edit,'string','Illegal!');
        end
    else
        set(FIG.push.edit,'string','Illegal!');
    end
    
elseif strcmp(command_str,'masker_delay_ms')
    new_value = get(FIG.push.edit,'string');
    set(FIG.push.edit,'string',[]);
    if length(new_value),
        userinput = str2num(new_value);
        if userinput>=0 & userinput<=100000,
            Stimuli.masker_delay_ms = userinput;
            set(FIG.ax3.ParamData4,'String',new_value);
            eval('update_params');
        else
            set(FIG.push.edit,'string','Illegal!');
        end
    else
        set(FIG.push.edit,'string','Illegal!');
    end
    
elseif strcmp(command_str,'masker_db_atten')
    new_value = get(FIG.push.edit,'string');
    set(FIG.push.edit,'string',[]);
    if length(new_value),
        userinput = str2num(new_value);
        if userinput>=0 & userinput<=120,
            Stimuli.masker_db_atten = userinput;
            set(FIG.ax3.ParamData5,'String',new_value);
            eval('update_params');
        else
            set(FIG.push.edit,'string','Illegal!');
        end
    else
        set(FIG.push.edit,'string','Illegal!');
    end
    
elseif strcmp(command_str,'stimulus')
    new_value = get(FIG.push.edit,'string');
    set(FIG.push.edit,'string',[]);
    if length(new_value),
        if strncmp(new_value,'c',1),
            Stimuli.freq_hz = 0;
            set(FIG.ax3.ParamData2,'String','click');
            eval('update_params');
        else
            userinput = str2num(new_value);
            if userinput>=100 & userinput<=100000,
                Stimuli.freq_hz = userinput;
                set(FIG.ax3.ParamData1,'String',new_value);
                eval('update_params');
            else
                set(FIG.push.edit,'string','Illegal!');
            end
        end
    else
        set(FIG.push.edit,'string','Illegal!');
    end
    
elseif strcmp(command_str,'attenuation')
    new_value = get(FIG.push.edit,'string');
    set(FIG.push.edit,'string',[]);
    if length(new_value),
        userinput = str2num(new_value);
        if userinput>=0 & userinput<=120,
            Stimuli.db_atten = userinput;
            set(FIG.ax3.ParamData2,'String',new_value);
            eval('update_params');
        else
            set(FIG.push.edit,'string','Illegal!');
        end
    else
        set(FIG.push.edit,'string','Illegal!');
    end
    
elseif strcmp(command_str,'mag')
    if get(FIG.push.mag,'Userdata')
        set(FIG.push.mag,'Userdata',0);
        set(FIG.push.mag,'String','Zoom In');
        set(FIG.ax1.axes,'XLim',[0 Stimuli.record_duration]);
    else
        set(FIG.push.mag,'Userdata',1);
        set(FIG.push.mag,'String','Zoom Out');
        if isfinite(Stimuli.masker_freq_hz)
            xstart = Stimuli.masker_duration + Stimuli.masker_delay_ms;
        else
            xstart = 0;
        end
        set(FIG.ax1.axes,'XLim',[xstart xstart+30]);
    end
    drawnow;
    
elseif strcmp(command_str,'stop')
    set(FIG.push.stop,'Userdata',1);
    
elseif strcmp(command_str,'recall')
    eval('read_avg_file');
    set(FIG.push.stop,'Enable','off');
    set(FIG.push.recall,'Enable','on');
    set(FIG.push.aver,'Enable','on');
    set(FIG.push.print,'Enable','on');
    set(FIG.push.params,'Enable','on');
    drawnow;
    
elseif strcmp(command_str,'print')
    set(gcf,'PaperOrientation','Landscape','PaperPosition',[0 0 11 8.5]);
    if ispc
        print('-dwinc','-r200','-noui');
    else
        print('-PCarson','-dpsc','-r200','-noui');
    end
end
