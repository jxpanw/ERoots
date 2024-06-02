clear all;
set(0,'RecursionLimit',10000);

p{1}.name = 'seminalroots';
p{1}.r = [1.5,0];
p{1}.lb = [25,0];          
p{1}.la = [0,0];                    
p{1}.ln = [0,0];                 
p{1}.nob = [0,0];  
p{1}.a = 0.1;   
p{1}.theta = [20/180*pi,5/180*pi];
p{1}.color = [0,0,1]; % red
p{1}.tropism = [1,2,10*pi/180];  % gravitropism
p{1}.dx= 0.25; 
p{1}.successor = 2;

p{2}.name = 'advroots';
p{2}.r = [1,0.1];
p{2}.lb = [2,0];          
p{2}.la = [8,0];                    
p{2}.ln = [2,0];                 
p{2}.nob = [6,1];  
p{2}.a = 0.2;   
p{2}.theta = 10/180*pi;
p{2}.color = [163/255,99/255,9/255]; 
%p{2}.tropism = [1,2,10*pi/180];  % gravitropism
p{2}.tropism = [4,1.5,20*pi/180];  % [type, N, sigma] Chemotropism: type=3, N is strength, sigma is stiffness
p{2}.dx= 0.25; 
p{2}.successor = 3;

p{3}.name = '2roots';
p{3}.r = [2,0.1];
p{3}.lb = [2,0];          
p{3}.la = [8,0];                    
p{3}.ln = [2,0];                 
p{3}.nob = [6,1];  
p{3}.a = 0.15;   
p{3}.theta = 10/180*pi;
p{3}.color = [0,1,0]; 
p{3}.tropism = [4,1.5,20*pi/180];  
p{3}.dx= 0.25; 
p{3}.successor = 4;

p{4}.name = '3roots';
p{4}.r = [1,0.1];
p{4}.lb = [2,0];          
p{4}.la = [8,0];                    
p{4}.ln = [2,0];                 
p{4}.nob = [0,1];  
p{4}.a = 0.1;   
p{4}.theta = 0;
p{4}.color = [0,0,1]; 
p{4}.tropism = [4,1.5,10*pi/180];  
p{4}.dx= 0.25; 
p{4}.successor =[];

p = completeParameters(p);


global C;
global X;
global Y;
global Z;
nx = 41; 
ny = 41; 
nz = 21;
x = linspace(-20,20,nx); 
y = linspace(-20,20,ny); 
z = linspace(-20,0,nz);
[X,Y,Z] = meshgrid(x,y,z); 
C = zeros(nx,ny,nz);

c01 = 0;   
c02 = 1;   % gradient between c01 - c02
C = zeros(nx,ny,nz);
for y=1:ny 
    if y>25&&y<35
    u=(y-1)/(ny-1);
    C(:,y,:)=c02*u*ones(nx,nz) + (1-u)*c01*ones(nx,nz);
    else
        C(:,y,:)=0;
    end
end

for z=1:nz
if z>8&&z<15
    C(:,:,z)=C(:,:,z);
else
    C(:,:,z)=0;
end
end

% %沿X轴浓度变化：即浓度自负到正养分浓度在【c01,c02】中递增-----------XZ
% for y=1:ny %自左而右
%     u=(y-1)/(ny-1);%nx-1表示网格数
%     C(:,y,:)=c02*u*ones(nx,nz) + (1-u)*c01*ones(nx,nz);%自左而右浓度递增
% end

% %沿Y轴浓度变化：即浓度自负到正养分浓度在【c01,c02】中递增------------YZ
% for x=1:41 %自左而右
%     u=(x-1)/(nx-1);%nx-1表示网格数
%     C(x,:,:)=c02*u*ones(ny,nz) + (1-u)*c01*ones(ny,nz);%自左而右浓度递增
% end

% %沿Z轴浓度变化：土壤深度，即浓度越深养分浓度在【c01,c02】中递减
% for z=1:nz %自下而上
%     u=(z-1)/(nz-1);%nz-1表示网格数
%     C(:,:,z)=c02*u*ones(nx,ny) + (1-u)*c01*ones(nx,ny);%自下而上浓度递增
% end



% Simulate
n0=7; 
r0=5; 
root = createRootSystem(0,0,2*rand(n0,1),zeros(7,1),r0); 
simtime = 60;
str = root;
for i = 1 : simtime
    disp(['Day ' num2str(i)]);
    str = applyRules(str,1); 
    
end
figure;
hold on;

plotTubes(str);

m=zeros(ny,nx,nz);
slice(X,Y,Z,C,0,0,-10);
axis equal;
view(3);
hold on


% a=linspace(-20,20);
% b=linspace(-20,20);
% [A,B]=meshgrid(a,b);
% for i=-7:0.5:-3
% M=linspace(i,i);
% plot3(A,B,M)
% hold on
% end



