function varargout = viewerUI(varargin)
% VIEWERUI MATLAB code for viewerUI.fig
%      VIEWERUI, by itself, creates a new VIEWERUI or raises the existing
%      singleton*.
%
%      H = VIEWERUI returns the handle to a new VIEWERUI or the handle to
%      the existing singleton*.
%
%      VIEWERUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEWERUI.M with the given input arguments.
%
%      VIEWERUI('Property','Value',...) creates a new VIEWERUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before viewerUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to viewerUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help viewerUI

% Last Modified by GUIDE v2.5 02-Mar-2015 15:17:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @viewerUI_OpeningFcn, ...
                   'gui_OutputFcn',  @viewerUI_OutputFcn, ...
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


% --- Executes just before viewerUI is made visible.
function viewerUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to viewerUI (see VARARGIN)

% Choose default command line output for viewerUI
handles.output = hObject;
rs = varargin{1};
handles.rs = rs;
handles.i = 1; 

if length(varargin)>1
    handles.simtime=varargin{2};
else
    handles.simtime=0;
end

if length(varargin)>2
    handles.geom = varargin{3};
else
    handles.geom =[];
end

if length(rs)==1 % disable + - 
    set(handles.uipushtool2, 'Visible', 'off');
    set(handles.uipushtool4, 'Visible', 'off');
    set(handles.uipushtool5, 'Visible', 'off');
    set(handles.uipushtool6, 'Visible', 'off');    
end

handles.bnd = getBounds(rs{end}); % set the bounds of the last frame
handles.bnd = handles.bnd + [-0.5,0.5,-0.5,0.5,-0.5,0.5,0,0];

% precompute 
%wh = waitbar(0,'Root geometry...');
for i = 1 : length(rs)
    [lines,radii,colors] = getPolylines(rs{i});
    handles.lines{i} = lines;
    handles.radii{i} = radii;
    handles.colors{i} = colors;
    %waitbar(i/length(rs),wh);        
end


guidata(hObject, handles);

% plot the thing
plotRS(handles);

% set view
axis(handles.axes1); 
view(3);
zoom(0.75);


% --- Outputs from this function are returned to the command line.
function varargout = viewerUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function uipushtool2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.i = handles.i-1;
handles.i = max(handles.i,1);
guidata(hObject,handles);
plotRS(handles);


% --------------------------------------------------------------------
function uipushtool4_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.i = handles.i+1;
handles.i = min(handles.i,length(handles.lines));
guidata(hObject,handles);
plotRS(handles);


function plotRS(h)
% plots the root system
axis(h.axes1);

cla;

maxi = length(h.lines); % label figure1
if h.simtime~=0
    str = sprintf('Root System Viewer - Simulation after %g days (%g/%g)',...
        h.i/maxi*h.simtime,h.i,maxi);
else   
    if maxi>1
        str = sprintf('Root System Viewer - Simulation %g/%g',h.i,maxi);
    else        
        str = 'Root System Viewer';
    end
end
set(h.figure1,'Name',str);
    
[az,el] = view(); % reset the same view
plotTubes(h.lines{h.i},h.radii{h.i},h.colors{h.i});
view(az,el); 

xlabel('x (cm)'); % label axis
ylabel('y (cm)');
zlabel('z (cm)');

axis(h.bnd); % always the bounds of the last frame

if ~isempty(h.geom) % plot geometry 
    X_ = linspace(h.bnd(1),h.bnd(2),80);
    Y_ = linspace(h.bnd(3),h.bnd(4),80);
    Z_ = linspace(h.bnd(5),h.bnd(6),80);
    plotDistFunc(h.geom,X_,Y_,Z_,[0 0 1]);
end


% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% save file as RSML
[filename, pathname] = uiputfile({'*.rsml'},'Save as');

if ~(isequal(filename,0) || isequal(pathname,0)) % not cancel
    writeRSML(fullfile(pathname, filename), handles.rs{end}, handles.simtime);
end


% --------------------------------------------------------------------
function uipushtool5_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.i = 1;
guidata(hObject,handles);
plotRS(handles);


% --------------------------------------------------------------------
function uipushtool6_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.i = length(handles.lines);
guidata(hObject,handles);
plotRS(handles);


