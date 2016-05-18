function v1 = SetAmp(command,config)

global program prog_dir root_dir COMM

if ~nargin
    
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    %uncomment the following text for stand alone configuration
    
    prog_dir = fileparts(which('SetAmp'));
    addpath(fullfile(prog_dir,'object'));
    
    
    
    %configuration
    interface      = struct('responsebit','CheckCat', ...
        'rewardbit',2);
    frequency      = 16000;
    frequency2     = 32000;
    attenuation    =    20;
    attenuation2   =   120;
    standard = struct('Source',1, ...
        'Channel',1, ...
        'AttenNum',1);
    target = struct('Source',1, ...
        'Channel',1, ...
        'AttenNum',1);
    background = struct('Source',2, ...
        'Channel',1, ...
        'AttenNum',2);
    lowcutoff      =     0;
    highcutoff     = 48000;
    %__________________________________________
    
    
    configuration = struct('interface',interface, ...
        'frequency',frequency, ...
        'frequency2',frequency2, ...
        'attenuation',attenuation, ...
        'attenuation2',attenuation2, ...
        'Standard',standard, ...
        'Target',target, ...
        'Background',background, ...
        'LowCutOff',lowcutoff, ...
        'HighCutOff',highcutoff);
    
    calibration = struct('LowCutOff', 500, ...
        'HighCutOff', 40000, ...
        'frequency',  10000, ...
        'attenuation',   10);
    
    program = struct('fontcolor',[.1 .1 .6], ...
        'configuration',configuration, ...
        'calibration',calibration);
    
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % end of stand alone configuration
    
    SetAmpWindow;
    command = 'initialize';
end

if strcmp(command,'initialize')
    LoadTDT;
    PARAMS = get(gcf,'Userdata');
    
    switch PARAMS.fighandles.current.stimulus
        case 'tone'
            invoke(COMM.RX6,'LoadCOF',fullfile(prog_dir,'object','ToneBackground.rco'));
            %invoke(COMM.RX6,'LoadCOF',fullfile(prog_dir,'object','tone.rco'));
            SFreq = invoke(COMM.RX6,'GetSFreq');
            MaxFreq = SFreq/2;
            if program.configuration.frequency > MaxFreq
                warn_str = ['Maximum frequency is ' num2str(MaxFreq) ' kHz.'];
                warndlg(warn_str,'Nyquist Error');
                uiwait
                return
            else
                invoke(COMM.RX6,'SetTagVal','Frequency',program.configuration.frequency);
            end
        case 'tt'
            invoke(COMM.RX6,'LoadCOF',fullfile(prog_dir,'object','TwoToneBackground.rco'));
            SFreq = invoke(COMM.RX6,'GetSFreq');
            MaxFreq = SFreq/2;
            if program.configuration.frequency > MaxFreq | program.configuration.frequency > MaxFreq
                warn_str = ['Maximum frequency is ' num2str(MaxFreq) ' kHz.'];
                warndlg(warn_str,'Nyquist Error');
                uiwait
                return
            else
                invoke(COMM.RX6,'SetTagVal','Frequency',program.configuration.frequency);
                invoke(COMM.RX6,'SetTagVal','Frequency2',program.configuration.frequency2);
            end
        case 'broadband'
            invoke(COMM.RX6,'LoadCOFsf',fullfile(prog_dir,'object','BroadbandNoiseBackground.rco'),4);
        case 'notched'
            invoke(COMM.RX6,'LoadCOFsf',fullfile(prog_dir,'object','BandPassNoiseBackground2.rco'),4);
            SFreq = invoke(COMM.RX6,'GetSFreq');
            MaxFreq = SFreq/2;
            if program.configuration.HighCutOff > MaxFreq
                warn_str = ['Maximum frequency is ' num2str(MaxFreq) ' kHz.'];
                warndlg(warn_str,'Nyquist Error');
                uiwait
                return
            else
                b = makeband(SFreq,max(program.configuration.LowCutOff,100),min(program.configuration.HighCutOff,47500),'reject');
                invoke(COMM.RX6,'WriteTagV','Coef',0,b);
            end
        case 'bandpass'
            invoke(COMM.RX6,'LoadCOFsf',fullfile(prog_dir,'object','BandPassNoiseBackground2.rco'),4);
            SFreq = invoke(COMM.RX6,'GetSFreq');
            MaxFreq = SFreq/2;
            if program.configuration.HighCutOff > MaxFreq
                warn_str = ['Maximum frequency is ' num2str(MaxFreq) ' kHz.'];
                warndlg(warn_str,'Nyquist Error');
                uiwait
                return
            else
                b = makeband(SFreq,max(program.configuration.LowCutOff,100),min(program.configuration.HighCutOff,47500),'pass');
                invoke(COMM.RX6,'WriteTagV','Coef',0,b);
            end
    end
    
    invoke(COMM.RX6,'Run');
    
    switch PARAMS.fighandles.current.stimulus
        case {'tt'}
            invoke(COMM.PA5_1,'SetAtten',program.configuration.attenuation);
            invoke(COMM.PA5_2,'SetAtten',program.configuration.attenuation2);
            invoke(COMM.PA5_3,'SetAtten',0);
            invoke(COMM.PA5_4,'SetAtten',120);
        otherwise
            invoke(COMM.PA5_1,'SetAtten',program.configuration.attenuation);
            invoke(COMM.PA5_2,'SetAtten',120);
            invoke(COMM.PA5_3,'SetAtten',0);
            invoke(COMM.PA5_4,'SetAtten',120);
    end
    
    
    %     set(PARAMS.fighandles.radio.standard,'enable','on');
    %     set(PARAMS.fighandles.radio.target,'enable','on');
    %     set(PARAMS.fighandles.radio.background,'enable','on');
    set(PARAMS.fighandles.radio.tone,'enable','on');
    set(PARAMS.fighandles.radio.tt,'enable','on');
    set(PARAMS.fighandles.radio.bbn,'enable','on');
    set(PARAMS.fighandles.radio.nn,'enable','on');
    set(PARAMS.fighandles.radio.bpn,'enable','on');
    
    set(PARAMS.fighandles.push.save,'Userdata',0);
    
    while ~get(PARAMS.fighandles.push.save,'Userdata');
        tic
        set(PARAMS.fighandles.parmtxt.RMS,'String', ...
        sprintf('%4.2f',invoke(COMM.RX6,'GetTagVal','RMSvolts')));
        while toc < .1, drawnow; end
    end
    invoke(COMM.RX6,'Halt');
    invoke(COMM.PA5_1, 'SetAtten', 120);
    invoke(COMM.PA5_2, 'SetAtten', 120);
    invoke(COMM.PA5_3, 'SetAtten', 120);
    invoke(COMM.PA5_4, 'SetAtten', 120);
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
        invoke(COMM.RX6,'SetTagVal','frequency',program.configuration.frequency);
    end
    
elseif strcmp(command,'frequency2')
    PARAMS = get(gcf,'Userdata');
    set(PARAMS.fighandles.parmtxt.frequency2,'string',get(PARAMS.fighandles.push.edit,'string'));
    program.configuration.frequency2 = str2num(get(PARAMS.fighandles.push.edit,'string'));
    set(PARAMS.fighandles.push.edit,'string',[]);
    if program.configuration.frequency2>=0 & program.configuration.frequency2<48000
        set(PARAMS.fighandles.parmtxt.LCHeader,'Color',[.8 .8 .8]);
        set(PARAMS.fighandles.parmtxt.HCHeader,'Color',[.8 .8 .8]);
        set(PARAMS.fighandles.parmtxt.LowCutOff,'Color',[.8 .8 .8]);
        set(PARAMS.fighandles.parmtxt.HighCutOff,'Color',[.8 .8 .8]);
        invoke(COMM.RX6,'SetTagVal','frequency2',program.configuration.frequency2);
    end
    
elseif strcmp(command,'attenuation')
    PARAMS = get(gcf,'Userdata');
    NewValue = str2num(get(PARAMS.fighandles.push.edit,'string'));
    if NewValue >= 0 & NewValue <= 120
        set(PARAMS.fighandles.parmtxt.attenuation,'String',get(PARAMS.fighandles.push.edit,'string'));
        program.configuration.attenuation = NewValue;
        invoke(COMM.PA5_1, 'SetAtten', program.configuration.attenuation);
    else
        warn_str = ['New attenuation out of bounds. No change.'];
        warndlg(warn_str,'Attenuation Error');
        uiwait
    end
    set(PARAMS.fighandles.push.edit,'string',[]);
    
elseif strcmp(command,'attenuation2')
    PARAMS = get(gcf,'Userdata');
    NewValue = str2num(get(PARAMS.fighandles.push.edit,'string'));
    if NewValue >= 0 & NewValue <= 120
        set(PARAMS.fighandles.parmtxt.attenuation2,'String',get(PARAMS.fighandles.push.edit,'string'));
        program.configuration.attenuation2 = NewValue;
        invoke(COMM.PA5_2, 'SetAtten', program.configuration.attenuation2);
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
            struct('fighandles',PARAMS.fighandles));
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
            struct('fighandles',PARAMS.fighandles));
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
    
    invoke(COMM.PA5_1, 'SetAtten', 120);
    invoke(COMM.PA5_2, 'SetAtten', 120);
    invoke(COMM.PA5_3, 'SetAtten', 120);
    invoke(COMM.PA5_4, 'SetAtten', 120);
    
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
            set(PARAMS.fighandles.radio.tt,'value',0);
            set(PARAMS.fighandles.radio.bbn,'value',0);
            set(PARAMS.fighandles.radio.nn,'value',0);
            set(PARAMS.fighandles.radio.bpn,'value',0);
            
            PARAMS.fighandles.current.stimulus = 'tone';
            set(PARAMS.fighandles.parmtxt.FHeader,'Color','k');
            set(PARAMS.fighandles.parmtxt.frequency,'Color',program.fontcolor);
            set(PARAMS.fighandles.parmtxt.FHeader2,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.frequency2,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.AHeader2,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.attenuation2,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.LCHeader,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.HCHeader,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.LowCutOff,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.HighCutOff,'Color',[.8 .8 .8]);
            
            program.configuration.attenuation2 = 120;
            set(PARAMS.fighandles.parmtxt.attenuation2,'String',num2str(program.configuration.attenuation2));
            invoke(COMM.PA5_2, 'SetAtten', program.configuration.attenuation2);

        case 'tt'
            set(PARAMS.fighandles.radio.tone,'value',0);
            set(PARAMS.fighandles.radio.tt,'value',1);
            set(PARAMS.fighandles.radio.bbn,'value',0);
            set(PARAMS.fighandles.radio.nn,'value',0);
            set(PARAMS.fighandles.radio.bpn,'value',0);
            
            PARAMS.fighandles.current.stimulus = 'tt';
            set(PARAMS.fighandles.parmtxt.FHeader,'Color','k');
            set(PARAMS.fighandles.parmtxt.frequency,'Color',program.fontcolor);
            set(PARAMS.fighandles.parmtxt.FHeader2,'Color','k');
            set(PARAMS.fighandles.parmtxt.frequency2,'Color',program.fontcolor);
            set(PARAMS.fighandles.parmtxt.LCHeader,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.HCHeader,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.LowCutOff,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.HighCutOff,'Color',[.8 .8 .8]);
        case 'broadband'
            set(PARAMS.fighandles.radio.tone,'value',0);
            set(PARAMS.fighandles.radio.tt,'value',0);
            set(PARAMS.fighandles.radio.bbn,'value',1);
            set(PARAMS.fighandles.radio.nn,'value',0);
            set(PARAMS.fighandles.radio.bpn,'value',0);
            
            PARAMS.fighandles.current.stimulus = 'broadband';
            set(PARAMS.fighandles.parmtxt.FHeader,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.frequency,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.FHeader2,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.frequency2,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.AHeader2,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.attenuation2,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.LCHeader,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.HCHeader,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.LowCutOff,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.HighCutOff,'Color',[.8 .8 .8]);
        case 'notched'
            set(PARAMS.fighandles.radio.tone,'value',0);
            set(PARAMS.fighandles.radio.tt,'value',0);
            set(PARAMS.fighandles.radio.bbn,'value',0);
            set(PARAMS.fighandles.radio.nn,'value',1);
            set(PARAMS.fighandles.radio.bpn,'value',0);
            
            PARAMS.fighandles.current.stimulus = 'notched';
            set(PARAMS.fighandles.parmtxt.FHeader,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.frequency,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.FHeader2,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.frequency2,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.AHeader2,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.attenuation2,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.LCHeader,'Color','k');
            set(PARAMS.fighandles.parmtxt.HCHeader,'Color','k');
            set(PARAMS.fighandles.parmtxt.LowCutOff,'Color',program.fontcolor);
            set(PARAMS.fighandles.parmtxt.HighCutOff,'Color',program.fontcolor);
        case 'bandpass'
            set(PARAMS.fighandles.radio.tone,'value',0);
            set(PARAMS.fighandles.radio.tt,'value',0);
            set(PARAMS.fighandles.radio.bbn,'value',0);
            set(PARAMS.fighandles.radio.nn,'value',0);
            set(PARAMS.fighandles.radio.bpn,'value',1);
            
            PARAMS.fighandles.current.stimulus = 'bandpass';
            set(PARAMS.fighandles.parmtxt.FHeader,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.frequency,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.FHeader2,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.frequency2,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.AHeader2,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.attenuation2,'Color',[.8 .8 .8]);
            set(PARAMS.fighandles.parmtxt.LCHeader,'Color','k');
            set(PARAMS.fighandles.parmtxt.HCHeader,'Color','k');
            set(PARAMS.fighandles.parmtxt.LowCutOff,'Color',program.fontcolor);
            set(PARAMS.fighandles.parmtxt.HighCutOff,'Color',program.fontcolor);
    end
    set(gcf,'Userdata',struct('fighandles',PARAMS.fighandles));
    set(PARAMS.fighandles.push.save,'Userdata',3);
    
elseif strcmp(command,'halt')
    PARAMS = get(gcf,'Userdata');
    set(PARAMS.fighandles.push.save,'Userdata',1);
    
elseif strcmp(command,'save')
    PARAMS = get(gcf,'Userdata');
    set(PARAMS.fighandles.push.save,'Userdata',2);
end

