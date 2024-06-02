function blackLines(X,Y,R,C)
% plotLines: Plots a roots system using lines

if (nargin==1)
     [X,Y,R,C] = getSegments(X);
end

for p=1 : size(X,1)       
    line([X(p,1), Y(p,1)],[X(p,2) Y(p,2)],[X(p,3) Y(p,3)],...
        'LineWidth',1, 'Color', [0 0 0]);
end

axis equal;
bnd = getBounds([],X,Y);
bnd = bnd + [0,0.01,0,0.01,0,0.01,0,0]; 
axis(bnd);
view(0,0)