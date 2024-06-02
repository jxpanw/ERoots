%
% Root system analysis: root surface densities in REVs root length
% fractions versus depth.
% 

% clear all;
set(0,'defaultfigurecolor','w')
set(0,'RecursionLimit',10000);
bnd = getBounds(b);%WFY�������߽�ֵ

% plot root system (surface densities in y-z plane)��ֱ
figure
%plotTubes(b); hold on;
X = (floor(bnd(1)):1:ceil(bnd(2)));
Y = (floor(bnd(3)):1:ceil(bnd(4)));
Z = (ceil(bnd(5)):1:ceil(bnd(6)));
% X = linspace(floor(bnd(1)),ceil(bnd(2)),(abs(floor(bnd(1)))+abs(ceil(bnd(2))))+1); %��X��ı߽��Ϊ�Ⱦ����3����
% Y = linspace(floor(bnd(3)),ceil(bnd(4)),(abs(floor(bnd(3)))+abs(ceil(bnd(4))))+1);
% Z = linspace(floor(bnd(1)),ceil(bnd(2)),(abs(floor(bnd(1)))+abs(ceil(bnd(2))))+1);
X = linspace(bnd(1),bnd(2),37); %��X��ı߽��Ϊ�Ⱦ����3����
Y = linspace(bnd(3),bnd(4),37);
Z = linspace(bnd(5),bnd(6),35);
m = getDensity(b,X,Y,Z,'s');
n = permute(m,[2,1,3]);%�������� order ָ����˳���������� A ��ά�ȡ����ɵ����� B ������ A ��ͬ��ֵ���������κ��ض�Ԫ��������±�˳���� order ָ����˳���������С�order ������Ԫ�ض�������Ψһ��������ʵ��ֵ��
slice(0.5*(X(1:end-1)+X(2:end)),0.5*(Y(1:end-1)+Y(2:end)),0.5*(Z(1:end-1)+Z(2:end)),n,[0],[],[]);%������������ʾ����Ӧ��������������Ƭ��[0]��ʾ������Ƭ
%slice(X,Y,Z,n,[0],[],[]);%������������ʾ����Ӧ��������������Ƭ��[0]��ʾ������Ƭ
light
%view(70,30);
