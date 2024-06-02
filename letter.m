function l = letter(name,p,ap,pos,posm)
% letter: creates a l-system letter
%
% Parameters:
% name
% 'F' Forward             p(1) = length
% 'f' Noline forward      p(1) = length
% 'C' Color               p(1:3) = RGB
% '#' Diameter            p(1) = diamter÷±æ∂
% '[' Push turtle state
% ']' Pop turtle state
% '+' Turn left           p(1) = angle
% '-' Turn right          p(1) = angle
% '&' Pitch up            p(1) = angle 
% '^' Pitch down          p(1) = angle
% '\' Roll left           p(1) = angle
% '/' Roll right          p(1) = angle
% '|' Turn around  
% 'r' Roll and turn       p(1) = angle p(2) = angle
% 300 Section growth
% 301 Delay
% 302 Branching
% 303 Create root 
% 304 Create successor
% 305 Root tip that stopped growing
%
% (p)       parameters for first row l(1,3:6) (default = 0)
% (ap)      additional parameters ap(1:N), stored in l(5:end,1:6) (default = [])
% (pos)     position as a struct (default = []);
% (posm)    position matrix (3x6)



if nargin<2
    p=0;
end

if nargin<3
    ap=[];
end

if nargin<4
    pos=[];
end

if nargin<5
    posm=[];
end

p( (length(p)+1):4 ) = 0; % fill with zeros

names = ['F','f','C','#','[',']','+','-','&','^','\','/','|','r'];
id = find(names==name,1,'first');

if isempty(id)
    id = name;
end
   
if id<300 % static commands
    
        l = [id,1,p(1:4)];     
          
else % dynamic commands
    
    rows = 1+3+size(ap,1);
    l = zeros(rows,6);
    l(1,:) = [name,rows,p(1:4)];
    if ~isempty(ap)
        l(5:end,:) = ap;
    end
    if ~isempty(posm)
        l(2:4,:) = posm;
    elseif ~isempty(pos)
        l(2,1:3)=pos.x';
        l(3,1:3)=pos.C;
        l(4,1)=pos.a;
        l(4,2)=pos.t;
        l(2:4,4:6)=pos.R;    
    end
    
end