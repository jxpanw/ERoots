function t = getTotal(str, mode, radii)
% getTotal: Returns the total surface, volume or length of a root system

% Parameters:
% str         list of L-System letters
% (mode)      'v' :volume, 's' :surface, 'l' :length, 'f' :we;
%             to exclude dead root segments use capital letters (death
%             color = [0,0,0]) (default: mode='l').
% (radii)     vector of a partition of radii (default: radii=[0 inf]).半径划分的向量
% t           total surface, volume or length


if nargin<2
    mode = 'l';
end

if nargin<3
    radii = [];
    t=0;
else
    t=zeros(1,length(radii)-1); 
end

if nargin<3 && mode=='l' 
    t=0;
    i=1;
    while i<=size(str,1)        
        t = t + str(i,3)*(str(i,1)==1); 
        i = i + str(i,2); 
    end
    return
end


if nargin<3 && mode=='f' 
    t=0;
    i=1;
    while i<=size(str,1)  
        if i~=round(i)  
            disp('stop');
        end
        t = t + (str(i,1)==1)*(str(i,3)>0)+(str(i,1)==300); 
        i = i + str(i,2); 
    end
    return
end

stkPtr = 1;
pos.a = 0.05; 
pos.c = 1; 

i=1;
while i<=size(str,1)
    
    l = str(i,:); 

    if l(1)==300 
        l(1) = 1;
        l(3) = 1e-9;       
    end    
    
    switch l(1)
        case 4 % #
            pos.a =l(3);
        case 3 % C
            pos.c = mean(l(3:5)); % mean color
        case 1 % F
            lenF = l(3); % length
            switch mode
                case 'v'
                    v = lenF*(pos.a)^2*pi; % volume
                case 's'
                    v = lenF*pos.a*pi*2; % surface
                case 'l'
                    v = lenF; % length
                case 'f'
                    if lenF>0
                        v = 1; % number of segments
                    else 
                        v = 0;
                    end
                case 'V'
                    if (pos.c~=0)
                        v = lenF*(pos.a)^2*pi; 
                    else
                        v=0;
                    end
                case 'S'
                    if (pos.c~=0)
                        v = lenF*pos.a*pi*2; 
                    else
                        v=0;
                    end
                case 'L'
                    if (pos.c~=0)
                        v = lenF; 
                    else
                        v=0;
                    end
                case 'F'
                    if (pos.c~=0)
                        v = 1; 
                    else
                        v=0;
                    end
            end
            if isempty(radii)
                t = t+v;
            else
                j=length(radii(radii<=pos.a));
                if (j>0 && j<=length(t))
                    t(j) = t(j) + v;
                end
            end
        case 5 % [ push the stack
            stack(stkPtr) = pos ;
            stkPtr = stkPtr +1 ;
        case 6 % ] pop the stack
            stkPtr = stkPtr -1;
            pos = stack(stkPtr);
    end   
    
    i = i + l(2); 
    
end

