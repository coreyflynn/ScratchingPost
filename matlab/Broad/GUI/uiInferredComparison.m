function varargout = uiInferredComparison(varargin)
% UIINFERREDCOMPARISON MATLAB code for uiInferredComparison.fig
%      UIINFERREDCOMPARISON, by itself, creates a new UIINFERREDCOMPARISON or raises the existing
%      singleton*.
%
%      H = UIINFERREDCOMPARISON returns the handle to a new UIINFERREDCOMPARISON or the handle to
%      the existing singleton*.
%
%      UIINFERREDCOMPARISON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UIINFERREDCOMPARISON.M with the given input arguments.
%
%      UIINFERREDCOMPARISON('Property','Value',...) creates a new UIINFERREDCOMPARISON or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before uiInferredComparison_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to uiInferredComparison_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help uiInferredComparison

% Last Modified by GUIDE v2.5 18-Aug-2011 15:39:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uiInferredComparison_OpeningFcn, ...
                   'gui_OutputFcn',  @uiInferredComparison_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before uiInferredComparison is made visible.
function uiInferredComparison_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to uiInferredComparison (see VARARGIN)

% Choose default command line output for uiInferredComparison
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes uiInferredComparison wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = uiInferredComparison_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function input_edit_Callback(hObject, eventdata, handles)
handles.gctFilePath = get(handles.input_edit,'String');
guidata(hObject, handles);
% hObject    handle to input_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_edit as text
%        str2double(get(hObject,'String')) returns contents of input_edit as a double


% --- Executes during object creation, after setting all properties.
function input_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function output_edit_Callback(hObject, eventdata, handles)
handles.outputDir = get(handles.output_edit,'String');
guidata(hObject, handles);
% hObject    handle to output_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of output_edit as text
%        str2double(get(hObject,'String')) returns contents of output_edit as a double


% --- Executes during object creation, after setting all properties.
function output_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to output_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
[gctFile,gctPath] = uigetfile([pwd '/*.gct'],'Select observed data gct file');
handles.gctFilePath = [gctPath gctFile];
set(handles.input_edit,'String',handles.gctFilePath);
guidata(hObject, handles);
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
outputDir = uigetdir(pwd,'Select output folder');
handles.outputDir = outputDir;
set(handles.output_edit,'String',handles.outputDir);
guidata(hObject,handles);
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
inferredComparison(handles.gctFilePath,handles.outputDir);
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
