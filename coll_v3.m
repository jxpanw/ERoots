i=4;
point=convert2RSWMSinput(str{i});
P=point(:,2:4);
[x,y,z] = meshgrid(-40:1:40,-40:1:40,-40:1:40);
x = P(:,1);
y = P(:,2);
z = P(:,3);
[k,av] = convhull(P);
plotTubes(str{i})
hold on
trisurf(k,x,y,z,'FaceColor','white','FaceAlpha','0.5','LineStyle','none')
axis equal
v=getTotal(str{i},'v')
av