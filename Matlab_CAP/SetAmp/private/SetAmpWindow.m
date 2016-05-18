function SetAmpWindow

%This program is used to set the voltage on free-field amplifiers.

global program root_dir COMM

radio = cell2struct(cell(1,8),{'standard','target','background','tone','bbn','nn','bpn','tt'},2);
push = cell2struct(cell(1,3),{'save','edit','cal'},2);
parmtxt = cell2struct(cell(1,13),{'FHeader','HCHeader2','AHeader','AHeader2', ...
        'LCHeader','HCHeader','RMS','frequency','frequency2','attenuation','attenuation2','LowCutOff','HighCutOff'},2);
current = cell2struct(cell(1,4),{'source','channel','atten','stimulus'},2);

FIG_amp  = struct('handle',[],'push',push,'parmtxt',parmtxt,'current',current);

FIG_amp.handle = figure('NumberTitle','off','Name','Amp Interface','Units','normalized', ...
    'position',[.35 .25 .3 .5],'CloseRequestFcn','SetAmp(''halt'');','Visible','off');
colordef none;
whitebg('w');

axes('position',[0 0 1 1]);
axis off;
box on;

FIG_amp.radio.standard    = uicontrol(FIG_amp.handle,'callback','SetAmp(''restart'',''standard'');', ...
    'style','radio','Units','normalized','position',[.6 .725 .4 .05],'string','Standard',  'Value',0, ...
    'Enable','off','fontname','helvetica','fontsize',10,'backgroundcolor','w');
FIG_amp.radio.target      = uicontrol(FIG_amp.handle,'callback','SetAmp(''restart'',''target'');', ...
    'style','radio','Units','normalized','position',[.6 .675 .4 .05],'string','Target',    'Value',1, ...
    'Enable','off','fontname','helvetica','fontsize',10,'backgroundcolor','w');
FIG_amp.radio.background  = uicontrol(FIG_amp.handle,'callback','SetAmp(''restart'',''background'');', ...
    'style','radio','Units','normalized','position',[.6 .625 .4 .05],'string','Background','Value',0, ...
    'Enable','off','fontname','helvetica','fontsize',10,'backgroundcolor','w');
FIG_amp.radio.tone        = uicontrol(FIG_amp.handle,'callback','SetAmp(''restart'',''tone'');', ...
    'style','radio','Units','normalized','position',[.15 .75 .4 .05],'string','Tone',      'Value',1, ...
    'fontname','helvetica','fontsize',10,'backgroundcolor','w');
FIG_amp.radio.bbn         = uicontrol(FIG_amp.handle,'callback','SetAmp(''restart'',''broadband'');', ...
    'style','radio','Units','normalized','position',[.15 .7 .4 .05],'string','Broadband', 'Value',0, ...
    'fontname','helvetica','fontsize',10,'backgroundcolor','w');
FIG_amp.radio.nn          = uicontrol(FIG_amp.handle,'callback','SetAmp(''restart'',''notched'');', ...
    'style','radio','Units','normalized','position',[.15 .65 .4 .05],'string','Notched',   'Value',0, ...
    'fontname','helvetica','fontsize',10,'backgroundcolor','w');
FIG_amp.radio.bpn         = uicontrol(FIG_amp.handle,'callback','SetAmp(''restart'',''bandpass'');', ...
    'style','radio','Units','normalized','position',[.15 .6 .4 .05],'string','Bandpass',  'Value',0, ...
    'fontname','helvetica','fontsize',10,'backgroundcolor','w');
FIG_amp.radio.tt          = uicontrol(FIG_amp.handle,'callback','SetAmp(''restart'',''tt'');', ...
    'style','radio','Units','normalized','position',[.15 .55 .4 .05],'string','2Tone',  'Value',0, ...
    'fontname','helvetica','fontsize',10,'backgroundcolor','w');

FIG_amp.push.save         = uicontrol(FIG_amp.handle,'callback','SetAmp(''save'');','style','pushbutton','Enable','on','Userdata',0,'Units','normalized','position',[.2 .85 .6 .075],'string','Save','fontsize',12);
FIG_amp.push.edit         = uicontrol(FIG_amp.handle,'style','edit','Units','normalized','position',[.2 .05 .6 .075],'string',[],'FontSize',12);

text(.2,.5,'RMS (volts):','fontsize',14,'horizontalalignment','left');
FIG_amp.parmtxt.FHeader  = text(.2,.43,'Frequency (Hz):','horizontalalignment','left');
FIG_amp.parmtxt.FHeader2 = text(.2,.39,'Frequency2 (Hz):','horizontalalignment','left');
FIG_amp.parmtxt.AHeader  = text(.2,.33,'Attenuation (dB):','horizontalalignment','left');
FIG_amp.parmtxt.AHeader2 = text(.2,.29,'Attenuation2 (dB):','horizontalalignment','left');
FIG_amp.parmtxt.LCHeader = text(.2,.23,'Low Cutoff (Hz):','color',[.8 .8 .8],'horizontalalignment','left');
FIG_amp.parmtxt.HCHeader = text(.2,.19,'High Cutoff (Hz):','color',[.8 .8 .8],'horizontalalignment','left');

FIG_amp.parmtxt.RMS = text(.8,.5,'0.00','fontsize',14, ...
    'color','r','horizontalalignment','right');
FIG_amp.parmtxt.frequency = text(.8,.43,num2str(program.configuration.frequency), ...
    'color',program.fontcolor,'horizontalalignment','right', ...
    'buttondownfcn','SetAmp(''frequency'');');
FIG_amp.parmtxt.frequency2 = text(.8,.39,num2str(program.configuration.frequency2), ...
    'color',[.8 .8 .8],'horizontalalignment','right', ...
    'buttondownfcn','SetAmp(''frequency2'');');
FIG_amp.parmtxt.attenuation = text(.8,.33,num2str(program.configuration.attenuation), ...
    'color',program.fontcolor,'horizontalalignment','right', ...
    'buttondownfcn','SetAmp(''attenuation'');');
FIG_amp.parmtxt.attenuation2 = text(.8,.29,num2str(program.configuration.attenuation2), ...
    'color',[.8 .8 .8],'horizontalalignment','right', ...
    'buttondownfcn','SetAmp(''attenuation2'');');
FIG_amp.parmtxt.LowCutOff = text(.8,.23,num2str(program.configuration.LowCutOff), ...
    'color',[.8 .8 .8],'horizontalalignment','right', ...
    'buttondownfcn','SetAmp(''LowCutOff'');');
FIG_amp.parmtxt.HighCutOff = text(.8,.19,num2str(program.configuration.HighCutOff), ...
    'color',[.8 .8 .8],'horizontalalignment','right', ...
    'buttondownfcn','SetAmp(''HighCutOff'');');

FIG_amp.current.source = program.configuration.Target.Source;
FIG_amp.current.channel = program.configuration.Target.Channel;
FIG_amp.current.atten = program.configuration.Target.AttenNum;
FIG_amp.current.stimulus = 'tone';

set(FIG_amp.handle,'Userdata',struct('fighandles',FIG_amp));
set(FIG_amp.handle,'Visible','on');
