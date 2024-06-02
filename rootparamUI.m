function varargout = rootparamUI(varargin)
% ROOTPARAMUI MATLAB code for rootparamUI.fig
%      ROOTPARAMUI, by itself, creates a new ROOTPARAMUI or raises the existing
%      singleton*.
%
%      H = ROOTPARAMUI returns the handle to a new ROOTPARAMUI or the handle to
%      the existing singleton*.
%
%      ROOTPARAMUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROOTPARAMUI.M with the given input arguments.
%
%      ROOTPARAMUI('Property','Value',...) creates a new ROOTPARAMUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rootparamUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rootparamUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rootparamUI


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rootparamUI_OpeningFcn, ...
                   'gui_OutputFcn',  @rootparamUI_OutputFcn, ...
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


% --- Executes just before rootparamUI is made visible.
function rootparamUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rootparamUI (see VARARGIN)

h = handles;

set(0,'RecursionLimit',10000); % just to be sure

% Choose default command line output for GUI_Practice
h.output = hObject;

% get paramters
if isempty(varargin)
    p_{1} = struct('r',2,'a',0.1,'theta',70,'lb',1,'la',7,'ln',1,'nob',10,...
        'color',[0,1,0],'dx',0.25,'name','Root');        
else
    p_{1} = varargin{1}; 
    p_{1}.theta = round(p_{1}.theta/pi*180); % convert to degree    
end
p_=completeParameters(p_);
p = p_{1};

if length(varargin)==2
    typ = varargin{2};
    if strcmp(typ,'tap')
        p.theta = [0,0];
        set(h.text7,'Enable','off');
        set(h.edit3,'Enable','off');
        set(h.edit12,'Enable','off');
        set(h.text18,'Enable','off');        
    elseif strcmp(typ,'nobranches')
        p.nob = [0 0];       
        set(h.popupmenu1,'Value',2);
        set(h.popupmenu1,'Enable','off');
    end
end

% extract relevant
h.default = [p.r(1) p.r(2); p.a(1) p.a(2); p.theta(1), p.theta(2); ...
    p.lb(1) p.lb(2); p.la(1) p.la(2); p.ln(1) p.ln(2); p.nob(1) p.nob(2), ];
h.defaultTrop = p.tropism;

% store data
h.press = 'cancel';
h.parameters = p;
h.data = h.default;
h.tropism = h.defaultTrop;
d = h.data;

% update gui
if (p.nob(1)~=0)||(p.nob(2)~=0);
    set(h.popupmenu1,'Value',1);
else
    set(h.popupmenu1,'Value',2);
end

% Mean
set(h.edit1, 'String', num2str(d(1,1)));
set(h.edit2, 'String', num2str(d(2,1)));
set(h.edit3, 'String', num2str(d(3,1)));
set(h.edit5, 'String', num2str(d(4,1)));
set(h.edit6, 'String', num2str(d(5,1)));
set(h.edit7, 'String', num2str(d(6,1)));
set(h.edit4, 'String', num2str(d(7,1)));
% SD
set(h.edit10, 'String', num2str(d(1,2)));
set(h.edit11, 'String', num2str(d(2,2)));
set(h.edit12, 'String', num2str(d(3,2)));
set(h.edit14, 'String', num2str(d(4,2)));
set(h.edit15, 'String', num2str(d(5,2)));
set(h.edit16, 'String', num2str(d(6,2)));
set(h.edit13, 'String', num2str(d(7,2)));
% k (in case there are no branches)
set(h.edit18, 'String', num2str(d(5,1)));
set(h.edit19, 'String', num2str(d(5,2)));

% tropism 
set(h.popupmenu2, 'Value', h.tropism(1)+1);
set(h.edit22, 'String', num2str(h.tropism(2)));
set(h.edit23, 'String', num2str(h.tropism(3)));

%
set(h.figure1,'Name',p.name);

% Update handles structure
guidata(hObject, h);

% update GUI
axes(h.axes1);
updatePreview(h)
updateLaterals(hObject);

% UIWAIT makes rootparamUI wait for user response (see UIRESUME)
uiwait(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = rootparamUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Get default command line output from handles structure
h = guidata(hObject);
if strcmp(h.press,'cancel')
    h.parameters.theta = h.parameters.theta/180*pi;
    varargout{1} = h.parameters;
else
    varargout{1} = getParam(h);    
end
varargout{2} = h.press; % 'ok' or 'cancel'
delete(hObject);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

updateLaterals(hObject);
updatePreview(handles);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

h = guidata(hObject);
v = str2double(get(hObject,'String'));
if isnan(v)    
    v = h.default(1,1);
end
v = min(max(v,0.1),10);
set(hObject,'String',num2str(v));
h.data(1,1) = v;
guidata(hObject,h);
updatePreview(h);


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

h = guidata(hObject);
v = str2double(get(hObject,'String'));
if isnan(v)   
    v = h.default(2,1);
end
v = min(max(v,0.01),0.5);
set(hObject,'String',num2str(v));
h.data(2,1) = v;
guidata(hObject,h);
updatePreview(h);


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

h = guidata(hObject);
v = str2double(get(hObject,'String'));
if isnan(v)    
    v = h.default(3,1);
end
v = min(max(v,0),90);
set(hObject,'String',num2str(v));
h.data(3,1) = v;
guidata(hObject,h);
updatePreview(h);


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double

h = guidata(hObject);
v = str2double(get(hObject,'String'));
if isnan(v)    
    v = h.default(7,1);
end
v = min(max(v,0),300);
set(hObject,'String',num2str(v));
h.data(7,1) = v;
guidata(hObject,h);
updatePreview(h);


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double

h = guidata(hObject);
v = str2double(get(hObject,'String'));
if isnan(v)    
    v = h.default(4,1);
end
v = min(max(v,0),100);
set(hObject,'String',num2str(v));
h.data(4,1) = v;
guidata(hObject,h);
updatePreview(h);


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double

h = guidata(hObject);
v = str2double(get(hObject,'String'));
if isnan(v)    
    v = h.default(5,1);
end
v = min(max(v,0),300);
set(hObject,'String',num2str(v));
h.data(5,1) = v;
guidata(hObject,h);
updatePreview(h);

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double

h = guidata(hObject);
v = str2double(get(hObject,'String'));
if isnan(v)
    v = h.default(6,1);
end
v = min(max(v,0),20);
set(hObject,'String',num2str(v));
h.data(6,1) = v;
guidata(hObject,h);
updatePreview(h);


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double

h = guidata(hObject);
v = str2double(get(hObject,'String'));
if isnan(v)    
    v = h.default(5,1);
end
v = min(max(v,0),300);
set(hObject,'String',num2str(v));
h.data(5,1) = v;
guidata(hObject,h);
updatePreview(h);


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double

h = guidata(hObject);
v = str2double(get(hObject,'String'));
if isnan(v) || v<0
    v = 0;
end
set(hObject,'String',num2str(v));
h.data(1,2) = v;
guidata(hObject,h);

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double

h = guidata(hObject);
v = str2double(get(hObject,'String'));
if isnan(v) || v<0
    v = 0;
end
set(hObject,'String',num2str(v));
h.data(2,2) = v;
guidata(hObject,h);

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double

h = guidata(hObject);
v = str2double(get(hObject,'String'));
if isnan(v) || v<0
    v = 0;
end
set(hObject,'String',num2str(v));
h.data(3,2) = v;
guidata(hObject,h);


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double

h = guidata(hObject);
v = str2double(get(hObject,'String'));
if isnan(v) || v<0
    v = 0;
end
set(hObject,'String',num2str(v));
h.data(7,2) = v;
guidata(hObject,h);

% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double

h = guidata(hObject);
v = str2double(get(hObject,'String'));
if isnan(v) || v<0
    v = 0;
end
set(hObject,'String',num2str(v));
h.data(4,2) = v;
guidata(hObject,h);

% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double

h = guidata(hObject);
v = str2double(get(hObject,'String'));
if isnan(v) || v<0
    v = 0;
end
set(hObject,'String',num2str(v));
h.data(5,2) = v;
guidata(hObject,h);

% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double

h = guidata(hObject);
v = str2double(get(hObject,'String'));
if isnan(v) || v<0
    v = 0;
end
set(hObject,'String',num2str(v));
h.data(6,2) = v;
guidata(hObject,h);


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double

h = guidata(hObject);
v = str2double(get(hObject,'String'));
if isnan(v) || v<0
    v = 0;
end
set(hObject,'String',num2str(v));
h.data(5,2) = v;
guidata(hObject,h);


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = guidata(hObject);
h.press = 'ok';
guidata(hObject, h);
uiresume;

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = guidata(hObject);
h.press = 'cancel';
guidata(hObject, h);
uiresume;




function updateLaterals(hObject)
% updates the dialog regarding with or without laterals

h = guidata(hObject);
if get(h.popupmenu1,'Value') == 1 % make visible
    %disp('laterals');
    set(h.text1,'Visible','on');
    set(h.text2,'Visible','on');
    set(h.text3,'Visible','on');        
    set(h.text4,'Visible','on');
    set(h.text12,'Visible','on');
    set(h.text13,'Visible','on');
    set(h.text14,'Visible','on');        
    set(h.text15,'Visible','on');            
    set(h.edit4,'Visible','on');
    set(h.edit5,'Visible','on');
    set(h.edit6,'Visible','on');        
    set(h.edit7,'Visible','on');    
    set(h.edit13,'Visible','on');
    set(h.edit14,'Visible','on');
    set(h.edit15,'Visible','on');        
    set(h.edit16,'Visible','on');        
    %
    set(h.edit18,'Visible','off');        
    set(h.edit19,'Visible','off');  
    set(h.text20,'Visible','off');
    set(h.text21,'Visible','off');        
else % make invisible
    %disp('no laterals');
    set(h.text1,'Visible','off');
    set(h.text2,'Visible','off');
    set(h.text3,'Visible','off');
    set(h.text4,'Visible','off');
    set(h.text12,'Visible','off');
    set(h.text13,'Visible','off');
    set(h.text14,'Visible','off');        
    set(h.text15,'Visible','off');       
    set(h.edit4,'Visible','off');
    set(h.edit5,'Visible','off');
    set(h.edit6,'Visible','off');        
    set(h.edit7,'Visible','off');  
    set(h.edit13,'Visible','off');
    set(h.edit14,'Visible','off');
    set(h.edit15,'Visible','off');        
    set(h.edit16,'Visible','off');       
    %
    set(h.edit18,'Visible','on');        
    set(h.edit19,'Visible','on');  
    set(h.text20,'Visible','on');
    set(h.text21,'Visible','on');        
end




function updatePreview(h)
% update root preview

% modify paramters
p{1} = getParam(h);
p{1}.successor= 2; % override successor
p{2} = struct('a',0.7*p{1}.a,'la',2,'color',[1,1,0]); % make laterals

% create l-system string
pitchdown  = letter('^',pi/2);
if p{1}.theta==0 % taproot    
    str = [pitchdown; letter(303,1)]; 
else 
    diam = letter('#',0.3);
    c = letter('C',[1,0,0]);
    F = letter('F',2);
    push = letter('[');
    pop = letter(']');    
    str = [pitchdown; push; diam; c; F; push; letter(303,1); pop; F; pop]; 
end
str = updatePos(str);

% set label
if p{1}.nob(1)>0
    k = p{1}.la(1)+p{1}.lb(1)+(p{1}.nob(1)-1)*p{1}.ln(1); % maximal length
else
    k = p{1}.la(1)+p{1}.lb(1);
end

% SD is sqrt(la(2)^2+lb(2)^2+nob(1)*ln(2)^2) if nob(2)==0
 set(h.text22,'String',sprintf('Maximal root length is %g cm (updating preview)',k));

p{1}.r(2)=0; % set SVD zero
p{1}.a(2)=0;
p{1}.theta(2)=0;
p{1}.lb(2)=0;
p{1}.la(2)=0;
p{1}.ln(2)=0;
p{1}.nob(2)=0;
p = completeParameters(p);
% apply rules
simt = 30; 
N = 1;
N = max(N,1);
for i = 1 : N
    fprintf('*');
    str = applyRules(str,simt/N);
end
fprintf('\n');

% plot stuff
cla(h.axes1);
plotTubes(str);
%rotate3d on;

%
set(h.text22,'String',sprintf('Maximal root length is %g cm',k));



function p=getParam(h)
% copy data into struct

p = h.parameters;

p.tropism = h.tropism;
p.r = h.data(1,:);
p.a = h.data(2,:);
p.theta = h.data(3,:)/180*pi;
    
if get(h.popupmenu1,'Value')==1
    p.lb = h.data(4,:);
    p.la = h.data(5,:);
    p.ln = h.data(6,:);
    p.nob = h.data(7,:);    
else
    p.lb = [0,0];
    p.la = h.data(5,:);
    p.ln = [0,0];
    p.nob = [0,0];
end




% --- Executes during object deletion, before destroying properties.
function axes1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume;


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = guidata(hObject);
h.tropism(1) = get(hObject,'Value')-1;
guidata(hObject,h);
updatePreview(h);


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% N
function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = guidata(hObject);
v = str2double(get(hObject,'String'));
if isnan(v)   
    v = h.defaultTrop(2);
end
v = min(max(v,0),5);
set(hObject,'String',num2str(v));
h.tropism(2) = v;
updatePreview(h);


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% sigma
function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = guidata(hObject);
v = str2double(get(hObject,'String'));
if isnan(v)   
    v = h.defaultTrop(3);
end
v = min(max(v,0),1);
set(hObject,'String',num2str(v));
h.tropism(3) = v;
guidata(hObject,h);
updatePreview(h);


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
