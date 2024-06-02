function [fv,n] = plotDistFunc(f,x,y,z,color,isovalue)
% plotDistFunc: plots a signed distance function.

if (nargin<5)
    color='blue';
end

if (nargin<6)
    isovalue=0;
end

[X,Y,Z] = meshgrid(x,y,z);
a = size(X,1);
b = size(Y,2);
c = size(Z,3);
n = a*b*c;
X = reshape(X,n,1,1);
Y = reshape(Y,n,1,1);
Z = reshape(Z,n,1,1);
V = f([X Y Z]);
V = reshape(V, a, b, c);

fv = isosurface(x,y,z,V,isovalue);
p = patch(fv);
n = isonormals(x,y,z,V,p);
set(p,'FaceColor',color,'EdgeColor','none');
daspect([1 1 1])
view(3); axis tight;
camlight ;
lighting gouraud
alpha(p,0.2);

