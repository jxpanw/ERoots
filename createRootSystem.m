function rootsystem = createRootSystem(X,Y,cd,cz,cr,ce)
% createRootSystem: creates multiple taproots 
% Parameters:
% (X)            x-coordinates of seeds (default = 0)
% (Y)            y-coordinates of seeds (default = 0)
% (cd)           delays of basal roots (default = [0])
% (cz)           z-coordinates of basal roots (default = [0])
% (cr)           initial radius of growth cone (default = 0)
% (ce)           exponent (0.5 for uniform distribution, >0.5 more inner,
%                 <0.5 more outer) (default=0.5)
%
%
% rootsystem     initial l-system string of the root system

    

global parameters;

if isempty(parameters)
    error('createRootSystems: parameters not set use completeParameters to set global parameters');
end

if (nargin<1)
    X = 0;
end

if (nargin<2)
   Y = zeros(size(X,1),1);
end

if (nargin<3)
    cd = 0;    
end

if (nargin<4)
    cz = zeros(length(cd),1);    
end
 
if (nargin<5) 
    if length(cd)==1;
      cr = 0;
    else
        cr = 1;
    end
end

if (nargin<6) 
    ce = 0.5;
end


taproot = letter(303,1); 
push = letter('[');
pop = letter(']');
pitchdown  = letter('^',pi/2);
pitchup= letter('&', pi/2);
turnaround = letter('|');

crown = [];
for i = 1 : length(cd)
    theta = atan(rand^ce*(cr));  
    fup = letter('f',cz(i)); 
    r = [letter('\',rand*2*pi); letter('+',theta)];   
    if cd(i)~=0
        dr = letter(301,[0 cd(i)],taproot); % delay
    else
        dr = taproot;
    end
    crown = [crown; push; turnaround;fup;turnaround; r; dr;pop];    % z position of primaries
end



rootsystem = [pitchdown;letter('f',1);pitchup];  
for i = 1 : length(X)
    l = sqrt(X(i)^2+Y(i)^2);
    theta = atan2(Y(i),X(i));
    f = letter('f',l);
    turn = letter('+',theta);
    rootsystem = [rootsystem; push;turn; f; pitchdown; crown;pitchup; pop];
end


rootsystem = updatePos(rootsystem);

