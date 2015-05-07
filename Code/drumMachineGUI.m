function varargout = drumMachineGUI(varargin)
% DRUMMACHINEGUI MATLAB code for drumMachineGUI.fig
%      DRUMMACHINEGUI, by itself, creates a new DRUMMACHINEGUI or raises the existing
%      singleton*.
%
%      H = DRUMMACHINEGUI returns the handle to a new DRUMMACHINEGUI or the handle to
%      the existing singleton*.
%
%      DRUMMACHINEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DRUMMACHINEGUI.M with the given input arguments.
%
%      DRUMMACHINEGUI('Property','Value',...) creates a new DRUMMACHINEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before drumMachineGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to drumMachineGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help drumMachineGUI

% Last Modified by GUIDE v2.5 04-May-2015 16:12:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @drumMachineGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @drumMachineGUI_OutputFcn, ...
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


% --- Executes just before drumMachineGUI is made visible.
function drumMachineGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to drumMachineGUI (see VARARGIN)

% Choose default command line output for drumMachineGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes drumMachineGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = drumMachineGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
