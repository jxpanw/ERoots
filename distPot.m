function d = distPot(p,r1,r2,h)
% distPot: signed distance function of a plant pot geometry.
% Parameters:
% p             :points (n,1:3)
% r1            :top radius
% r2            :bottom radius
% h             :height
% d             :signded distance of points to the pot boundaries 

z = p(:,3)/h;         
r =  (1+z)*r1 - z*r2;
d=sqrt((p(:,1)).^2+(p(:,2)).^2)-r;
d = max(d, -min(h+p(:,3),0-p(:,3)));


