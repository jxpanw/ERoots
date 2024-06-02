bnd = getBounds(wfy);
X = [-inf inf];
Y = [-inf inf];
Z = linspace(bnd(5),bnd(6),20);
[map,l] = getDensity(wfy,X,Y,Z,'l');
d = 1:size(map,3);
d(:) = map(1,1,:);
figure;
plot(d/l,Z(1:length(d)),'r');
title('Root length distribution')
ylabel('depth (cm)');
xlabel('root length fraction');

hold on;
bnd1 = getBounds(yhsm);
X = [-inf inf];
Y = [-inf inf];
Z = linspace(bnd(5),bnd(6),20);
[map,l] = getDensity(yhsm,X,Y,Z,'l');
d = 1:size(map,3);
d(:) = map(1,1,:);
plot(d/l,Z(1:length(d)),'b');

hold on;
bnd2 = getBounds(xhx);
X = [-inf inf];
Y = [-inf inf];
Z = linspace(bnd2(5),bnd2(6),20);
[map,l] = getDensity(xhx,X,Y,Z,'l');
d = 1:size(map,3);
d(:) = map(1,1,:);
plot(d/l,Z(1:length(d)),'k');
hold on;

gas=legend('WFY-286','YHSM','XHX-45','location','SouthEast');
