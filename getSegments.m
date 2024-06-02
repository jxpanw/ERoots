function [x1,x2,r,color,time,type,indS]=getSegments(str, pos)
% getSegments: gets segments, radii, and other attributes of a root system
% Parameters:
% str           l-system string
% (pos)         initial position (default: pos.x=[0;0;0],  pos.C=[0,0,0],
%               pos.a=0.1, pos.t=0, pos.R=eye(3))       
% x1            :start points of segments
% x2            :end points of segments
% r             :radii of segments
% color         :color of segments
% time          :creation times of segments
% type          :index of root type
% indS          :index within the l-system string


if (nargin<2)
    pos.x=[0;0;0];
    pos.C=[0,0,0]; 
    pos.a=0.1;
    pos.t=0;
    pos.R=eye(3);
end

c = 1; % segment counter
stkPtr = 1; 

N = getTotal(str,'f');
x1 = zeros(N,3);
x2 = zeros(N,3);
r = zeros(N,1);
color = zeros(N,3);
time = zeros(N,1);
type = zeros(N,1);
indS = zeros(N,1);

i=1;
while i<=size(str,1)

    l = str(i,:); 
    
    if l(1)==300 
        l(1) = 1;
        l(3) = 1e-9; 
        l(4) = nan; 
    end       
    
    switch l(1)
        case 4  
            pos.a = l(3); 
        case 3 
            pos.C = l(3:5);
        case 2 
            pos.x = pos.x + l(3)*pos.R(:,1);    
        case 1 
            if l(3)>0 
                time(c) = l(4);
                indS(c) = i;
                x1(c,:) = pos.x;
                pos.x = pos.x + l(3)*pos.R(:,1);
                x2(c,:) = pos.x;
                      r(c)=pos.a;
                color(c,:)= pos.C;
                type(c) = l(5); 
                c=c+1;
            end
        case 7 % +
            a = l(3);
            pos.R = pos.R * [ cos(a) -sin(a) 0; sin(a) cos(a) 0; 0 0 1 ];
        case 8 % -
            a = l(3);
            pos.R = pos.R * [ cos(a) sin(a) 0; -sin(a) cos(a) 0; 0 0 1 ];
        case 9 % &
            a = l(3);
            pos.R = pos.R * [ cos(a) 0  -sin(a) ; 0 1 0; sin(a) 0 cos(a) ];
        case 10 % ^ 
            a = l(3);
            pos.R = pos.R * [ cos(a) 0 sin(-a) ; 0 1 0; -sin(a) 0 cos(a)];
        case 11 % \ 
            a = l(3);
            pos.R = pos.R * [ 1 0 0; 0 cos(a) -sin(a) ; 0 sin(a)  cos(a) ] ;
        case 12 % /
            a = l(3);
            pos.R = pos.R * [ 1 0 0; 0 cos(a) sin(a) ; 0 -sin(a) cos(a) ];
        case 13 % | 
            pos.R = pos.R * [ cos(pi) sin(pi) 0; -sin(pi) cos(pi) 0; 0 0 1];
        case 14 % r
            a = l(4); % beta
            pos.R = pos.R * [ 1 0 0; 0 cos(a) -sin(a) ; 0 sin(a)  cos(a) ] ;
            a = l(3); % alpha
            pos.R = pos.R * [ cos(a) sin(a) 0; -sin(a) cos(a) 0; 0 0 1 ];                        
        case 5 % [ push the stack
            stack(stkPtr) = pos ;
            stkPtr = stkPtr +1 ;
        case 6 % ] pop the stack
            stkPtr = stkPtr -1;
            pos = stack(stkPtr);
    end
    
    i = i + l(2);
    
end


