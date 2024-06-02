function [str,pos] = updatePos(str, pos)
% updatePos: updates positions of relevant letters

if nargin<2
    pos.x=[0;0;0];
    pos.C=[0,0,0]; 
    pos.a=0.1;
    pos.t=0;
    pos.R=eye(3);
end

stkPtr = 1; 
i=1;

while i<=size(str,1)
    l = str(i,:);   
    if l(1)<300 
        switch l(1)
            case 4 % #
                pos.a =l(3);
            case 3 % C
                pos.C = l(3:5);
            case 2 % f
                pos.x = pos.x + l(3)*pos.R(:,1);
            case 1 % F
                pos.x = pos.x + l(3)*pos.R(:,1);
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
    else % dynamic letter 
        if nargin==2
            str(i+1:i+3,:) = [[pos.x'; pos.C; pos.a, pos.t, 0],pos.R];        
        else
            str(i+1:i+3,:) = [[pos.x'; pos.C; pos.a, str(i+3,2), 0],pos.R];  % dont modify ct
        end
    end
    
    i = i + l(2); 
    
end