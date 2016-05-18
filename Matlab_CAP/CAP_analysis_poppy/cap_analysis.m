function varargout = cap_analysis(varargin)
% CAP_ANALYSIS M-file for cap_analysis.fig
%      CAP_ANALYSIS, by itself, creates a new CAP_ANALYSIS or raises the existing
%      singleton*.
%
%      H = CAP_ANALYSIS returns the handle to a new CAP_ANALYSIS or the handle to
%      the existing singleton*.
%
%      CAP_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAP_ANALYSIS.M with the given input arguments.
%
%      CAP_ANALYSIS('Property','Value',...) creates a new CAP_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cap_analysis_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cap_analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cap_analysis

% Last Modified by GUIDE v2.5 02-Mar-2007 14:50:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cap_analysis_OpeningFcn, ...
                   'gui_OutputFcn',  @cap_analysis_OutputFcn, ...
                   'gui_LayoutFcn',  @cap_analysis_LayoutFcn, ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before cap_analysis is made visible.
function cap_analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cap_analysis (see VARARGIN)
try
    handles.params = get_analysis_ins; %script creates struct Stimuli
catch
    instruct_error;
    handles.params = get_analysis_ins; %script creates struct Stimuli
end

handles.data_path = fullfile(fileparts(fileparts(fileparts(which('cap_analysis')))),'ExpData');
d = dir(handles.data_path);
d = d(find([d.isdir]==1 & strncmp('.',{d.name},1)==0)); % Only directories
folderlist = {d.name};
activefoldername = handles.params.dir;
activefoldernum = find(strcmp(handles.params.dir,{d.name})==1);
if isempty(activefoldernum)
    activefoldernum = 1;
end

set(handles.dir_txt,'String',{d.name},'Value',activefoldernum);

set(handles.cal_pic,'String',handles.params.cal_pic);
set(handles.abr_pic,'String',handles.params.abr_pic);
set(handles.start_resp,'String',handles.params.start_resp);
set(handles.window_resp,'String',handles.params.window_resp);
set(handles.start_back,'String',handles.params.start_back);
set(handles.window_back,'String',handles.params.window_back);
set(handles.scale,'String',handles.params.scale);

axes(handles.axes1);
handles.ax1.line1 = plot(0,0,'-','LineWidth',1,'Visible','off');
set(handles.ax1.line1,'Color',[0 0 0]);
hold on;
handles.ax1.line2 = plot(0,0,'o','Visible','off');
set(handles.ax1.line2,'Color',[.2 .2 .2]);
handles.ax1.line3 = plot(0,0,'--','LineWidth',1,'Visible','off');
set(handles.ax1.line3,'Color',[.2 .2 .2]);
handles.ax1.xlab = xlabel('Signal level (dB SPL)','FontSize',14);
handles.ax1.ylab = ylabel('CAP (\muVolts)','FontSize',14,'Interpreter','tex');
handles.ax1.title = title('CAP Analysis','FontSize',14);

axes(handles.axes2);
handles.rwins.rwin1 = plot(0,0,'-','LineWidth',1,'Visible','off');
set(handles.rwins.rwin1,'Color',[.2 .2 .2]);
hold on;
handles.bwins.bwin1 = plot(0,0,'-','LineWidth',1,'Visible','off');
set(handles.bwins.bwin1,'Color',[.2 .2 .2]);
handles.abrs.abr1 = plot(0,0,'-','LineWidth',1,'Visible','off');
set(handles.abrs.abr1,'Color',[0 0 0]);
for i = 2:20
    eval(['handles.rwins.rwin' num2str(i) ' = plot(0,0,''-'',''LineWidth'',1,''Visible'',''off'');']);
    eval(['set(handles.rwins.rwin' num2str(i) ',''Color'',[.2 .2 .2]);']);
    eval(['handles.bwins.bwin' num2str(i) ' = plot(0,0,''-'',''LineWidth'',1,''Visible'',''off'');']);
    eval(['set(handles.bwins.bwin' num2str(i) ',''Color'',[.2 .2 .2]);']);
    eval(['handles.abrs.abr' num2str(i) ' = plot(0,0,''-'',''LineWidth'',1,''Visible'',''off'');']);
    eval(['set(handles.abrs.abr' num2str(i) ',''Color'',[0 0 0]);']);
end
handles.ax2.xlab = xlabel('Time (msec)','FontSize',14);
handles.ax2.ylab = ylabel('Signal level (dB SPL)','FontSize',14,'Interpreter','tex');

% Choose default command line output for cap_analysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cap_analysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cap_analysis_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function dir_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dir_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dir_txt_Callback(hObject, eventdata, handles)
% hObject    handle to dir_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dir_txt as text
%        str2double(get(hObject,'String')) returns contents of dir_txt as a double
folders = get(handles.dir_txt,'String');
handles.params.dir = folders{get(handles.dir_txt,'Value')};
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function abr_pic_CreateFcn(hObject, eventdata, handles)
% hObject    handle to abr_pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function abr_pic_Callback(hObject, eventdata, handles)
% hObject    handle to abr_pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of abr_pic as text
%        str2double(get(hObject,'String')) returns contents of abr_pic as a double


% --- Executes during object creation, after setting all properties.
function start_resp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_resp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function start_resp_Callback(hObject, eventdata, handles)
% hObject    handle to start_resp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_resp as text
%        str2double(get(hObject,'String')) returns contents of start_resp as a double


% --- Executes during object creation, after setting all properties.
function window_resp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to window_resp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function window_resp_Callback(hObject, eventdata, handles)
% hObject    handle to window_resp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of window_resp as text
%        str2double(get(hObject,'String')) returns contents of window_resp as a double


% --- Executes during object creation, after setting all properties.
function start_back_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function start_back_Callback(hObject, eventdata, handles)
% hObject    handle to start_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_back as text
%        str2double(get(hObject,'String')) returns contents of start_back as a double


% --- Executes during object creation, after setting all properties.
function scale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function scale_Callback(hObject, eventdata, handles)
% hObject    handle to scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scale as text
%        str2double(get(hObject,'String')) returns contents of scale as a double


% --- Executes during object creation, after setting all properties.
function cal_pic_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cal_pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function cal_pic_Callback(hObject, eventdata, handles)
% hObject    handle to cal_pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cal_pic as text
%        str2double(get(hObject,'String')) returns contents of cal_pic as a double


% --- Executes during object creation, after setting all properties.
function window_back_CreateFcn(hObject, eventdata, handles)
% hObject    handle to window_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function window_back_Callback(hObject, eventdata, handles)
% hObject    handle to window_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of window_back as text
%        str2double(get(hObject,'String')) returns contents of window_back as a double


% --- Executes on button press in process.
function process_Callback(hObject, eventdata, handles)
% hObject    handle to process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[error] = thresh_calc(handles);
if isempty(error)
    update_params(handles);
end


% --- Executes on button press in savefile.
function savefile_Callback(hObject, eventdata, handles)
% hObject    handle to savefile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pic_dir = fullfile(handles.data_path,handles.params.dir);
if ~exist(fullfile(pic_dir,'pictures'))
    mkdir(pic_dir,'pictures');
end

filename = inputdlg('Name the file:','File Manager',1);
if isempty(filename)
    warndlg('File not saved.');
else
    pos = get(gcf,'Position');
    set(gcf,'PaperOrientation','Portrait','PaperPosition',[0 0 pos(3) pos(4)]);
    print('-deps',fullfile(pic_dir,'pictures',char(filename)));
    uiwait(msgbox('File has been saved.','File Manager','modal'));
end


% --- Executes on button press in print.
function print_Callback(hObject, eventdata, handles)
% hObject    handle to print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pos = get(gcf,'Position');
pos(1) = max(0,(11-pos(3))/2);
pos(2) = max(0,(8.5-pos(4))/2);

set(gcf,'PaperOrientation','Landscape','PaperPosition',pos);
if ispc
    print('-dwinc','-r200');
else
    print('-dpsc','-r200');
end




% --- Creates and returns a handle to the GUI figure. 
function h1 = cap_analysis_LayoutFcn(policy)
% policy - create a new figure or use a singleton. 'new' or 'reuse'.

persistent hsingleton;
if strcmpi(policy, 'reuse') & ishandle(hsingleton)
    h1 = hsingleton;
    return;
end

if ispc
    pos = [1 1 7 6];
else
    pos = [1 1 11 7];
end
h1 = figure(...
'Units','inches',...
'Color',[0.925490196078431 0.913725490196078 0.847058823529412],...
'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
'IntegerHandle','off',...
'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
'MenuBar','none',...
'Name','cap_analysis',...
'NumberTitle','off',...
'PaperPosition',get(0,'defaultfigurePaperPosition'),...
'Position',pos,...
'Renderer',get(0,'defaultfigureRenderer'),...
'RendererMode','manual',...
'Resize','off',...
'HandleVisibility','callback',...
'Tag','figure1',...
'UserData',zeros(1,0));

setappdata(h1, 'GUIDEOptions', struct(...
'active_h', 1.350005e+002, ...
'taginfo', struct(...
'figure', 2, ...
'axes', 3, ...
'edit', 9, ...
'text', 9, ...
'pushbutton', 4, ...
'listbox', 2), ...
'override', 0, ...
'release', 13, ...
'resize', 'none', ...
'accessibility', 'callback', ...
'mfile', 1, ...
'callbacks', 1, ...
'singleton', 1, ...
'syscolorfig', 1, ...
'lastSavedFile', 'C:\Documents and Settings\CAP\My Documents\Matlab_CAP\CAP_analysis\cap_analysis.m'));


h2 = axes(...
'Parent',h1,...
'Units','characters',...
'Box','on',...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',[1 1 1],...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'FontSize',8,...
'Position',[84.6 5.69230769230769 45.4 34.6923076923077],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','axes2');


h3 = get(h2,'title');

set(h3,...
'Parent',h2,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.5 1.01219512195122 1.00005459937205],...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h4 = get(h2,'xlabel');

set(h4,...
'Parent',h2,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.495594713656388 -0.0476718403547671 1.00005459937205],...
'VerticalAlignment','cap',...
'HandleVisibility','off');

h5 = get(h2,'ylabel');

set(h5,...
'Parent',h2,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[-0.112334801762115 0.497782705099778 1.00005459937205],...
'Rotation',90,...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h6 = get(h2,'zlabel');

set(h6,...
'Parent',h2,...
'Color',[0 0 0],...
'HorizontalAlignment','right',...
'Position',[-1.86563876651982 1.10975609756098 1.00005459937205],...
'HandleVisibility','off',...
'Visible','off');

h7 = axes(...
'Parent',h1,...
'Units','characters',...
'Box','on',...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',[1 1 1],...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'FontSize',8,...
'Position',[15 21.0769230769231 55 15.4615384615385],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','axes1');


h8 = get(h7,'title');

set(h8,...
'Parent',h7,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.5 1.0273631840796 1.00005459937205],...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h9 = get(h7,'xlabel');

set(h9,...
'Parent',h7,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.496363636363636 -0.106965174129353 1.00005459937205],...
'VerticalAlignment','cap',...
'HandleVisibility','off');

h10 = get(h7,'ylabel');

set(h10,...
'Parent',h7,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[-0.0927272727272727 0.495024875621891 1.00005459937205],...
'Rotation',90,...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h11 = get(h7,'zlabel');

set(h11,...
'Parent',h7,...
'Color',[0 0 0],...
'HorizontalAlignment','right',...
'Position',[-0.274545454545455 1.49502487562189 1.00005459937205],...
'HandleVisibility','off',...
'Visible','off');

h12 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','cap_analysis(''abr_pic_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[39.8 11.2307692307692 20.2 1.38461538461538],...
'String',{ 'Edit Text' },...
'Style','edit',...
'CreateFcn','cap_analysis(''abr_pic_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','abr_pic');


h13 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','cap_analysis(''start_resp_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[39.8 9.07692307692308 20.2 1.38461538461538],...
'String',{ 'Edit Text' },...
'Style','edit',...
'CreateFcn','cap_analysis(''start_resp_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','start_resp');


h14 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','cap_analysis(''window_resp_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[39.8 7.38461538461539 20.2 1.38461538461538],...
'String',{ 'Edit Text' },...
'Style','edit',...
'CreateFcn','cap_analysis(''window_resp_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','window_resp');


h15 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','cap_analysis(''start_back_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[39.8 5.23076923076923 20.2 1.38461538461538],...
'String',{ 'Edit Text' },...
'Style','edit',...
'CreateFcn','cap_analysis(''start_back_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','start_back');


h16 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','cap_analysis(''scale_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[39.8 1.38461538461538 20.2 1.38461538461538],...
'String',{ 'Edit Text' },...
'Style','edit',...
'CreateFcn','cap_analysis(''scale_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','scale');


h17 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'HorizontalAlignment','right',...
'ListboxTop',0,...
'Position',[10.8 15.3076923076923 17.6 1.53846153846154],...
'String','Directory',...
'Style','text',...
'Tag','text1');


h18 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'HorizontalAlignment','right',...
'ListboxTop',0,...
'Position',[12 8.76923076923077 25 1.46153846153846],...
'String',{ 'Response Start' '' },...
'Style','text',...
'Tag','text2');


h19 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'HorizontalAlignment','right',...
'ListboxTop',0,...
'Position',[12 7.23076923076923 25 1.46153846153846],...
'String',{ 'Response Window' '' },...
'Style','text',...
'Tag','text3');


h20 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'HorizontalAlignment','right',...
'ListboxTop',0,...
'Position',[12 4.84615384615385 25 1.46153846153846],...
'String',{ 'Background Start' '' },...
'Style','text',...
'Tag','text4');


h21 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'HorizontalAlignment','right',...
'ListboxTop',0,...
'Position',[12 3.23076923076923 25 1.46153846153846],...
'String',{ 'Background Window' '' },...
'Style','text',...
'Tag','text5');


h22 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'HorizontalAlignment','right',...
'ListboxTop',0,...
'Position',[12 1.07692307692308 25 1.46153846153846],...
'String',{ 'Maximum Scale' '' },...
'Style','text',...
'Tag','text6');


h23 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','cap_analysis(''cal_pic_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[39.8 12.9230769230769 20.2 1.38461538461538],...
'String',{ 'Edit Text' },...
'Style','edit',...
'CreateFcn','cap_analysis(''cal_pic_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','cal_pic');


h24 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'HorizontalAlignment','right',...
'ListboxTop',0,...
'Position',[12 12.5384615384615 25 1.46153846153846],...
'String','Calibration Pic',...
'Style','text',...
'Tag','text7');


h25 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','cap_analysis(''window_back_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[39.8 3.53846153846154 20.2 1.38461538461538],...
'String',{ 'Edit Text' },...
'Style','edit',...
'CreateFcn','cap_analysis(''window_back_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','window_back');


h26 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'HorizontalAlignment','right',...
'ListboxTop',0,...
'Position',[12 11 25 1.46153846153846],...
'String','Recording Pics',...
'Style','text',...
'Tag','text8');


h27 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','cap_analysis(''process_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[9.8 40.3076923076923 15.6 1.84615384615385],...
'String','Process',...
'Tag','process');


h28 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','cap_analysis(''savefile_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[54.4 40.3076923076923 15.6 1.84615384615385],...
'String','File',...
'Tag','savefile');


h29 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','cap_analysis(''print_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[31.8 40.3076923076923 15.6 1.84615384615385],...
'String','Print',...
'Tag','print');


h30 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','cap_analysis(''dir_txt_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[29.8 15.1538461538462 30.2 1.76923076923077],...
'String','Directory Name',...
'Style','popupmenu',...
'Value',1,...
'CreateFcn','cap_analysis(''dir_txt_CreateFcn'',gcbo,[],guidata(gcbo))',...
'Tag','dir_txt');



hsingleton = h1;


% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)


%   GUI_MAINFCN provides these command line APIs for dealing with GUIs
%
%      CAP_ANALYSIS, by itself, creates a new CAP_ANALYSIS or raises the existing
%      singleton*.
%
%      H = CAP_ANALYSIS returns the handle to a new CAP_ANALYSIS or the handle to
%      the existing singleton*.
%
%      CAP_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAP_ANALYSIS.M with the given input arguments.
%
%      CAP_ANALYSIS('Property','Value',...) creates a new CAP_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".

%   Copyright 1984-2002 The MathWorks, Inc.
%   $Revision: 1.4 $ $Date: 2002/05/31 21:44:31 $

gui_StateFields =  {'gui_Name'
                    'gui_Singleton'
                    'gui_OpeningFcn'
                    'gui_OutputFcn'
                    'gui_LayoutFcn'
                    'gui_Callback'};
gui_Mfile = '';
for i=1:length(gui_StateFields)
    if ~isfield(gui_State, gui_StateFields{i})
        error('Could not find field %s in the gui_State struct in GUI M-file %s', gui_StateFields{i}, gui_Mfile);        
    elseif isequal(gui_StateFields{i}, 'gui_Name')
        gui_Mfile = [getfield(gui_State, gui_StateFields{i}), '.m'];
    end
end

numargin = length(varargin);

if numargin == 0
    % CAP_ANALYSIS
    % create the GUI
    gui_Create = 1;
elseif numargin > 3 & ischar(varargin{1}) & ishandle(varargin{2})
    % CAP_ANALYSIS('CALLBACK',hObject,eventData,handles,...)
    gui_Create = 0;
else
    % CAP_ANALYSIS(...)
    % create the GUI and hand varargin to the openingfcn
    gui_Create = 1;
end

if gui_Create == 0
    varargin{1} = gui_State.gui_Callback;
    if nargout
        [varargout{1:nargout}] = feval(varargin{:});
    else
        feval(varargin{:});
    end
else
    if gui_State.gui_Singleton
        gui_SingletonOpt = 'reuse';
    else
        gui_SingletonOpt = 'new';
    end
    
    % Open fig file with stored settings.  Note: This executes all component
    % specific CreateFunctions with an empty HANDLES structure.
    
    % Do feval on layout code in m-file if it exists
    if ~isempty(gui_State.gui_LayoutFcn)
        gui_hFigure = feval(gui_State.gui_LayoutFcn, gui_SingletonOpt);
    else
        gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt);            
        % If the figure has InGUIInitialization it was not completely created
        % on the last pass.  Delete this handle and try again.
        if isappdata(gui_hFigure, 'InGUIInitialization')
            delete(gui_hFigure);
            gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt);            
        end
    end
    
    % Set flag to indicate starting GUI initialization
    setappdata(gui_hFigure,'InGUIInitialization',1);

    % Fetch GUIDE Application options
    gui_Options = getappdata(gui_hFigure,'GUIDEOptions');
    
    if ~isappdata(gui_hFigure,'GUIOnScreen')
        % Adjust background color
        if gui_Options.syscolorfig 
            set(gui_hFigure,'Color', get(0,'DefaultUicontrolBackgroundColor'));
        end

        % Generate HANDLES structure and store with GUIDATA
        guidata(gui_hFigure, guihandles(gui_hFigure));
    end
    
    % If user specified 'Visible','off' in p/v pairs, don't make the figure
    % visible.
    gui_MakeVisible = 1;
    for ind=1:2:length(varargin)
        if length(varargin) == ind
            break;
        end
        len1 = min(length('visible'),length(varargin{ind}));
        len2 = min(length('off'),length(varargin{ind+1}));
        if ischar(varargin{ind}) & ischar(varargin{ind+1}) & ...
                strncmpi(varargin{ind},'visible',len1) & len2 > 1
            if strncmpi(varargin{ind+1},'off',len2)
                gui_MakeVisible = 0;
            elseif strncmpi(varargin{ind+1},'on',len2)
                gui_MakeVisible = 1;
            end
        end
    end
    
    % Check for figure param value pairs
    for index=1:2:length(varargin)
        if length(varargin) == index
            break;
        end
        try, set(gui_hFigure, varargin{index}, varargin{index+1}), catch, break, end
    end

    % If handle visibility is set to 'callback', turn it on until finished
    % with OpeningFcn
    gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
    if strcmp(gui_HandleVisibility, 'callback')
        set(gui_hFigure,'HandleVisibility', 'on');
    end
    
    feval(gui_State.gui_OpeningFcn, gui_hFigure, [], guidata(gui_hFigure), varargin{:});
    
    if ishandle(gui_hFigure)
        % Update handle visibility
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
        
        % Make figure visible
        if gui_MakeVisible
            set(gui_hFigure, 'Visible', 'on')
            if gui_Options.singleton 
                setappdata(gui_hFigure,'GUIOnScreen', 1);
            end
        end

        % Done with GUI initialization
        rmappdata(gui_hFigure,'InGUIInitialization');
    end
    
    % If handle visibility is set to 'callback', turn it on until finished with
    % OutputFcn
    if ishandle(gui_hFigure)
        gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
        if strcmp(gui_HandleVisibility, 'callback')
            set(gui_hFigure,'HandleVisibility', 'on');
        end
        gui_Handles = guidata(gui_hFigure);
    else
        gui_Handles = [];
    end
    
    if nargout
        [varargout{1:nargout}] = feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    else
        feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    end
    
    if ishandle(gui_hFigure)
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
    end
end    

function gui_hFigure = local_openfig(name, singleton)
if nargin('openfig') == 3 
    gui_hFigure = openfig(name, singleton, 'auto');
else
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    gui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = openfig(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
end

