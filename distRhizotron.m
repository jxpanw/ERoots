function d= distRhizotron(p_,x,y,z,alpha)
% distPot: signed distance function of a plant rhizotron geometry.
%
% Parameters:
% p             :points (n,1:3)
% x,y,z         :widths
% alpha         :angle for which the rhizotron is rotated
%
% d             :signded distance of points to the rhizotron boundaries

x1 = -x/2;
x2 = x/2;
z1= -z;
z2= 0;
y1=-y/2;
y2=y/2;

rotX  = [ 1 0 0; 0 cos(alpha) -sin(alpha); 0 sin(alpha) cos(alpha) ];
p = p_*rotX;

d=-min(min(min(min(min(-z1+p(:,3),z2-p(:,3)),-y1+p(:,2)),y2-p(:,2)),-x1+p(:,1)),x2-p(:,1));
