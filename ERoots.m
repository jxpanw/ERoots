function varargout = ERoots(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ERoots_OpeningFcn, ...
                   'gui_OutputFcn',  @ERoots_OutputFcn, ...
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

function ERoots_OpeningFcn(hObject, eventdata, h, varargin)

h.output = hObject;

if ~isempty(varargin)
    h.parameters=varargin{1};
else 
     seminalroots = struct('r',1.5,'a',0.1,'theta',20/180*pi,'lb',2,'la',8,'ln',2,'nob',6,'dx',0.25,...
        'color', [1,0,0],'tropism',[1,1.5,0.2],'successor',2,'rlt',Inf,'gf',1,...
        'name','seminalroots'); 
    lateral = struct('r',1,'a',0.08,'theta',50/180*pi,'lb',2,'la',6,'ln',1,'nob',8,'dx',0.25,...
        'color',[0,1,0],'tropism',[1,1,0.3],'successor',[],'rlt',Inf,'gf',1,...
        'name','Lateral');
    lateral2 = struct('r',0.6,'a',0.05,'theta',40/180*pi,'lb',2,'la',5,'ln',2,'nob',6,'dx',0.25,...
        'color',[0,0,1],'tropism',[1,1,0.3],'successor',[],'rlt',Inf,'gf',1,...
        'name','Second order laterals');
    lateral3 = struct('r',0.6,'a',0.05,'theta',30/180*pi,'lb',0,'la',2,'ln',2,'nob',0,'dx',0.25,...
        'color',[0,0,0],'tropism',[1,0.5,0.4],'successor',[],'rlt',Inf,'gf',1,...
        'name','Third order lateralss');
    advroots = struct('r',1.5,'a',0.1,'theta',70/180*pi,'lb',2,'la',8,'ln',3,'nob',10,'dx',0.25,...
        'color', [163/255,99/255,9/255] ,'tropism',[1,1.5,0.2],'successor',2,'rlt',Inf,'gf',1,...
        'name','advroots');   
    shootborne = advroots;
    shootborne.name = 'borneroots';
    shootborne.tropism = [1,1,0.2];
    shootborne.theta = 80/180*pi; 
    shootborne.color = [163/255,99/255,9/255];
    h.parameters = {seminalroots, lateral, lateral2, lateral3, advroots, shootborne};
end

%Plant
h.plantingdepth = str2double(get(h.edit10,'String'));
h.firstB = str2num(get(h.edit2,'String'));
h.delayB = 4;
h.maxB = 40;
h.nCR = 11;
h.firstCR = 7;
h.delayCR = 3;
h.delayRC = 33;
h.dzRC = 1;

%Simulation
h.simtime = str2double(get(h.edit3,'String')); % Simulation days
h.intermediate = str2double(get(h.edit4,'String'));


im = imread('myroot.png');
axes(h.axes3);
imshow(im);

guidata(hObject, h);




function varargout = ERoots_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;





%checkbox13.
function checkbox13_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    set(handles.pushbutton18,'Enable','off');
else
    set(handles.pushbutton18,'Enable','on');
end

function checkbox12_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    set(handles.pushbutton19,'Enable','on');
else
    set(handles.pushbutton19,'Enable','off');
end


function checkbox11_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    set(handles.checkbox13,'Enable','on');
    set(handles.pushbutton15,'Enable','on');
    set(handles.pushbutton18,'Enable','off');
    if get(handles.checkbox13,'Value')
        set(handles.pushbutton15,'Enable','on');
    else
        set(handles.pushbutton15,'Enable','off');
    end
    else
    set(handles.pushbutton15,'Enable','off');
    set(handles.checkbox13,'Enable','off');
    set(handles.pushbutton18,'Enable','on');
end


function checkbox10_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    set(handles.pushbutton17,'Enable','on');
else
    set(handles.pushbutton17,'Enable','off');
end

% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    set(handles.pushbutton16,'Enable','on');
else
    set(handles.pushbutton16,'Enable','off');
end






function pushbutton15_Callback(hObject, eventdata, handles)
handles.parameters{1} = rootparamUI(handles.parameters{1});
guidata(hObject,handles);


function pushbutton16_Callback(hObject, eventdata, handles)
handles.parameters{2} = rootparamUI(handles.parameters{2});
guidata(hObject,handles);


function pushbutton17_Callback(hObject, eventdata, handles)
handles.parameters{3} = rootparamUI(handles.parameters{3});
guidata(hObject,handles);


function pushbutton18_Callback(hObject, eventdata, handles)
handles.parameters{5} = rootparamUI(handles.parameters{5});
guidata(hObject,handles);


function pushbutton19_Callback(hObject, eventdata, handles)
handles.parameters{4} = rootparamUI(handles.parameters{4},'nobranches');
guidata(hObject,handles);


function pushbutton20_Callback(hObject, eventdata, handles)

h=handles;
[filename, pathname] = uiputfile({'*.m'},'Save as');
if ~(isequal(filename,0) || isequal(pathname,0)) 

    load('template.mat');
    
    %successors
    p = h.parameters;
    [h,p] = setSuccessors(h,p);
    r1=7;
    r2=4;
    h=15;
    pot = @(p) distPot(p,r1,r2,h);
    p = completeParameters(p,pot); % check

    fid = fopen(fullfile(pathname,filename),'w');
    
    fprintf(fid,pre);
    
    if isempty(p{1}.successor)
        sstr = '[]';
    else
        sstr = ['[', num2str(p{1}.successor(1)), ', 1]'];
    end
    
    fprintf(fid,tapMC,p{1}.r(1),p{1}.r(2),p{1}.a(1),p{1}.a(2),p{1}.theta(1),p{1}.theta(2),p{1}.lb(1),...
        p{1}.lb(2),p{1}.la(1),p{1}.la(2),p{1}.ln(1),p{1}.ln(2),p{1}.nob(1),p{1}.nob(2),...
        p{1}.name,p{1}.color(1), p{1}.color(2),p{1}.color(3),...
        p{1}.tropism(1),p{1}.tropism(2),p{1}.tropism(3),...
        p{1}.dx(1), p{1}.rlt(1),p{1}.rlt(2),p{1}.gf(1),sstr); % seminal roots

    if get(h.checkbox9,'Value')==1 % Lateral
        if isempty(p{2}.successor)
            sstr = '[]';
        else
            sstr = ['[', num2str(p{2}.successor(1)), ', 1]'];
        end
        fprintf(fid,lateral,p{2}.r(1),p{2}.r(2),p{2}.a(1),p{2}.a(2),...
            p{2}.theta(1),p{2}.theta(2),p{2}.lb(1),p{2}.lb(2), p{2}.la(1),...
            p{2}.la(2), p{2}.ln(1), p{2}.ln(2),p{2}.nob(1), p{2}.nob(2),...
            p{2}.name,p{2}.color(1), p{2}.color(2),p{2}.color(3),...
            p{2}.tropism(1),p{2}.tropism(2),p{2}.tropism(3),...
            p{2}.dx(1), p{2}.rlt(1),p{2}.rlt(2),p{2}.gf(1),sstr);
    end
    
    if get(h.checkbox10,'Value')==1 % Second order lateral
        if isempty(p{3}.successor)
            sstr = '[]';
        else
            sstr = ['[', num2str(p{3}.successor(1)), ', 1]'];
        end
        fprintf(fid,lateral2,p{3}.r(1),p{3}.r(2),p{3}.a(1),p{3}.a(2),...
            p{3}.theta(1),p{3}.theta(2),p{3}.la(1),p{3}.la(2),...        
            p{3}.lb(1),p{3}.lb(2),p{3}.ln(1),p{3}.ln(2),p{3}.nob(1),p{3}.nob(2),...
            p{3}.name,p{3}.color(1), p{3}.color(2),p{3}.color(3),...
            p{3}.tropism(1),p{3}.tropism(2),p{3}.tropism(3),...
            p{3}.dx(1), p{3}.rlt(1),p{3}.rlt(2),p{3}.gf(1),sstr);
    end
    
    if get(h.checkbox12,'Vaule')==1 %Third order lateral
        fprintf(fid,lateral2,p{4}.r(1),p{4}.r(2),p{4}.a(1),p{4}.a(2),...
            p{4}.theta(1),p{4}.theta(2),p{4}.la(1),p{4}.la(2),...        
            p{4}.lb(1),p{4}.lb(2),p{4}.ln(1),p{4}.ln(2),p{4}.nob(1),p{4}.nob(2),...
            p{4}.name,p{4}.color(1), p{4}.color(2),p{4}.color(3),...
            p{4}.tropism(1),p{4}.tropism(2),p{4}.tropism(3),...
            p{4}.dx(1), p{4}.rlt(1),p{4}.rlt(2),p{4}.gf(1),sstr);
    end
    
        if isempty(p{5}.successor)
            sstr = '[]';
        else
            sstr = ['[', num2str(p{5}.successor(1)), ', 1]'];
        end
        fprintf(fid,basal,p{5}.r(1),p{5}.r(2),p{5}.a(1),p{5}.a(2),...
            p{5}.theta(1),p{5}.theta(2),p{5}.lb(1),p{5}.lb(2), p{5}.la(1),...
            p{5}.la(2), p{5}.ln(1), p{5}.ln(2),p{5}.nob(1), p{5}.nob(2),...
            p{5}.name,p{5}.color(1), p{5}.color(2),p{5}.color(3),...
            p{5}.tropism(1),p{5}.tropism(2),p{5}.tropism(3),...
            p{5}.dx(1), p{5}.rlt(1),p{5}.rlt(2),p{5}.gf(1),sstr);
         
        if isempty(p{6}.successor)
            sstr = '[]';
        else
            sstr = ['[', num2str(p{6}.successor(1)), ', 1]'];
        end
        fprintf(fid,shootborne,p{6}.r(1),p{6}.r(2),p{6}.a(1),p{6}.a(2),...
            p{6}.theta(1),p{6}.theta(2),p{6}.lb(1),p{6}.lb(2), p{6}.la(1),...
            p{6}.la(2), p{6}.ln(1), p{6}.ln(2),p{6}.nob(1), p{6}.nob(2),...
            p{6}.name,p{6}.color(1), p{6}.color(2),p{6}.color(3),...
            p{6}.tropism(1),p{6}.tropism(2),p{6}.tropism(3),...
            p{6}.dx(1), p{6}.rlt(1),p{6}.rlt(2),p{6}.gf(1),sstr);      

    h.firstB = [h.firstB,0];     % in case no sd add 0
    h.delayB = [h.delayB,0];
    h.firstCR = [h.firstCR,0];
    h.delayCR = [h.delayCR,0];
    h.nCR = [h.nCR,0];
    h.delayRC = [h.delayRC,0];
    h.dzRC = [h.dzRC,0];
    fprintf(fid,monocot,h.plantingdepth,h.firstB(1),h.firstB(2),h.delayB(1), ...
        h.delayB(2),h.maxB,h.firstCR(1),h.firstCR(2),h.delayCR(1),h.delayCR(2),...
        h.nCR(1),h.nCR(2),h.delayRC(1),h.delayRC(2),h.dzRC(1),h.dzRC(2));       
    fprintf(fid,simMonocot,h.simtime,h.simtime/(h.intermediate+1));    
    fprintf(fid,viz);        
    fprintf(fid,example);
    fclose(fid);           
    
end


function pushbutton21_Callback(hObject, eventdata, handles)

h = handles;

% define successors
p = h.parameters;
[h,p] = setSuccessors(h,p);
r1=8;
r2=5;
m=20;
pot = @(p) distPot(p,r1,r2,m);
% Simulation
completeParameters(p);
simtime = h.simtime;
steps = h.intermediate+1; 
str0 = createMonocotRS(h.plantingdepth,h.firstB,h.delayB,h.maxB,0.1,...
    h.firstCR,h.delayCR,h.nCR,h.delayRC,h.dzRC);


p{4}.theta = 0;  
completeParameters(p,pot);

wh = waitbar(0,'Simulation...');
for i = 1 : steps
    if i==1 
        str{i} = applyRules(str0,simtime/steps);
    else
        str{i} = applyRules(str{i-1},simtime/steps);
    end
    waitbar(i/steps,wh);   
end
close(wh);
pause(0.1); 

assignin('base','str',str);
assignin('base','simtime',(simtime/steps).*(1:steps));

viewerUI(str,simtime);

function [h,p]=setSuccessors(h,p)
p{4}.successor = []; % 3nd order laterals
if get(h.checkbox11,'Value')
    p{1}=p{1};
else
    p{1}=[];
end


if get(h.checkbox9,'Value') % laterals exist
    p{1}.successor = 2; % seminal
    p{5}.successor = 2; % adv
    p{6}.successor = 2; % shootborne
else
    p{1}.successor = [];
    p{5}.successor = [];
    p{6}.successor = [];
end

if get(h.checkbox10,'Value') % 2nd order laterals
     if get(h.checkbox12,'Value')
        p{2}.successor = 3; 
        p{3}.successor = 4;
   else
        p{2}.successor = 3; 
        p{3}.successor = [];
     end
else
    p{2}.successor = [];
    p{3}.successor = [];
end 


if get(h.checkbox13,'Value') % adv = sem
    p{5} = p{1};
    p{5}.name = 'adventitious roots'; 
    p{5}.theta = 70/180*pi; 
    p{5}.color =  [163/255,99/255,9/255]; %[0.5,0,0.5];
    p{5}.tropism = [1,1,0.2];
else
   h.firstB = [Inf,0]; 
end

p{6} = p{5};
p{6}.name = 'Shoot borne root';        
p{6}.color =  [163/255,99/255,9/255];
p{6}.tropism = [1,1,0.2];



function edit10_Callback(hObject, eventdata, handles)
depth = str2double(get(hObject,'String'));
depth = min(max(depth,0),20);
set(hObject,'String',num2str(depth));
handles.plantingdepth = depth;
guidata(hObject,handles);


function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
fb = str2num(get(hObject,'String'));
fb = min(max(fb,0),365);
if length(fb)>1
    set(hObject,'String',['[ ',num2str(fb),' ]']);
else
    set(hObject,'String',num2str(fb));    
end
handles.firstB = fb;
guidata(hObject,handles);

function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_Callback(hObject, eventdata, handles)
simtime = str2double(get(hObject,'String'));
simtime = min(max(simtime,1),365);
set(hObject,'String',num2str(simtime));
handles.simtime = simtime;
guidata(hObject,handles);


function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
ir = str2double(get(hObject,'String'));
ir = min(max(ir,0),1e3);
set(hObject,'String',num2str(ir));
handles.intermediate = ir;
guidata(hObject,handles);


function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit14_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
