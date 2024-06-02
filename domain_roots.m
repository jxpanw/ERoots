p=cell(4,1);
p{1}.name = 'seminalroots';
p{1}.r = [1.5,0];
p{1}.lb = [25,0];          
p{1}.la = [0,0];                    
p{1}.ln = [0,0];                 
p{1}.nob = [0,0];  
p{1}.a = 0.1;   
p{1}.theta = [20/180*pi,5/180*pi];
p{1}.color = [0,0,1]; % red
p{1}.tropism = [1,2,10*pi/180];  
p{1}.dx= 0.25; 
p{1}.successor = 2;

p{2}.name = '1roots';
p{2}.r = [1,0];
p{2}.lb = [2,0];          
p{2}.la = [6,0];                    
p{2}.ln = [1,0];                 
p{2}.nob = [8,0];  
p{2}.a = 0.08;   
p{2}.theta = [50/180*pi,5/180*pi];
p{2}.color = [0,1,0]; 
p{2}.tropism = [1,2,10*pi/180];  
p{2}.dx= 0.25; 
p{2}.successor = 4;

p{3}.name = '2roots';
p{3}.r = [0.6,0];
p{3}.lb = [2,0];          
p{3}.la = [5,0];                    
p{3}.ln = [2,0];                 
p{3}.nob = [6,1];  
p{3}.a = 0.05;   
p{3}.theta = [40/180*pi,5/180*pi];
p{3}.color = [0,0,1]; 
p{3}.tropism = [1,1.5,10*pi/180]; 
p{3}.dx= 0.25; 
p{3}.successor =5;

p{4}.name = '3roots';
p{4}.r = [0.6,0];
p{4}.lb = [5,0];          
p{4}.la = [0,0];                    
p{4}.ln = [0,0];                 
p{4}.nob = [0,1];  
p{4}.a = 0.05;   
p{4}.theta = [30/180*pi,5/180*pi];
p{4}.color = [0,0,1]; 
p{4}.tropism = [1,1.5,10*pi/180]; 
p{4}.dx= 0.25; 
p{4}.successor =[];

p{5}.name = 'advroots';
p{5}.r = [1.5,0];
p{5}.lb = [2,0];          
p{5}.la = [8,0];                    
p{5}.ln = [3,0];                 
p{5}.nob = [10,0];  
p{5}.a = 0.1;   
p{5}.theta = [70/180*pi,5/180*pi];
p{5}.color = [163/255,99/255,9/255]; 
p{5}.tropism = [1,2,10*pi/180]; 
p{5}.dx= 0.25; 
p{5}.successor = 3;


r1=7;
r2=4;
h=15;
pot = @(p) distPot(p,r1,r2,h);


simtime = 60;
p = completeParameters(p,pot);
set(0,'RecursionLimit',10000);
n0=7; 
r0=5; 
str = createRootSystem(0,0,2*rand(n0,1),zeros(7,1),r0);
for i = 1 : simtime
    disp(['Day ' num2str(i)]);
     str = applyRules(str,10); 
end
figure;
hold on;

plotTubes(str);
X_ = linspace(-r1,r1,100); 
Y_ = linspace(-r1,r1,100);
Z_ = linspace(-h,0,40);
plotDistFunc(pot,X_,Y_,Z_,[0 0 1]); 
view(3);




