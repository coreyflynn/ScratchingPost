function varargout = uiinfer_tool(varargin)
% UIINFER_TOOL MATLAB code for uiinfer_tool.fig
%      UIINFER_TOOL, by itself, creates a new UIINFER_TOOL or raises the existing
%      singleton*.
%
%      H = UIINFER_TOOL returns the handle to a new UIINFER_TOOL or the handle to
%      the existing singleton*.
%
%      UIINFER_TOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UIINFER_TOOL.M with the given input arguments.
%
%      UIINFER_TOOL('Property','Value',...) creates a new UIINFER_TOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before uiinfer_tool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to uiinfer_tool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help uiinfer_tool

% Last Modified by GUIDE v2.5 23-Aug-2011 15:17:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uiinfer_tool_OpeningFcn, ...
                   'gui_OutputFcn',  @uiinfer_tool_OutputFcn, ...
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


% --- Executes just before uiinfer_tool is made visible.
function uiinfer_tool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to uiinfer_tool (see VARARGIN)

% Choose default command line output for uiinfer_tool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes uiinfer_tool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = uiinfer_tool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function inputEdit_Callback(hObject, eventdata, handles)
% hObject    handle to inputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputEdit as text
%        str2double(get(hObject,'String')) returns contents of inputEdit as a double


% --- Executes during object creation, after setting all properties.
function inputEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function outputEdit_Callback(hObject, eventdata, handles)
% hObject    handle to outputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outputEdit as text
%        str2double(get(hObject,'String')) returns contents of outputEdit as a double


% --- Executes during object creation, after setting all properties.
function outputEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in inputPush.
function inputPush_Callback(hObject, eventdata, handles)
[gctFile,gctPath] = uigetfile([pwd '/*.gct'],'Select input gct file');
inputGCT = [gctPath gctFile];
set(handles.inputEdit,'String',inputGCT);
handles.inputGCT = inputGCT;
guidata(hObject, handles);



% --- Executes on selection change in modelPopup.
function modelPopup_Callback(hObject, eventdata, handles)
% hObject    handle to modelPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns modelPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from modelPopup


% --- Executes during object creation, after setting all properties.
function modelPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modelPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ouputPush.
function ouputPush_Callback(hObject, eventdata, handles)
outputDir = uigetdir([pwd '/*.gct'],'Select output directory');
set(handles.outputEdit,'String',outputDir);
handles.outputDir = outputDir;
guidata(hObject,handles);


% --- Executes on button press in runPush.
function runPush_Callback(hObject, eventdata, handles)
inferenceBasePath = '/xchip/cogs/cflynn/InferenceEval';

modelList = get(handles.modelPopup,'String');
modelVal = get(handles.modelPopup,'Value');
selectedModel = modelList{modelVal};

inputFile = get(handles.inputEdit,'String');
outputDir = get(handles.outputEdit,'String');
infer_tool('res',inputFile,...
            'model',sprintf('%s/%s/%s.mat',inferenceBasePath,selectedModel,selectedModel),...
            'out',outputDir);
        

