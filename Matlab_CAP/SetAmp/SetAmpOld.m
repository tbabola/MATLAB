function SetAmp(command,config)

global program root_dir

if ~nargin
    SetAmpWindow;
    command = 'initialize';
end

if strcmp(command,'initialize')
    PARAMS = get(gcf,'Userdata');
    invoke(PARAMS.TDT.RPco1,'ConnectRP2','USB',PARAMS.fighandles.current.source);
    invoke(PARAMS.TDT.RPco1,'ClearCOF');

    switch PARAMS.fighandles.current.stimulus
        case 'tone'
            invoke(PARAMS.TDT.RPco1,'LoadCOFsf',fullfile(root_dir,'object','ToneBackground.rco'),4);
            SFreq = invoke(PARAMS.TDT.RPco1,'GetSFreq');
            MaxFreq = SFreq/2;
            if program.configuration.frequency > MaxFreq
                warn_str = ['Maximum frequency is ' num2str(MaxFreq) ' kHz.'];
                warndlg(warn_str,'Nyquist Error');
                uiwait
                return
            else
                invoke(PARAMS.TDT.RPco1,'SetTagVal','Frequency',program.configuration.frequency);
            end
        case 'broadband'
            invoke(PARAMS.TDT.RPco1,'LoadCOFsf',fullfile(root_dir,'object','BroadbandNoiseBackground.rco'),4);
        case 'notched'
            invoke(PARAMS.TDT.RPco1,'LoadCOFsf',fullfile(root_dir,'object','NotchNoiseBackground.rco'),4);
            SFreq = invoke(PARAMS.TDT.RPco1,'GetSFreq');
            MaxFreq = SFreq/2;
            if program.configuration.HighCutOff > MaxFreq
                warn_str = ['Maximum frequency is ' num2str(MaxFreq) ' kHz.'];
                warndlg(warn_str,'Nyquist Error');
                uiwait
                return
            else
                invoke(PARAMS.TDT.RPco1,'SetTagVal','LowCutOff',program.configuration.LowCutOff);
                invoke(PARAMS.TDT.RPco1,'SetTagVal','HighCutOff',program.configuration.HighCutOff);
            end
        case 'bandpass'
            invoke(PARAMS.TDT.RPco1,'LoadCOFsf',fullfile(root_dir,'object','BandpassNoiseBackground.rco'),4);
            SFreq = invoke(PARAMS.TDT.RPco1,'GetSFreq');
            MaxFreq = SFreq/2;
            if program.configuration.HighCutOff > MaxFreq
                warn_str = ['Maximum frequency is ' num2str(MaxFreq) ' kHz.'];
                warndlg(warn_str,'Nyquist Error');
                uiwait
                return
            else
                invoke(PARAMS.TDT.RPco1,'SetTagVal','LowCutOff',program.configuration.LowCutOff);
                invoke(PARAMS.TDT.RPco1,'SetTagVal','HighCutOff',program.configuration.HighCutOff);
            end
    end

    invoke(PARAMS.TDT.RPco1,'SetTagVal','Channel',PARAMS.fighandles.current.channel);
    invoke(PARAMS.TDT.RPco1,'Run');

    invoke(PARAMS.TDT.PAco1,'ConnectPA5','USB',PARAMS.fighandles.current.atten);
    invoke(PARAMS.TDT.PAco1,'SetAtten',program.configuration.attenuation);

    set(PARAMS.fighandles.radio.standard,'enable','on');
    set(PARAMS.fighandles.radio.target,'enable','on');
    set(PARAMS.fighandles.radio.background,'enable','on');
    set(PARAMS.fighandles.radio.tone,'enable','on');
    set(PARAMS.fighandles.radio.bbn,'enable','on');
    set(PARAMS.fighandles.radio.nn,'enable','on');
    set(PARAMS.fighandles.radio.bpn,'enable','on');

    set(PARAMS.fighandles.push.save,'Userdata',0);
    while ~get(PARAMS.fighandles.push.save,'Userdata');
        tic
        set(PARAMS.fighandles.parmtxt.RMS,'String', ...
            [sprintf('%4.2f',invoke(PARAMS.TDT.RPco1,'GetTagVal','RMSvolts'))]);
        while toc < .1, drawnow; end
    end
    invoke(PARAMS.TDT.RPco1,'Halt');
    invoke(PARAMS.TDT.PAco1,'SetAtten',120);
    if get(PARAMS.fighandles.push.save,'Userdata')==1
        delete(gcf);
    elseif get(PARAMS.fighandles.push.save,'Userdata')==2
        v2 = str2num(get(PARAMS.fighandles.parmtxt.RMS,'String'));
        v1 = v2*10^(program.configuration.attenuation/20);
        UpdateVolts(num2str(v1));
        delete(gcf);
    elseif get(PARAMS.fighandles.push.save,'Userdata')==3
        SetAmp('initialize');
    end

elseif strcmp(command,'frequency')
    PARAMS = get(gcf,'Userdata');
    set(PARAMS.fighandles.parmtxt.frequency,'string',get(PARAMS.fighandles.push.edit,'string'));
    program.configuration.frequency = str2num(get(PARAMS.fighandles.push.edit,'string'));
    set(PARAMS.fighandles.push.edit,'string',[]);
    if program.configuration.frequency>=0 & program.configuration.frequency<48000
        set(PARAMS.fighandles.parmtxt.LCHeader,'Color',[.8 .8 .8]);
        set(PARAMS.fighandles.parmtxt.HCHeader,'Color',[.8 .8 .8]);
        set(PARAMS.fighandles.parmtxt.LowCutOff,'Color',[.8 .8 .8]);
        set(PARAMS.fighandles.parmtxt.HighCutOff,'Color',[.8 .8 .8]);
        invoke(PARAMS.TDT.RPco1,'SetTagVal','frequency',program.configuration.frequency);
        invoke(PARAMS.TDT.RPco1,'SetTagVal','tone',1);
    end

elseif strcmp(command,'attenuation')
    PARAMS = get(gcf,'Userdata');
    NewValue = str2num(get(PARAMS.fighandles.push.edit,'string'));
    if NewValue >= 0 & NewValue <= 120
        set(PARAMS.fighandles.parmtxt.attenuation,'String',get(PARAMS.fighandles.push.edit,'string'));
        program.configuration.attenuation = NewValue;
        invoke(PARAMS.TDT.PAco1,'ConnectPA5','USB',PARAMS.fighandles.current.atten);
        invoke(PARAMS.TDT.PAco1,'SetAtten',program.configuration.attenuation);
    else
        warn_str = ['New attenuation out of bounds. No change.'];
        warndlg(warn_str,'Attenuation Error');
        uiwait
    end
    set(PARAMS.fighandles.push.edit,'string',[]);

elseif strcmp(command,'LowCutOff')
    PARAMS = get(gcf,'Userdata');
    val = str2num(get(PARAMS.fighandles.push.edit,'string'));
    if val < 48000 & val >= 0
        set(PARAMS.fighandles.parmtxt.LowCutOff,'string',get(PARAMS.fighandles.push.edit,'string'));
        program.configuration.LowCutOff = val;
        set(PARAMS.fighandles.push.edit,'string',[]);
        set(gcf,'Userdata', ...
            struct('fighandles',PARAMS.fighandles,'TDT',PARAMS.TDT));
        set(PARAMS.fighandles.push.save,'Userdata',3);
    end

elseif strcmp(command,'HighCutOff')
    PARAMS = get(gcf,'Userdata');
    val = str2num(get(PARAMS.fighandles.push.edit,'string'));
    if val < 48000 & val >= 0
        set(PARAMS.fighandles.parmtxt.HighCutOff,'string',get(PARAMS.fighandles.push.edit,'string'));
        program.configuration.HighCutOff = val;
        set(PARAMS.fighandles.push.edit,'string',[]);
        set(gcf,'Userdata', ...
            struct('fighandles',PARAMS.fighandles,'TDT',PARAMS.TDT));
        set(PARAMS.fighandles.push.save,'Userdata',3);
    end

elseif strcmp(command,'restart')
    PARAMS = get(gcf,'Userdata');
    set(PARAMS.fighandles.radio.standard,'enable','off');
    set(PARAMS.fighandles.radio.target,'enable','off');
    set(PARAMS.fighandles.radio.background,'enable','off');
    set(PARAMS.fighandles.radio.tone,'enable','off');
    set(PARAMS.fighandles.radio.bbn,'enable','off');
    set(PARAMS.fighandles.radio.nn,'enable','off');
    set(PARAMS.fighandles.radio.bpn,'enable','off');

    invoke(PARAMS.TDT.PAco1,'ConnectPA5','USB',PARAMS.fighandles.current.atten);
    invoke(PARAMS.TDT.PAco1,'SetAtten',120);
    switch config
        case 'standard'
            set(PARAMS.fighandles.radio.standard,'value',1);
            set(PARAMS.fighandles.radio.target,'value',0);
            set(PARAMS.fighandles.radio.background,'value',0);
            PARAMS.fighandles.current.config = 'standard';
            PARAMS.fighandles.current.source = program.configuration.Standard.Source;
            PARAMS.fighandles.current.channel = program.configuration.Standard.Channel;
            PARAMS.fighandles.current.atten = program.configuration.Standard.AttenNum;
        case 'target'
            set(PARAMS.fighandles.radio.standard,'value',0);
            set(PARAMS.fighandles.radio.target,'value',1);
            set(PARAMS.fighandles.radio.background,'value',0);
            PARAMS.fighandles.current.config = 'target';
            PARAMS.fighandles.current.source = program.configuration.Target.Source;
            PARAMS.fighandles.current.channel = program.configuration.Target.Channel;
            PARAMS.fighandles.current.atten = program.configuration.Target.AttenNum;
        case 'background'
            set(PARAMS.fighandles.radio.standard,'value',0);
            set(PARAMS.fighandles.radio.target,'value',0);
            set(PARAMS.fighandles.radio.background,'value',1);
            PARAMS.fighandles.current.config = 'background';
            PARAMS.fighandles.current.source = program.configuration.Background.Source;
            PARAMS.fighandles.current.channel = program.configuration.Background.Channel;
            PARAMS.fighandles.current.atten = program.configuration.Background.AttenNum;
        case 'tone'
            set(PARAMS.fighandles.radio.tone,'value',1);
            set(PARAMS.fighandles.radio.bbn,'value',0);
            set(PARAMS.fighandles.radio.nn,'value',0);
            set(PARAMS.fighandles.radio.bpn,'value',0);

            PARAMS.fighandles.current.stimulus = 'tone';
            set(PARAMS.fighandles.parmtxt.FHeader,'Color','k');
            set(PARAMS.fighandles.parmtxt.frequency,'Color',program.fontcolor);
            set(PARAMS.fighandles.parmtxt.LCHeader,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.HCHeader,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.LowCutOff,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.HighCutOff,'Color',[.8 .8 .8]);
        case 'broadband'
            set(PARAMS.fighandles.radio.tone,'value',0);
            set(PARAMS.fighandles.radio.bbn,'value',1);
            set(PARAMS.fighandles.radio.nn,'value',0);
            set(PARAMS.fighandles.radio.bpn,'value',0);

            PARAMS.fighandles.current.stimulus = 'broadband';
            set(PARAMS.fighandles.parmtxt.FHeader,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.frequency,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.LCHeader,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.HCHeader,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.LowCutOff,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.HighCutOff,'Color',[.8 .8 .8]);
        case 'notched'
            set(PARAMS.fighandles.radio.tone,'value',0);
            set(PARAMS.fighandles.radio.bbn,'value',0);
            set(PARAMS.fighandles.radio.nn,'value',1);
            set(PARAMS.fighandles.radio.bpn,'value',0);

            PARAMS.fighandles.current.stimulus = 'notched';
            set(PARAMS.fighandles.parmtxt.FHeader,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.frequency,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.LCHeader,'Color','k');
            set(PARAMS.fighandles.parmtxt.HCHeader,'Color','k');
            set(PARAMS.fighandles.parmtxt.LowCutOff,'Color',program.fontcolor);
            set(PARAMS.fighandles.parmtxt.HighCutOff,'Color',program.fontcolor);
        case 'bandpass'
            set(PARAMS.fighandles.radio.tone,'value',0);
            set(PARAMS.fighandles.radio.bbn,'value',0);
            set(PARAMS.fighandles.radio.nn,'value',0);
            set(PARAMS.fighandles.radio.bpn,'value',1);

            PARAMS.fighandles.current.stimulus = 'bandpass';
            set(PARAMS.fighandles.parmtxt.FHeader,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.frequency,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.LCHeader,'Color','k');
            set(PARAMS.fighandles.parmtxt.HCHeader,'Color','k');
            set(PARAMS.fighandles.parmtxt.LowCutOff,'Color',program.fontcolor);
            set(PARAMS.fighandles.parmtxt.HighCutOff,'Color',program.fontcolor);
    end
    set(gcf,'Userdata',struct('fighandles',PARAMS.fighandles,'TDT',PARAMS.TDT));
    set(PARAMS.fighandles.push.save,'Userdata',3);

elseif strcmp(command,'halt')
    PARAMS = get(gcf,'Userdata');
    set(PARAMS.fighandles.push.save,'Userdata',1);

elseif strcmp(command,'save')
    PARAMS = get(gcf,'Userdata');
    set(PARAMS.fighandles.push.save,'Userdata',2);
end