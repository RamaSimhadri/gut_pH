function varargout = gutUI(varargin)
% GUTUI MATLAB code for gutUI.fig
%      GUTUI, by itself, creates a new GUTUI or raises the existing
%      singleton*.
%
%      H = GUTUI returns the handle to a new GUTUI or the handle to
%      the existing singleton*.
%
%      GUTUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUTUI.M with the given input arguments.
%
%      GUTUI('Property','Value',...) creates a new GUTUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gutUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gutUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gutUI

% Last Modified by GUIDE v2.5 07-Oct-2016 16:43:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gutUI_OpeningFcn, ...
                   'gui_OutputFcn',  @gutUI_OutputFcn, ...
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


% --- Executes just before gutUI is made visible.
function gutUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gutUI (see VARARGIN)

% Choose default command line output for gutUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gutUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = gutUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%_______________________Listbox___________________________________________%

% --- Display all files in the directory
% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

%get the name of the selected file and update the edit1 handle
index_selected = get(hObject,'Value');
list = get(hObject,'String');
item_selected = list{index_selected}; 
set(handles.edit1,'String',item_selected);

%load the image selected, show on axes1, and pass it to handles.I
Ioriginal = imread(item_selected);
axes(handles.axes1);
imshow(Ioriginal);
handles.Ioriginal = Ioriginal;

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%_______________________Pushbutton________________________________________%

% --- Draw a polygon around the gut before the B&W thresholding. This will
% exclude the regions around the borders that can interfere with the B&W
% thresholding. 
% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Ioriginal = handles.Ioriginal;
[I] = outline_gut_region(Ioriginal);

handles.I = I;
axes(handles.axes2);
imshow(I);

guidata(hObject, handles);

% --- Continue without drawing a polygon around the gut
% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I = handles.Ioriginal;
handles.I = I;
axes(handles.axes2);
imshow(I);
guidata(hObject, handles);

% --- Show Folder Items call back
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load_listbox(pwd,handles);
guidata(hObject, handles);

% --- Reset B&W Threshold callback
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.slider1,'Value',0.74);

RGB_image = handles.I;
BWThreshold = get(handles.slider1,'Value');
Ibw = convert_RGB2BW(RGB_image,BWThreshold,handles);
axes(handles.axes2);
imshow(Ibw);
handles.Ibw = Ibw;

dispBWThreshold = num2str(BWThreshold);
set(handles.edit2,'String',dispBWThreshold);

guidata(hObject, handles);

% --- Draw a polygon to exclude the foregut and the hindgut, and get gut length callback
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Superimposes the B&W gut mask on to the original image to show the gut
%regions selected, creates a line passing through the center of the gut,
%and calculated the length of it

RGB_image = handles.I;
gut_mask = handles.gut_mask;
[gutlength, Iwithgutmask, Iwithgutcenterline] = gut_length(RGB_image,gut_mask,handles);
axes(handles.axes2);
imshow(Iwithgutmask);
axes(handles.axes3);
imshow(Iwithgutcenterline);
handles.Iwithgutcenterline = Iwithgutcenterline;
handles.Iwithgutmask = Iwithgutmask;

disp_gutlength = num2str(gutlength.Area);
set(handles.edit6,'String',disp_gutlength);

guidata(hObject, handles);

% --- Reset Pixel Threshold callback
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.slider2,'Value',1000);

pixel_Threshold = get(handles.slider2,'Value');
Ibw = handles.Ibw;
gut_mask = define_gut_mask(Ibw,pixel_Threshold,handles);
axes(handles.axes2);
imshow(gut_mask);
handles.gut_mask = gut_mask;

disp_pixel_Threshold = num2str(pixel_Threshold);
set(handles.edit3,'String',disp_pixel_Threshold);

guidata(hObject, handles);

% --- Analyze the length of all the hue regions
% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Iwithgutcenterline = handles.Iwithgutcenterline;
numhuebins = 100;
[hue_bin_lengths] = analyze_hue_bin_lengths(Iwithgutcenterline,numhuebins);
csvfile = 'hue_bin_lengths.csv';
write_to_file(hue_bin_lengths,csvfile);

guidata(hObject, handles);

% --- Reset Hue Bin Upper limit callback
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hue_upper_limit = 1;
hue_lower_limit = get(handles.slider4,'Value');
Iwithgutcenterline = handles.Iwithgutcenterline;
[huemask, Iwithgutcenterline_huemask, huelength] = hue_mask(Iwithgutcenterline,hue_upper_limit,hue_lower_limit,handles);
axes(handles.axes3);
imshow(Iwithgutcenterline_huemask);
handles.huemask = huemask;
handles.Iwithgutcenterline_huemask = Iwithgutcenterline_huemask;
handles.huelength = huelength;

disp_hue_upper_limit = num2str(hue_upper_limit);
set(handles.edit4,'String',disp_hue_upper_limit);
disp_hue_lower_limit = num2str(hue_lower_limit);
set(handles.edit5,'String',disp_hue_lower_limit);
disp_huelength = num2str(huelength);
set(handles.edit7,'String',disp_huelength);

set(handles.slider3,'Value',hue_upper_limit);
set(handles.slider4,'Value',hue_lower_limit);

guidata(hObject, handles);

% --- Reset Hue Bin Lower limit callback
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hue_upper_limit = get(handles.slider3,'Value');
hue_lower_limit = 0;
Iwithgutcenterline = handles.Iwithgutcenterline;
[huemask, Iwithgutcenterline_huemask, huelength] = hue_mask(Iwithgutcenterline,hue_upper_limit,hue_lower_limit,handles);
axes(handles.axes3);
imshow(Iwithgutcenterline_huemask);
handles.huemask = huemask;
handles.Iwithgutcenterline_huemask = Iwithgutcenterline_huemask;
handles.huelength = huelength;

disp_hue_upper_limit = num2str(hue_upper_limit);
set(handles.edit4,'String',disp_hue_upper_limit);
disp_hue_lower_limit = num2str(hue_lower_limit);
set(handles.edit5,'String',disp_hue_lower_limit);
disp_huelength = num2str(huelength);
set(handles.edit7,'String',disp_huelength);

set(handles.slider3,'Value',hue_upper_limit);
set(handles.slider4,'Value',hue_lower_limit);

guidata(hObject, handles);

%_______________________Preset Hue Pushbuttons____________________________%

% --- BB_Yellow
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hue_upper_limit = 0.3;
hue_lower_limit = 0.05;
Iwithgutcenterline = handles.Iwithgutcenterline;
[huemask, Iwithgutcenterline_huemask, huelength] = hue_mask(Iwithgutcenterline,hue_upper_limit,hue_lower_limit,handles);
axes(handles.axes3);
imshow(Iwithgutcenterline_huemask);
handles.huemask = huemask;
handles.Iwithgutcenterline_huemask = Iwithgutcenterline_huemask;
handles.huelength = huelength;

disp_hue_upper_limit = num2str(hue_upper_limit);
set(handles.edit4,'String',disp_hue_upper_limit);
disp_hue_lower_limit = num2str(hue_lower_limit);
set(handles.edit5,'String',disp_hue_lower_limit);
disp_huelength = num2str(huelength);
set(handles.edit7,'String',disp_huelength);

set(handles.slider3,'Value',hue_upper_limit);
set(handles.slider4,'Value',hue_lower_limit);

guidata(hObject, handles);

% --- BB_Blue
% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hue_upper_limit = 0.8;
hue_lower_limit = 0.6;
Iwithgutcenterline = handles.Iwithgutcenterline;
[huemask, Iwithgutcenterline_huemask, huelength] = hue_mask(Iwithgutcenterline,hue_upper_limit,hue_lower_limit,handles);
axes(handles.axes3);
imshow(Iwithgutcenterline_huemask);
handles.huemask = huemask;
handles.Iwithgutcenterline_huemask = Iwithgutcenterline_huemask;
handles.huelength = huelength;

disp_hue_upper_limit = num2str(hue_upper_limit);
set(handles.edit4,'String',disp_hue_upper_limit);
disp_hue_lower_limit = num2str(hue_lower_limit);
set(handles.edit5,'String',disp_hue_lower_limit);
disp_huelength = num2str(huelength);
set(handles.edit7,'String',disp_huelength);

set(handles.slider3,'Value',hue_upper_limit);
set(handles.slider4,'Value',hue_lower_limit);

guidata(hObject, handles);

% --- BB_transition from Yellow to Blue
% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hue_upper_limit = 0.6;
hue_lower_limit = 0.3;
Iwithgutcenterline = handles.Iwithgutcenterline;
[huemask, Iwithgutcenterline_huemask, huelength] = hue_mask(Iwithgutcenterline,hue_upper_limit,hue_lower_limit,handles);
axes(handles.axes3);
imshow(Iwithgutcenterline_huemask);
handles.huemask = huemask;
handles.Iwithgutcenterline_huemask = Iwithgutcenterline_huemask;
handles.huelength = huelength;

disp_hue_upper_limit = num2str(hue_upper_limit);
set(handles.edit4,'String',disp_hue_upper_limit);
disp_hue_lower_limit = num2str(hue_lower_limit);
set(handles.edit5,'String',disp_hue_lower_limit);
disp_huelength = num2str(huelength);
set(handles.edit7,'String',disp_huelength);

set(handles.slider3,'Value',hue_upper_limit);
set(handles.slider4,'Value',hue_lower_limit);

guidata(hObject, handles);


% --- PR_Orange
% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hue_upper_limit = 0.3;
hue_lower_limit = 0.1;
Iwithgutcenterline = handles.Iwithgutcenterline;
[huemask, Iwithgutcenterline_huemask, huelength] = hue_mask(Iwithgutcenterline,hue_upper_limit,hue_lower_limit,handles);
axes(handles.axes3);
imshow(Iwithgutcenterline_huemask);
handles.huemask = huemask;
handles.Iwithgutcenterline_huemask = Iwithgutcenterline_huemask;
handles.huelength = huelength;

disp_hue_upper_limit = num2str(hue_upper_limit);
set(handles.edit4,'String',disp_hue_upper_limit);
disp_hue_lower_limit = num2str(hue_lower_limit);
set(handles.edit5,'String',disp_hue_lower_limit);
disp_huelength = num2str(huelength);
set(handles.edit7,'String',disp_huelength);

set(handles.slider3,'Value',hue_upper_limit);
set(handles.slider4,'Value',hue_lower_limit);

guidata(hObject, handles);

% --- PR_Red
% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hue_upper_limit = 1;
hue_lower_limit = 0.8;
Iwithgutcenterline = handles.Iwithgutcenterline;
[huemask, Iwithgutcenterline_huemask, huelength] = hue_mask(Iwithgutcenterline,hue_upper_limit,hue_lower_limit,handles);
axes(handles.axes3);
imshow(Iwithgutcenterline_huemask);
handles.huemask = huemask;
handles.Iwithgutcenterline_huemask = Iwithgutcenterline_huemask;
handles.huelength = huelength;

disp_hue_upper_limit = num2str(hue_upper_limit);
set(handles.edit4,'String',disp_hue_upper_limit);
disp_hue_lower_limit = num2str(hue_lower_limit);
set(handles.edit5,'String',disp_hue_lower_limit);
disp_huelength = num2str(huelength);
set(handles.edit7,'String',disp_huelength);

set(handles.slider3,'Value',hue_upper_limit);
set(handles.slider4,'Value',hue_lower_limit);

guidata(hObject, handles);

% --- PR_transition from Orange to Red
% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hue_upper_limit = 0.1;
hue_lower_limit = 0.01;
Iwithgutcenterline = handles.Iwithgutcenterline;
[huemask, Iwithgutcenterline_huemask, huelength] = hue_mask(Iwithgutcenterline,hue_upper_limit,hue_lower_limit,handles);
axes(handles.axes3);
imshow(Iwithgutcenterline_huemask);
handles.huemask = huemask;
handles.Iwithgutcenterline_huemask = Iwithgutcenterline_huemask;
handles.huelength = huelength;

disp_hue_upper_limit = num2str(hue_upper_limit);
set(handles.edit4,'String',disp_hue_upper_limit);
disp_hue_lower_limit = num2str(hue_lower_limit);
set(handles.edit5,'String',disp_hue_lower_limit);
disp_huelength = num2str(huelength);
set(handles.edit7,'String',disp_huelength);

set(handles.slider3,'Value',hue_upper_limit);
set(handles.slider4,'Value',hue_lower_limit);

guidata(hObject, handles);


% --- BP_yellow
% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hue_upper_limit = 0.3;
hue_lower_limit = 0.05;
Iwithgutcenterline = handles.Iwithgutcenterline;
[huemask, Iwithgutcenterline_huemask, huelength] = hue_mask(Iwithgutcenterline,hue_upper_limit,hue_lower_limit,handles);
axes(handles.axes3);
imshow(Iwithgutcenterline_huemask);
handles.huemask = huemask;
handles.Iwithgutcenterline_huemask = Iwithgutcenterline_huemask;
handles.huelength = huelength;

disp_hue_upper_limit = num2str(hue_upper_limit);
set(handles.edit4,'String',disp_hue_upper_limit);
disp_hue_lower_limit = num2str(hue_lower_limit);
set(handles.edit5,'String',disp_hue_lower_limit);
disp_huelength = num2str(huelength);
set(handles.edit7,'String',disp_huelength);

set(handles.slider3,'Value',hue_upper_limit);
set(handles.slider4,'Value',hue_lower_limit);

guidata(hObject, handles);

% --- BP_Purple
% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% evendtata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hue_upper_limit = 0.8;
hue_lower_limit = 0.6;
Iwithgutcenterline = handles.Iwithgutcenterline;
[huemask, Iwithgutcenterline_huemask, huelength] = hue_mask(Iwithgutcenterline,hue_upper_limit,hue_lower_limit,handles);
axes(handles.axes3);
imshow(Iwithgutcenterline_huemask);
handles.huemask = huemask;
handles.Iwithgutcenterline_huemask = Iwithgutcenterline_huemask;
handles.huelength = huelength;

disp_hue_upper_limit = num2str(hue_upper_limit);
set(handles.edit4,'String',disp_hue_upper_limit);
disp_hue_lower_limit = num2str(hue_lower_limit);
set(handles.edit5,'String',disp_hue_lower_limit);
disp_huelength = num2str(huelength);
set(handles.edit7,'String',disp_huelength);

set(handles.slider3,'Value',hue_upper_limit);
set(handles.slider4,'Value',hue_lower_limit);

guidata(hObject, handles);

% --- BP_transition from Yellow to Purple
% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hue_upper_limit = 1;
hue_lower_limit = 0.8;
Iwithgutcenterline = handles.Iwithgutcenterline;
[huemask, Iwithgutcenterline_huemask, huelength] = hue_mask(Iwithgutcenterline,hue_upper_limit,hue_lower_limit,handles);
axes(handles.axes3);
imshow(Iwithgutcenterline_huemask);
handles.huemask = huemask;
handles.Iwithgutcenterline_huemask = Iwithgutcenterline_huemask;
handles.huelength = huelength;

disp_hue_upper_limit = num2str(hue_upper_limit);
set(handles.edit4,'String',disp_hue_upper_limit);
disp_hue_lower_limit = num2str(hue_lower_limit);
set(handles.edit5,'String',disp_hue_lower_limit);
disp_huelength = num2str(huelength);
set(handles.edit7,'String',disp_huelength);

set(handles.slider3,'Value',hue_upper_limit);
set(handles.slider4,'Value',hue_lower_limit);

guidata(hObject, handles);


% --- TB_Red
% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- TB_Yellow
% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- TB_Blue
% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- TB_transition from Red to Yellow
% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- TB_transition from Yellow to Blue
% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%_______________________Slider____________________________________________%

% --- B&W threshold slider
% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
RGB_image = handles.I;
BWThreshold = get(handles.slider1,'Value');
Ibw = convert_RGB2BW(RGB_image,BWThreshold,handles);
axes(handles.axes2);
imshow(Ibw);
handles.Ibw = Ibw;

dispBWThreshold = num2str(BWThreshold);
set(handles.edit2,'String',dispBWThreshold);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Pixel Threshold slider
% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% --- Executes during object creation, after setting all properties.

pixel_Threshold = get(handles.slider2,'Value');
Ibw = handles.Ibw;
gut_mask = define_gut_mask(Ibw,pixel_Threshold,handles);
axes(handles.axes2);
imshow(gut_mask);
handles.gut_mask = gut_mask;

disp_pixel_Threshold = num2str(pixel_Threshold);
set(handles.edit3,'String',disp_pixel_Threshold);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Hue Bin Upper limit callback
% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

hue_upper_limit = get(handles.slider3,'Value');
hue_lower_limit = get(handles.slider4,'Value');
Iwithgutcenterline = handles.Iwithgutcenterline;
[huemask, Iwithgutcenterline_huemask, huelength] = hue_mask(Iwithgutcenterline,hue_upper_limit,hue_lower_limit,handles);
axes(handles.axes3);
imshow(Iwithgutcenterline_huemask);
handles.huemask = huemask;
handles.Iwithgutcenterline_huemask = Iwithgutcenterline_huemask;
handles.huelength = huelength;

disp_hue_upper_limit = num2str(hue_upper_limit);
set(handles.edit4,'String',disp_hue_upper_limit);
disp_hue_lower_limit = num2str(hue_lower_limit);
set(handles.edit5,'String',disp_hue_lower_limit);
disp_huelength = num2str(huelength);
set(handles.edit7,'String',disp_huelength);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Hue Bin Lower limit callback
% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

hue_upper_limit = get(handles.slider3,'Value');
hue_lower_limit = get(handles.slider4,'Value');
Iwithgutcenterline = handles.Iwithgutcenterline;
[huemask, Iwithgutcenterline_huemask, huelength] = hue_mask(Iwithgutcenterline,hue_upper_limit,hue_lower_limit,handles);
axes(handles.axes3);
imshow(Iwithgutcenterline_huemask);
handles.huemask = huemask;
handles.Iwithgutcenterline_huemask = Iwithgutcenterline_huemask;
handles.huelength = huelength;

disp_hue_upper_limit = num2str(hue_upper_limit);
set(handles.edit4,'String',disp_hue_upper_limit);
disp_hue_lower_limit = num2str(hue_lower_limit);
set(handles.edit5,'String',disp_hue_lower_limit);
disp_huelength = num2str(huelength);
set(handles.edit7,'String',disp_huelength);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%_______________________Edit Text_________________________________________%

% --- Current file selected callback
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

% --- Executes during object creation, after setting all properties.
guidata(hObject, handles);

function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- B&W Threshold Value callback
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

RGB_image = handles.I;
BWThresholdstring = get(handles.edit2,'String');
BWThreshold = str2num(BWThresholdstring);
Ibw = convert_RGB2BW(RGB_image,BWThreshold,handles);
axes(handles.axes2);
imshow(Ibw);
handles.Ibw = Ibw;

% dispBWThreshold = num2str(BWThreshold);
set(handles.slider1,'Value',BWThreshold);

guidata(hObject, handles);

function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Pixel Threshold Value callback
function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

Ibw = handles.Ibw;
pixel_Threshold_String = get(handles.edit3,'String');
pixel_Threshold = str2num(pixel_Threshold_String);
gut_mask = define_gut_mask(Ibw,pixel_Threshold,handles);
axes(handles.axes2);
imshow(gut_mask);
handles.gut_mask = gut_mask;

set(handles.slider2,'Value',pixel_Threshold);

guidata(hObject, handles);

function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Hue Bin Upper Bound callback
function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double

hue_upper_limit_str = get(handles.edit4,'String');
hue_upper_limit = str2num(hue_upper_limit_str);
hue_lower_limit_str = get(handles.edit5,'String');
hue_lower_limit = str2num(hue_lower_limit_str);
Iwithgutcenterline = handles.Iwithgutcenterline;
[huemask, Iwithgutcenterline_huemask, huelength] = hue_mask(Iwithgutcenterline,hue_upper_limit,hue_lower_limit,handles);
axes(handles.axes3);
imshow(Iwithgutcenterline_huemask);
handles.huemask = huemask;
handles.Iwithgutcenterline_huemask = Iwithgutcenterline_huemask;
handles.huelength = huelength;

set(handles.slider3,'Value',hue_upper_limit);
set(handles.slider4,'Value',hue_lower_limit);
disp_huelength = num2str(huelength);
set(handles.edit7,'String',disp_huelength);

guidata(hObject, handles);

function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Hue Bin Lower Bound callback
function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double

hue_upper_limit_str = get(handles.edit4,'String');
hue_upper_limit = str2num(hue_upper_limit_str);
hue_lower_limit_str = get(handles.edit5,'String');
hue_lower_limit = str2num(hue_lower_limit_str);
Iwithgutcenterline = handles.Iwithgutcenterline;
[huemask, Iwithgutcenterline_huemask, huelength] = hue_mask(Iwithgutcenterline,hue_upper_limit,hue_lower_limit,handles);
axes(handles.axes3);
imshow(Iwithgutcenterline_huemask);
handles.huemask = huemask;
handles.Iwithgutcenterline_huemask = Iwithgutcenterline_huemask;
handles.huelength = huelength;

set(handles.slider3,'Value',hue_upper_limit);
set(handles.slider4,'Value',hue_lower_limit);
disp_huelength = num2str(huelength);
set(handles.edit7,'String',disp_huelength);

guidata(hObject, handles);

function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Gut length callback
function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
guidata(hObject, handles);

function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Gut Hue length callback
function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
guidata(hObject, handles);

function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
