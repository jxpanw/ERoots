function rootsystem = createMonocotRS(depth,firstB,delayB,maxB,dzB,firstCR,delayCR,nCR,delayRC,dzRC)
% createRootSystem: creates multiple taproots 
% Parameters:
% depthB      3       planting depth (cm)
% firstB      3      first basal roots [mean, sd] (days)
% delayB      7       time delay between basal roots [mean, sd] (days)
% maxB        100       maximal number of basal roots
% dzB                distance upwards the hypocotyl per basal root [mean,sd] (cm) 
% firstRC     12       first shootborne or root crown (days)
% nCR         11      number of root crowns 
% delayCR      3      delay between shootbore crown roots (days)
% delayRC     33      delay between root crowns (days)
% dzRC         1      distance between root crowns along shoot (cm)  
%
% rootsystem     initial l-system string of the root system
  

global parameters;

if isempty(parameters)
    error('createRootSystems: parameters not set use completeParameters to set global parameters');
end

if nargin<9
    delayRC = Inf;
end

if nargin<10
    dzRC = 0;
end
  
firstB = [firstB,0];
delayB = [delayB,0];
dzB = [dzB,0];
firstCR = [firstCR,0];
delayCR = [delayCR,0];
nCR = [nCR,0];
delayRC = [delayRC,0];
dzRC = [dzRC,0];

%
% initialize
%
taproot = letter(303,1); 
basal = letter(303,5); 
shootborne = letter(303,6); 
push = letter('[');
pop = letter(']');
pitchdown  = letter('^',pi/2);
turnaround = letter('|');



N = round((365-firstB(1))/delayB(1));  
N = min(N,maxB); 

ct = firstB(1)+randn()*firstB(2);
cz = 0;
str = [push; taproot; pop];
for i = 1 : N
    cz = cz+dzB(1)+randn()*dzB(2);
    fup = letter('f',cz);  
    ct = ct + delayB(1)+randn()*delayB(2);
    if ct>0
        root = letter(301,[0 ct],basal); % delay
    else
        root = basal;
    end
    str = [str; push; turnaround; fup; turnaround; root; pop]; 
end


N = round((365-firstCR(1))/delayRC(1)); 

delay0 = firstCR(1)+randn()*firstCR(2); 

for i = 1 : N 
    
    crown{i} = [];
    NCR = round(nCR(1)+randn()*nCR(2));
    delay = delay0;
    alpha0 = rand()*2*pi; 
    for j = 1 : NCR  
        
        alpha = (2*pi/NCR)*j+alpha0;
        theta = parameters{5}.theta(1)+randn()*parameters{5}.theta(2);
        r = [letter('\',alpha); letter('+',theta)];
      
        
        if delay~=0
            dr = letter(301,[0 delay],shootborne); % delay
        else
            dr = taproot;
        end        
        crown{i} = [crown{i}; push; r; dr; pop];        

        delay = delay + delayCR(1)+randn()*delayCR(2);        
        
    end
    
    delay0 = delay0+delayRC(1)+randn()*delayRC(2); 
    
end

if N>0
    fup = letter('f',depth/2);
    crownroots = [ push; turnaround; fup; turnaround; crown{1}; pop;];
    cz = 0;
    for i = 2 : N
        cz = cz+dzRC(1)+randn()*dzRC(2);
        fup = letter('f',depth/2+cz);
        crownroots = [crownroots; push; turnaround; fup; turnaround; crown{i}; pop];
    end
else
    crownroots = [];
end

 
rootsystem = [pitchdown;letter('f',depth);str; crownroots];  
rootsystem = updatePos(rootsystem);
