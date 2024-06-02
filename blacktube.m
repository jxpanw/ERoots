function blacktube(lines,radii,colors,Nsides)
% plotTubes: Plots a roots system using stream tubes
%
% plotTubes(str)
% str             l-system string
%
% plotTubes(lines,widths,colors,Nsides)
% lines           a list of polylines given by a vector of points
% radii           a list of radii
% colors          a list of colors
% (Nsides)        the number of points along the circumference of the tube. Default Nsides=7



if (nargin==1)
    [lines,radii,colors] = getPolylines(lines);
end

if (nargin<4)
    Nsides=7;
end


diameters = cell(length(lines),1);
for i = 1 : length(lines)  
     diameters{i}= ones(1,size(lines{i},1))*radii(i)*1.2;
     m=size(lines{i},1)*1;
     diameters{i}= ones(1,size(lines{i},1))*radii(i)*2;
     for a=1:size(lines{i},1)
        diameters{i}(1,a)=diameters{i}(1,a)*(m-a+1)/m;
        a=a+1;
     end
end


hsF=streamtube(lines,diameters,[1,Nsides]);

c=1;
for i = 1 : length(lines)
    if size(lines{i},1)==1
        colors(c)=[];
    else
        c=c+1;
    end
end


hsfp = cell(length(hsF),1);
for i=1 : length(hsF)
    hsfp{i} = get(hsF(i));
    nodes = size(hsfp{i}.ZData,1);
    cd = cat(3,ones(nodes,Nsides+1),ones(nodes,Nsides+1),ones(nodes,Nsides+1));    
    cd(1,:,1) = 0;
    cd(1,:,2) = 0;
    cd(1,:,3) = 0;

    for j=2:size(cd,1)
        cd(j,:,1) = 0;
        cd(j,:,2) = 0;
        cd(j,:,3) = 0;
    end
    set(hsF(i),'CData',cd);
    hold on
end


axis equal;
bnd = getBounds([],lines);
bnd = bnd + [-0.5,0.5,-0.5,0.5,-0.5,0.5,0,0];
axis(bnd);
view(0,0);
rotate3d on
