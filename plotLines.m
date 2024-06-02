function plotLines(X,Y,R,C)
% plotLines: Plots a roots system using lines

if (nargin==1)
    [X,Y,R,C] = getSegments(X);
end

% draw lines
for i=1 : size(X,1)
    line([X(i,1), Y(i,1)],[X(i,2) Y(i,2)],[X(i,3) Y(i,3)],...
        'LineWidth',2, 'Color', C(i,:));
end

axis equal;
bnd = getBounds([],X,Y);
bnd = bnd + [0,0.01,0,0.01,0,0.01,0,0]; 
axis(bnd);
view(0,0)
rotate3d on