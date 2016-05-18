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

% Last Modified by GUIDE v2.5 02-Mar-2007 09:22:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cap_analysis_OpeningFcn, ...
                   'gui_OutputFcn',  @cap_analysis_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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
    set(gcf,'PaperOrientation','Portrait','PaperPosition',[0 0 11 8.5]);
    print('-deps',fullfile(pic_dir,'pictures',char(filename)));
    uiwait(msgbox('File has been saved.','File Manager','modal'));
end


% --- Executes on button press in print.
function print_Callback(hObject, eventdata, handles)
% hObject    handle to print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ispc
    print('-dwinc','-r200');
else
    print('-dpsc','-r200');
end


