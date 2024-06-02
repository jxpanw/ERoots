function [seg_info, tip_info]=convert2RSWMSinput(str, pos)
% convert2RSWMSinput: converts the l-system string to RSWMS input parameter
%                     将l系统字符串转换为RSWMS输入参数
% Parameters:
% str           l-system string
% (pos)         initial position (default: pos.x=[0;0;0], pos.a=0.1, pos.R=
%               eye(3)) 
%
% seg_info      segments <Sx11 double> (#, X, Y, Z, connected, order,
%               branchnumber, length, surface, mass (=0), age) 
% tip_info      root tips <Tx8 double> (#, X, Y, Z, segment, order, branchid, length, 0, 0, 0)  

if (nargin<2)
    pos.x=[0;0;0];
    pos.a=0.1;
    pos.R=eye(3);
end

pos.prev = 0; 
pos.bn = 1; 
pos.sC = 1; 

c = 1; 
stkPtr = 1; 
bc = 0;

N = getTotal(str,'f');
X = zeros(N,3);
prev = zeros(N,1);
type = zeros(N,1);
branchnumber = zeros(N,1);
len = zeros(N,1);
surface = zeros(N,1);
time = zeros(N,1);

tips = zeros(N,1);

i=1;
while i<=size(str,1)
    
    l = str(i,:); 
    
    if l(1)==300 
        l(1) = 1;
        l(3) = 1e-9; 
    end
    
    switch l(1)
        case 4 
            pos.a = l(3);
        case 3 
        case 2 
            pos.x = pos.x + l(3)*pos.R(:,1);
        case 1 
            
            if l(3)>0 
                pos.x = pos.x + l(3)*pos.R(:,1);
                X(c,:) = pos.x;
                prev(c) = pos.prev;
                type(c) = l(5); 
                branchnumber(c) = pos.bn;
                len(c) = l(3);
                surface(c) = 2*pos.a*pi*l(3);
                time(c) = l(4);
                pos.prev=c;
                c=c+1;
                pos.sC=pos.sC+1;
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
            stkPtr = stkPtr +1;
            
            if branch(str(i:end,:))
                bc=bc+1; 
                pos.bn = bc; 
            end                        
            
            pos.sC = 1;
            
            
        case 6 % ] pop the stack
            
            if pos.sC>1
                tips(pos.bn) = pos.prev;  
            end
            
            stkPtr = stkPtr -1;
            pos = stack(stkPtr);
    end
    
    i = i + l(2); 
    
end

seg_info = [(1:c-1)',X(:,1),X(:,2),X(:,3),prev,type,branchnumber,len,surface,zeros(c-1,1),time ]; 

tips = tips(1:bc);
blen = zeros(bc,1);
for i = 1 : bc
    blen(i) = sum(len(branchnumber==i));
end        
tip_info = [(1:bc)', X(tips,1),X(tips,2),X(tips,3), tips, type(tips), (1:bc)', ...
    blen, zeros(bc,1), zeros(bc,1), zeros(bc,1) ];

seg_info(:,11) = round(seg_info(:,11)); % round age
[~,ix] = sort(seg_info(:,7)); % sort
seg_info = seg_info(ix,:); 

seg0 = [1,0,0,0,0,0,0,0,0,0,0]; 
seg_info(:,1)=seg_info(:,1)+1; 
seg_info(:,5)=seg_info(:,5)+1; 
seg_info = [seg0; seg_info];



function e = branch(str)
e=0;
stkPtr=1;
i=1;
while i<=size(str,1)
    l = str(i,:); 
    if l(1)==300 
        l(1) = 1;
        l(3) = 1e-9;
    end
    switch l(1)
        case 1 % F
            if l(3)>0 && stkPtr==2 
                e=1;
                break; 
            end
        case 5 % [ push the stack
            stkPtr = stkPtr+1;
        case 6 % ] pop the stack
            stkPtr = stkPtr-1;
            if stkPtr==1
                break;
            end
    end
    i = i + l(2); 
end


