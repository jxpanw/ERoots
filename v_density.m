%
% Root system analysis: root surface densities in REVs root length
% fractions versus depth.
% 

% clear all;
set(0,'defaultfigurecolor','w')
set(0,'RecursionLimit',10000);
bnd = getBounds(b);%WFY的三个边界值

% plot root system (surface densities in y-z plane)垂直
figure
%plotTubes(b); hold on;
X = (floor(bnd(1)):1:ceil(bnd(2)));
Y = (floor(bnd(3)):1:ceil(bnd(4)));
Z = (ceil(bnd(5)):1:ceil(bnd(6)));
% X = linspace(floor(bnd(1)),ceil(bnd(2)),(abs(floor(bnd(1)))+abs(ceil(bnd(2))))+1); %将X轴的边界分为等距离的3个点
% Y = linspace(floor(bnd(3)),ceil(bnd(4)),(abs(floor(bnd(3)))+abs(ceil(bnd(4))))+1);
% Z = linspace(floor(bnd(1)),ceil(bnd(2)),(abs(floor(bnd(1)))+abs(ceil(bnd(2))))+1);
X = linspace(bnd(1),bnd(2),37); %将X轴的边界分为等距离的3个点
Y = linspace(bnd(3),bnd(4),37);
Z = linspace(bnd(5),bnd(6),35);
m = getDensity(b,X,Y,Z,'s');
n = permute(m,[2,1,3]);%按照向量 order 指定的顺序重新排列 A 的维度。生成的数组 B 具有与 A 相同的值，但访问任何特定元素所需的下标顺序按照 order 指定的顺序重新排列。order 的所有元素都必须是唯一的正整数实数值。
slice(0.5*(X(1:end-1)+X(2:end)),0.5*(Y(1:end-1)+Y(2:end)),0.5*(Z(1:end-1)+Z(2:end)),n,[0],[],[]);%后三个变量表示在相应的坐标轴设置切片，[0]表示创建切片
%slice(X,Y,Z,n,[0],[],[]);%后三个变量表示在相应的坐标轴设置切片，[0]表示创建切片
light
%view(70,30);
