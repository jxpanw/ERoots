function [lines,radii,colors,times,types,indS,indE] = getPolylines(str, pos)
% getPolyline: interprets an l-system string graphically
% The function returns a list of polylines, radii, colors and segment creation times. Every poly line represents a single root axis. 

% Parameters:
% str           l-system letters
% (pos)         initial position (default: pos.x=[0;0;0],  pos.C=[0,0,0],
%               pos.a=0.1, pos.t=0, pos.R=eye(3)
%
% lines         a list of vectors of points, {1:nor}(1:nov(r)), where nor:
%               number of roots, nov: number of vertices per root
% radii         a vector of diameters, (1:nor)
% colors        a vector of stream colors, {1:nor}(1:nov(r)-1,3)
% times         a list of segment creation times, {1:nor}(1:nov(r)-1)
% types         a vector of stream root type indices (1:nor)
% indS          a list of segment indices, {1:nor}(1:nov(r)-1)
% indE          a list of edge indices, {1:nor}(1:noe(r))

if (nargin<2)
    pos.x=[0;0;0];
    pos.C=[0,0,0]; 
    pos.a=0.1;
    pos.t=0;
    pos.R=eye(3);
end

vC = 1; 
stC = 1; 
nofST = 1; 
stkPtr = 1; 

lines{stC}(vC,:) = pos.x;
times{stC}(vC) = 0;
radii(stC) = pos.a;
colors{stC}(vC,1:3)  = pos.C;
types(stC) = 0;

lastType = 0;

indS{stC}(vC) = 0;


eC = 1; 
sC = 1; 
indE{stC} = [];

vC = vC + 1;

i=1;
while i<=size(str,1)
    
    l = str(i,:);

    if l(1)==300 
        l(1) = 1;
        l(3) = 1e-9;
    end           
    
    switch l(1)
        case 4 % #
            pos.a = l(3);
        case 3 % C
            pos.C = l(3:5); 
        case 2 % f
            pos.x = pos.x + l(3)*pos.R(:,1);
        case 1 % F
            
            if l(3)>0 
                pos.x = pos.x + l(3)*pos.R(:,1);
                lines{stC}(vC,:) = pos.x;
                times{stC}(vC-1) = l(4); % time
                indS{stC}(vC-1) = sC;
                colors{stC}(vC-1,1:3) =pos.C(1:3);
                vC = vC + 1;
                sC = sC + 1; % segment counter
                lastType = l(5);                
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
            stack(stkPtr) = pos;
            stack2(stkPtr).vC = vC;
            stack2(stkPtr).stC = stC;
            stkPtr = stkPtr +1 ;
            stC  = nofST + 1; % start new stream
            nofST = nofST +1;
            vC = 1;
            lines{stC}(vC,:) = pos.x;
            times{stC} = [];
            indS{stC} = [];
            colors{stC} = [];
            indE{stC} = [];
            vC = vC +1;
            
        case 6 % ] pop the stack
            
            radii(stC) = pos.a;
            types(stC) = lastType;
            stkPtr = stkPtr - 1;
            pos = stack(stkPtr);
            vC = stack2(stkPtr).vC;
            stC = stack2(stkPtr).stC;
            
    end
    
    i = i + l(2); 
    
end

I=[];
for i = 1 : size(lines,2) 
    if size(lines{i},1) == 1
        I = [I,i];
    end
    if size(lines{i},1)<3
       disp(lines{i});
    end
end
lines(I)=[];
radii(I)=[];
colors(I)=[];
times(I)=[];
types(I)=[];
indS(I)=[]; 
indE(I)=[]; 


