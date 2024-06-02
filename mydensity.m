set(0,'defaultfigurecolor','w')
set(0,'RecursionLimit',10000);
bnd = getBounds(b);%WFY

% plot root system (surface densities in y-z plane)
figure
plotTubes(b); hold on;
X = linspace(bnd(1),bnd(2),3); 
Y = linspace(bnd(3),bnd(4),10);
Z = linspace(bnd(5),bnd(6),20);
m = getDensity(b,X,Y,Z,'s');
m = permute(m,[2,1,3]);
slice(0.5*(X(1:end-1)+X(2:end)),0.5*(Y(1:end-1)+Y(2:end)),0.5*(Z(1:end-1)+Z(2:end)),m,[0],[],[]);
light, view(70,30);

% plot root system (surface densities in x-y plane)
figure
plotTubes(b); hold on;
X = linspace(bnd(1),bnd(2),10); 
m = getDensity(b,X,Y,Z,'s');
m = permute(m,[2,1,3]);
slice(0.5*(X(1:end-1)+X(2:end)),0.5*(Y(1:end-1)+Y(2:end)),0.5*(Z(1:end-1)+Z(2:end)),m,[],[],[-15]);
light, view(37.5,30);


X = [-inf inf];
Y = [-inf inf];
Z = linspace(bnd(5),bnd(6),20);
[map,l] = getDensity(b,X,Y,Z,'l');
d = 1:size(map,3);
d(:) = map(1,1,:);
figure;
plot(d/l,Z(1:length(d)));
title('Root length distribution')
ylabel('depth (cm)');
xlabel('root length fraction');
