function [map,total] = getDensity(str,X,Y,Z,mode,D,GC,TI,TY)
% getDensity: Creates an averaged map over an REV from an L-System string
% Parameters:
% str               l-system string
% X,Y,Z             a rectangular mesh 
% (mode)            'v' :volume, 's' :surface, 'l' :length, 't' :tips;
%                   capital letters to exclude dead root segments (with
%                   color = [0,0,0]). (default mode='s')         
% (D)               diameter classses, default D = [-inf inf].
% (GC)              grey scaled color classes, default GC = [-inf inf].
% (TI)              time classes, default = [-inf inf].
% (TY)              type classes, default = [-inf inf].
% map               map (length, surface or volume units, not density!)                   
% total             total volume, surface or length

if (nargin<5)
    mode='s';
end

if (nargin<6)
    D = [-inf inf];
end

if (nargin<7)
    GC = [-inf inf];
end

if (nargin<8)
    TI = [-inf inf];
end

if (nargin<9)
    TY = [-inf inf];
end


[x1,x2,r,color,time,type]=getSegments(str);
mid = (x1+x2)/2;
len = sqrt(sum((x2-x1).^2,2));
gsc = mean(color,2);
switch mode
    case 'v'
        v = (len.*r.^2.*pi);
    case 's'
        v = (len.*2.*r*pi);
    case 'l'
        v = len;
    case 't'
        v = 1.*isnan(time); 
    case 'V'
        v = (gsc==0).*len.*r.^2*pi; % volume if alive;
    case 'S'
        v = (gsc==0).*len.*2.*r*pi/10; % surface if alive;
    case 'L'
        v = (gsc==0).*len; % length if alive
end
total = sum(v);


x = mid(:,1);
ix = zeros(size(x));
for i = 1 : length(X)-1
    ind = x>=X(i) & x<X(i+1);
    ix(ind) = i;
end

y = mid(:,2);
iy = zeros(size(y));
for i = 1 : length(Y)-1
    ind = y>=Y(i) & y<Y(i+1);
    iy(ind) = i;
end

z = mid(:,3);
iz = zeros(size(z));
for i = 1 : length(Z)-1
    ind = z>Z(i) & z<=Z(i+1);
    iz(ind) = i;
end

id = zeros(size(r));
for i = 1 : length(D)-1
    ind = 2*r>=D(i) & 2*r<D(i+1);
    id(ind) = i;
end

ic = zeros(size(gsc));
for i = 1 : length(GC)-1
    ind = gsc>=GC(i) & gsc<GC(i+1);
    ic(ind) = i;
end

time(isnan(time))=max(time); 
time(isnan(time))=0; 

iti = zeros(size(time));
for i = 1 : length(TI)-1
    ind = time>=TI(i) & time<TI(i+1);
    iti(ind) = i;
end

ity= zeros(size(type));
for i = 1 : length(TY)-1
    ind = type>=TY(i) & type<TY(i+1);
    ity(ind) = i;
end

map = accumarray([ix,iy,iz,id,ic,iti,ity],v',...
    [length(X)-1,length(Y)-1,length(Z)-1,length(D)-1,length(GC)-1,...
    length(TI)-1,length(TY)-1]);

