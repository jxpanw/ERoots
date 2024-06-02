function [A,nodes] = getGraph(str, pos)
% getGraph: returns a graph representation of the root system

% Parameters:
% str           list of l-system letters
% (pos)         initial position (default: pos.x=[0;0;0], pos.R=eye(3))
% A             adjacency matrix, entries are the indices of the segments
% nodes         coordinates of the nodes

if (nargin<2)
    pos.x=[0;0;0];
    pos.R = diag([1 1 1]);
end

sC = 1;
nC = 1; 
nodes(nC,:) = pos.x;
sni = 1; 

i=1;
while i<=size(str,1)
    
    l = str(i,:); 
    
    if l(1)==300 
        l(1) = 1;
        l(3) = 1e-9;         
    end
    
    switch l(1)
        case 4 
        case 3 
        case 2 
            pos.x = pos.x + l(3)*pos.R(:,1);
        case 1
            if l(3)>0 
                pos.x = pos.x + l(3)*pos.R(:,1);
                nC=nC+1;
                nodes(nC,:) = pos.x;
                indices(nC-1,:)=[sni,nC]; 
                sni = nC;
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
            stack(sC).x = pos.x;
            stack(sC).R = pos.R;
            stack(sC).sni = sni;
            sC = sC +1 ;
        case 6 % ] pop the stack
            sC = sC -1;
            sni = stack(sC).sni;
            pos.x = stack(sC).x;
            pos.R = stack(sC).R;
    end
    
    i = i + l(2); 
    
end

A = sparse(indices(:,1),indices(:,2),1:nC-1, size(nodes,1),size(nodes,1));
