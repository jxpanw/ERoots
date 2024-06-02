function writeRSML(filename, str, simtime, pos)
% writeRSML: writes a RSML file of the l-system string


global parameters; 

if (nargin<4)
    pos.x=[0;0;0];
    pos.C=[0,0,0]; % black
    pos.a=0.1;
    pos.t=0;
    pos.R=eye(3);
end


m.version = 1;
m.unit = 'cm';
m.resolution = 1;
m.last_DASH_modified=datestr(date,'yyyy-mm-dd');
m.software = 'RootBox_v6';
m.user = getenv('username');
[~,name,~] = fileparts(filename) ;
m.file_DASH_key = [name,'RSML.mat'];
im.name = sprintf('Simulation (%g days)',simtime); 
m.image = im;

m.property_DASH_definitions.property_DASH_definition(1).label = 'length';
m.property_DASH_definitions.property_DASH_definition(1).type = 'real';
m.property_DASH_definitions.property_DASH_definition(1).unit = 'cm';
%
m.property_DASH_definitions.property_DASH_definition(2).label = 'type';
m.property_DASH_definitions.property_DASH_definition(2).type = 'integer';
m.property_DASH_definitions.property_DASH_definition(2).unit = '1';
%
m.property_DASH_definitions.property_DASH_definition(3).label = 'diameter';
m.property_DASH_definitions.property_DASH_definition(3).type = 'real';
m.property_DASH_definitions.property_DASH_definition(3).unit = 'cm';
%
m.property_DASH_definitions.property_DASH_definition(4).label = 'color';
m.property_DASH_definitions.property_DASH_definition(4).type = 'string'; 
m.property_DASH_definitions.property_DASH_definition(4).unit = 'rgb';
%
m.property_DASH_definitions.property_DASH_definition(5).label = 'parent-node';
m.property_DASH_definitions.property_DASH_definition(5).type = 'integer';
m.property_DASH_definitions.property_DASH_definition(5).unit = '1';

m.property_DASH_definitions.function_DASH_definition(1).label = 'age';
m.property_DASH_definitions.function_DASH_definition(1).type = 'real';
m.property_DASH_definitions.function_DASH_definition(1).unit = 'days';

tree.metadata=m;


[seg, tip]=convert2RSWMSinput(str);

seg(1,:)= []; 
seg(:,1)=seg(:,1)-1; 
seg(:,5)=seg(:,5)-1; 

[~,ix] = sort(seg(:,1)); 
seg = seg(ix,:); 

[~,~,radius,color,time]=getSegments(str, pos); 
ind0 = find(seg(:,5)==0);
seg(ind0,5)=ind0; 
seg(:,5) = seg(seg(:,5),7); 


ind0 = find(tip(:,6)==1 | tip(:,6)==4 | tip(:,6)==5); 
for i = 1 : length(ind0)
    root0(i) = getRoot(ind0(i), seg, tip, simtime, radius, color, time);
end
tree.scene.plant.root = root0;


[pathstr,name,~] = fileparts(filename);
wPref.StructItem = false;
rsmlname = [pathstr,'/',name,'.rsml'];
xml_write(rsmlname,tree,'rsml',wPref);
matname = [pathstr,'/',name,'RSML.mat']; 
save(matname,'parameters','str','simtime');


FID = fopen(rsmlname, 'r'); 
Data = textscan(FID, '%s', 'delimiter', '\n', 'whitespace', '');
CStr = Data{1};
fclose(FID);
IndexC = strfind(CStr, 'deleteme'); 
Index = find(~cellfun('isempty', IndexC));
CStr(Index) = [];
FID = fopen(rsmlname, 'w'); 
fprintf(FID, '%s\n', CStr{:});
fclose(FID);

function root = getRoot(id, seg, tip, simtime, radius,color,time)

seg_id = find(seg(:,7)==id); 
seg_cid = find(seg(:,5)==id);
suc = unique(seg(seg_cid,7)); 
suc(suc==id)=[]; 

root.ATTRIBUTE.id = id;

for j = 1 : size(seg_id,1)
    root.geometry.polyline.point(j).ATTRIBUTE.x = seg(seg_id(j),2);
    root.geometry.polyline.point(j).ATTRIBUTE.y = seg(seg_id(j),3);    
    root.geometry.polyline.point(j).ATTRIBUTE.z = seg(seg_id(j),4);    
end                                           


root.properties.length.ATTRIBUTE.value = tip(id,8);
root.properties.type.ATTRIBUTE.value = tip(id,6);
root.properties.diameter.ATTRIBUTE.value = 2*radius(seg_id(1));
root.properties.color.ATTRIBUTE.value = color(seg_id(1),:);

if ~isempty(suc)
    for j = 1 : length(suc)      
        rootS(j) = getRoot(suc(j),seg, tip,simtime, radius,color,time);      
        rootS(j).properties.parent_DASH_node.ATTRIBUTE.value = id;            
    end    
    root.root = rootS;
else
    root.root = 'deleteme';
end


root.functions.function.ATTRIBUTE.domain='polyline';
root.functions.function.ATTRIBUTE.label='age';
for j = 1 : size(seg_id,1)
    age = simtime-time(seg_id(j));
    if isnan(age) 
        age = 0;
    end
    root.functions.function.sample(j).ATTRIBUTE.value = age;     
end
