plotTubes(str{35});
hold on
r1=8;
r2=5;
m=20;
pot = @(p) distPot(p,r1,r2,m);
X_ = linspace(-r1,r1,100); 
Y_ = linspace(-r1,r1,100);
Z_ = linspace(-m,0,40);
plotDistFunc(pot,X_,Y_,Z_,[232/256 232/256 232/256]);
view(3);
