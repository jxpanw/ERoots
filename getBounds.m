function res=getBounds(str, X, Y)
% getBounds: Returns the spatial bounds of an L-System string.

if (nargin==1)
    [X,Y] = getSegments(str);
end

if (nargin==2) 
    p1 = min(X{1},[],1);
    p2 = max(X{1},[],1);
    for i=2 : length(X)
        p1=min(min(X{i},[],1),p1);
        p2=max(max(X{i},[],1),p2);    
    end
end  
  
if (nargin==1 ||nargin==3)
    p1 = min(min(X,[],1),min(Y,[],1));
    p2 = max(max(X,[],1),max(Y,[],1));     
end

res = [p1(1),p2(1),p1(2),p2(2),p1(3),p2(3),0,1];   

