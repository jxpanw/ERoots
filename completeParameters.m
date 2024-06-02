function p = completeParameters(p,df)
% completeParameters: adds missing default root system parameters

global parameters;
global geometry;

if nargin<2
    if isempty(geometry) 
        geometry = @(x) x(:,3);
    end
else 
    geometry = df;
end


defaultoptions=struct('lb',0,'la',10,'ln',0,'nob',0,'r',1,'a',0.01,...
    'color',[150/255,150/255,50/255],'tropism',[1 1 pi/20], 'dx', 0.1, ...
    'successor',[],'theta',70/180*pi,'rlt',inf,'gf',1,'name','unknown',...
    'sef',@(x) 1,'sbpf',@(x) 1,'saf',@(x) 1,'type', 0);

for i = 1 : length(p)
    
    tags = fieldnames(defaultoptions); 
    for j=1:length(tags)
        if(~isfield(p{i},tags{j}))
            p{i}.(tags{j})=defaultoptions.(tags{j}); 
        end

        if isreal(p{i}.(tags{j})) && length(p{i}.(tags{j}))==1 && ...
                ~strcmp(tags{j},'successor');
            p{i}.(tags{j})=[p{i}.(tags{j}),0]; 
        end
    end
    
    if  length(p{i}.tropism)~=3
        warning('completeParameters: Wrong number of tropism arguments');
    end

    % check successors 
    if ~isempty(p{i}.successor)%null
        if size(p{i}.successor,2)==1 
            p{i}.successor(1,2)=1; 
        end
        if sum(p{i}.successor(:,2))>1 
            warning('completeParameters: Successors probabilities > 1');
        end
    else
        if p{i}.nob>0 
            p{i}.successor(1,1)=1; 
            p{i}.successor(1,2)=0; 
        end
    end
    
    % warn
    if(length(tags)~=length(fieldnames(p{i})))
        warning('completeParameters: Unknown options found');
    end       
    
    p{i}.type = i;    
    
end

parameters=p;
