% Script to create gain vs freq plot for signal averager

%pushbuttons switch control to test, simulate, calibrate and analyses functions
FIG.push.stop   = uicontrol(FIG.handle,'callback','cap(''stop'');','style','pushbutton','Enable','off','Units','normalized','position',[.44 .23 .125 .075],'string','Stop','Userdata',[],'fontsize',12,'fontangle','normal','fontweight','normal');
FIG.push.print  = uicontrol(FIG.handle,'callback','cap(''print'');','style','pushbutton','Units','normalized','position',[.44 .05 .125 .05],'string','Print','Userdata',[],'fontsize',12,'fontangle','normal','fontweight','normal');
FIG.push.aver   = uicontrol(FIG.handle,'callback','cap(''average'');','style','pushbutton','Interruptible','on','Units','normalized','position',[.625 .238 .25 .062],'string','Average','Userdata',[],'fontsize',14,'fontangle','normal','fontweight','normal');
FIG.push.params = uicontrol(FIG.handle,'callback','cap(''params'');','style','pushbutton','Units','normalized','position',[.125 .238 .25 .062],'string','Parameters','fontsize',14,'fontangle','normal','fontweight','normal');
FIG.push.recall = uicontrol(FIG.handle,'callback','cap(''recall'');','style','pushbutton','Units','normalized','position',[.44 .17 .125 .05],'string','Recall','fontsize',12,'fontangle','normal','fontweight','normal');
FIG.push.mag    = uicontrol(FIG.handle,'callback','cap(''mag'');','style','pushbutton','Units','normalized','position',[.44 .11 .125 .05],'string','Zoom In','Userdata',0,'fontsize',12,'fontangle','normal','fontweight','normal');
FIG.push.edit   = uicontrol(FIG.handle,'style','edit','Units','normalized','position',[.265 .08 .1 .04],'string',[],'FontSize',12);								

FIG.ax1.axes = axes('position',[.1 .4 .8 .5]);
FIG.ax1.line1 = plot(0,0);
set(FIG.ax1.line1,'Color',[.1 .1 .6],'LineWidth',2,'EraseMode','xor');
axis([0 Stimuli.record_duration -3.5 3.5]);
%set(FIG.ax1.axes,'XTick',[0:5:100],'FontSize',12);
set(FIG.ax1.axes,'YTick',[-3.5 0 3.5],'FontSize',12);
ylabel('Amplitude (\muVolts)','fontsize',18,'fontangle','normal','fontweight','normal','Interpreter','tex');	%label y axis

FIG.ax2.axes = axes('position',[.6 .048 .3 .27]);
axis([0 1 0 1]);
set(FIG.ax2.axes,'XTick',[]);
set(FIG.ax2.axes,'YTick',[]);
box on;

fnum = NelData.General.fnum +1;
FIG.ax2.ProgHead = text(.45,3.5,{'Program:' 'Date:' 'Pic#:'},'fontsize',12,'verticalalignment','top','horizontalalignment','left');
FIG.ax2.ProgData = text(1,3.5,{PROG.name PROG.date fnum},'fontsize',12,'color',[.1 .1 .6],'verticalalignment','top','horizontalalignment','right');
FIG.ax2.ProgMess = text(.5,.5,'Push to begin averaging...','fontsize',12,'fontangle','normal','fontweight','normal','color',[.6 .1 .1],'verticalalignment','middle','horizontalalignment','center','EraseMode','normal');
text(-.34,1.14,'Time (msec)','fontsize',18,'fontangle','normal','fontweight','normal','Horiz','center');
FIG.ax3.axes = axes('position',[ .1 .048 .3 .27]);
axis([0 1 0 1]);
set(FIG.ax3.axes,'XTick',[]);
set(FIG.ax3.axes,'YTick',[]);
box on;

if Stimuli.freq_hz == 0,
    stim_txt = 'click';
else
    stim_txt = num2str(Stimuli.freq_hz);
end

FIG.ax3.ParamHead1 = text(.1,.65,'Masker','fontsize',12,'fontweight','bold','verticalalignment','top','horizontalalignment','left');
FIG.ax3.ParamHead2 = text(.55,.65,'Signal','fontsize',12,'fontweight','bold','verticalalignment','top','horizontalalignment','left');
FIG.ax3.ParamHead3 = text(.1,.55,{'Freq (Hz):' 'Delay (ms):' 'Atten (dB)'},'fontsize',9,'verticalalignment','top','horizontalalignment','left');
if isnan(Stimuli.masker_freq_hz)
    FIG.ax3.ParamData3 = text(.47,.55,{'not used'},'fontsize',9,'color',[.8 .8 .8],'verticalalignment','top','horizontalalignment','right','buttondownfcn','cap(''masker_freq_hz'');');
    FIG.ax3.ParamData4 = text(.47,.47,{'not used'},'fontsize',9,'color',[.8 .8 .8],'verticalalignment','top','horizontalalignment','right','buttondownfcn','cap(''masker_delay_ms'');');
    FIG.ax3.ParamData5 = text(.47,.39,{'not used'},'fontsize',9,'color',[.8 .8 .8],'verticalalignment','top','horizontalalignment','right','buttondownfcn','cap(''masker_db_atten'');');
else
    FIG.ax3.ParamData3 = text(.47,.55,{Stimuli.masker_freq_hz},'fontsize',9,'color',[.1 .1 .6],'verticalalignment','top','horizontalalignment','right','buttondownfcn','cap(''masker_freq_hz'');');
    FIG.ax3.ParamData4 = text(.47,.47,{Stimuli.masker_delay_ms},'fontsize',9,'color',[.1 .1 .6],'verticalalignment','top','horizontalalignment','right','buttondownfcn','cap(''masker_delay_ms'');');
    FIG.ax3.ParamData5 = text(.47,.39,{Stimuli.masker_db_atten},'fontsize',9,'color',[.1 .1 .6],'verticalalignment','top','horizontalalignment','right','buttondownfcn','cap(''masker_db_atten'');');
end
FIG.ax3.ParamHead4 = text(.55,.55,{'Freq (Hz):' 'Atten (dB)'},'fontsize',9,'verticalalignment','top','horizontalalignment','left');
FIG.ax3.ParamData1 = text(.92,.55,{stim_txt},'fontsize',9,'color',[.1 .1 .6],'verticalalignment','top','horizontalalignment','right','buttondownfcn','cap(''stimulus'');');
FIG.ax3.ParamData2 = text(.92,.47,{Stimuli.db_atten},'fontsize',9,'color',[.1 .1 .6],'verticalalignment','top','horizontalalignment','right','buttondownfcn','cap(''attenuation'');');

set(FIG.handle,'Userdata',struct('handles',FIG));