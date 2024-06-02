function new=applyRules(str, dt)
% applyRules: applies the production rules of an l-system string.
%
% Parameters:
% str                   l-system string
% dt                    time step
% new                   l-system string

if (size(str,1)==str(1,2)) % one letter
    
    new = applyRule(str,dt);
    
else % more than one letter
    
    new=[]; 
    
    rind = find(str(:,1)>=300 & str(:,1)~=305); % indices of dynamic letters
    
    if isempty(rind) 
        new = str;
        return
    end
    
    j=1;
    i0 = 1;
    endi = 0;
    
    while j<=length(rind)
        
        i1 = rind(j);
        
        new(endi+1:endi+i1-i0,:) = str(i0:i1-1,:); 
        endi=endi+i1-i0;
        
        nl = applyRule(str(i1:i1+str(i1,2)-1,:),dt);  
        
        if ~isempty(nl)
            new(endi+1:endi+size(nl,1),:) = nl;
            endi=endi+size(nl,1);
        end
        
        i0=i1+str(i1,2);       
        
        while j<=length(rind) && i0>rind(j)
            j=j+1;
        end
        
    end
    
    new(endi+1:endi+size(str,1)-i0+1,:) = str(i0:end,:);  
    endi=endi+size(str,1)-i0+1;
        
    new = new(1:endi,:);
    
end




function nl = applyRule(l, dt)
% applyRule: applies production rule of a single l-system letter
%
% l         l-system letter
% dt        time step
%
% nl        l-system string


global parameters; % parameter set of each root type

id = l(1);

switch id
    
    case 300 % SECTION GROWTH
        
        % Parameters
        len = l(1,3); % length
        t = l(1,4); % age of section
        type = l(1,5); % type of root
        pos = getPosition(l(2:4,:));
        pgf = l(5,1:3); % parmaters for the growth function
        ptr = l(5,4:6); % parameters for tropism
        t0 = l(6,1); % section start time
        tend = l(6,2); % section end time
        l0 = l(6,3); % section start length
        lend = l(6,4); % section end length
        rlt = l(6,5); % root life time
        dx = l(6,6); % axial resolution
        heading = l(7,1:3); % initial heading of the root
        
        ls = lend-l0; % section length
        A = min(l0+len+dx,lend) <= growthFunction(t0+t+dt*parameters{type}.sef(pos),pgf);
        
        if t0+t < rlt
            if  A && (len+dx < ls) % new segments
                
                l(1,3) = len+dx;
                lf = letter('F',[dx,pos.t,type]);
                lt = tropism(ptr,heading,pos,dx);
                l(2:4,:) = updatePos2(dx,lt,l(2:4,:)); % special fast update
                nl = [lt;lf;applyRule(l, dt)];       
            
            elseif A && (len+dx >= ls) % end, next segment
                lr = ls-len;
                ct = t0 + t + dt - tend; % Initialize
                if (lr>0)
                    
                    next = l(8:l(1,2),:);             
                    pos.t = pos.t+dt-ct;
                    l(4,2) = l(4,2)+dt-ct;                    
                    lf = letter('F',[lr,pos.t,type]);
                    lt = tropism(ptr,heading,pos,dx);    
                    if next(1,1)>=300
                        next(2:4,:) = updatePos2(lr,lt,l(2:4,:)); 
                    end
                    nl = [lt;lf;applyRule(next, ct)];                                  
                    
                else
                    
                    next = l(8:l(1,2),:); % copy successor 
                    pos.t = pos.t+dt-ct;
                    if next(1,1)>=300
                        next(2:4,:) = l(2:4,:); 
                    end
                    nl = applyRule(next,ct); 
                    
                end
            else % increase time
                
                l(1,4) = t+dt; % section age
                l(4,2) = pos.t+dt; % root age
                nl = l;
                
            end
        else   % branch is dead and stops growing
            
            nl = letter('F',[0,pos.t+dt,type]);
            
        end
        
    case 301 % DELAY
        
        % Parameters
        t = l(1,3);
        tend = l(1,4);
        
        if (t+dt>tend) % finished
            ct = t+dt-tend;
            l(4,2) = l(4,2)+dt-ct;
            next = l(5:l(1,2),:); 
            pos = getPosition(l(2:4,:));
            next = updatePos(next,pos);
            nl = applyRules(next,ct);
        else % do nothing
            l(1,3) = t+dt;
            l(4,2) = l(4,2)+dt;
            nl = l;
        end
        
    case 302 % BRANCHING
        l(1,3)=l(1,3)+1; % next branch
        
        % Parameters
        c = l(1,3);  % index of current branch
        nob = l(1,4); % number of branches
        type = l(1,5); % type of root
        pos = getPosition(l(2:4,:));
        pgf = l(5,1:3); % parmaters for the growth function
        ptr = l(5,4:6); % parameters for tropism
        rlt = l(6,1); % root life time   
        dx = l(6,2); % axial resolution
        heading = l(6,4:6); % initial heading of the root
        rows = ceil(nob/6);
        times = reshape(l(7:7+rows-1,:),6*rows,1); % times of emergence of branches
        delays = reshape(l(7+rows:7+2*rows-1,:),6*rows,1); % delays for laterals
        indL = 7+2*rows;
        indN = indL+l(indL,2);
        
        
        lateral = l(indL:indN-1,:);  
        
        
        next = l(indN:indN+l(indN,2)-1,:); % after the branching zone        

        d = letter(301,[0,delays(c)],lateral,[],l(2:4,:)); % delayed branch
        
        if (c<nob)  % section growth, then continue branching

            t0 = times(c);
            tend = times(c+1);
            l0 = growthFunction(t0,pgf,pos);
            lend =  growthFunction(tend,pgf,pos);         
            s = letter(300,[0,0,type],[pgf,ptr;t0,tend,l0,lend,rlt,dx; ...  
                heading 0 0 0; l(1:l(1,2),:)],[],l(2:4,:)); % section growth
        else % next
            s = next;
            if s(1,1)>=300

                s(2:4,:)=l(2:4,:); % set position
            end
        end
        
        nl = applyRules([d; s],dt);
        
    case 303 % CREATE ROOT
        
        % Parameters
        type = l(1,3);
        p = parameters{type};
 

        pos = getPosition(l(2:4,:));
        la = max(p.la(1)+randn*p.la(2),0); % length of apical zone
        lb = max(p.lb(1)+randn*p.lb(2),0); % length of basal zone
        nob = max(round(p.nob(1)+randn*p.nob(2)),0); % number of branches        
        ln = max(p.ln(1)+randn(nob-1,1)*p.ln(2),1e-6); % inter-branch distance
        a = max(p.a(1)+randn*p.a(2),1e-4); % root radius
        theta = min(max(p.theta(1)+randn*p.theta(2),0),pi); % inter-root angle        
        r = max(p.r(1)+randn*p.r(2),0); % initial growth speed
        rlt=max(p.rlt(1)+randn*p.rlt(2),0);  %root life time
        dx = p.dx(1); % resolution along root axis
        k = la+lb+sum(ln); % total length of fully grown root
        pgf = [p.gf(1), r, k]; % parameters for the growth function
        ptr = p.tropism; % parameters for tropism
        
        theta = theta*parameters{type}.saf(p); %scale angle 
        
        % if the root has a life span
        die = [];
        if (rlt~=inf)
            dc = letter('C',[0,0,0]);
            die = letter(301,[0,rlt],dc,pos); % delay
        end
        
        % initial string
        initial = [letter('['); letter('#',a); letter('C',p.color); ...
            die; letter('\',rand*2*pi); letter('+',theta)];
        [~,pos] = updatePos(initial,pos);
        
        % create root
        if r>0 && k>0 && rlt>0
            
            if la>0 % apical zone
                l0 = k-la;
                lend = k;
                t0 = growthFunction(l0,pgf,pos,true);
                tend = growthFunction(lend,pgf,pos,true);
                apical = letter(300,[0,0,type],[pgf,ptr;t0,tend,l0,lend,rlt,dx;...
                    pos.R(:,1)' 0 0 0; letter(305)] ); % section growth
            else
                apical = letter('|');
            end
            
            if nob>0 % branching zone
                % define lateral
                s = p.successor(:);
                s2 = zeros(ceil(length(s)/6)*6,1);
                s2(1:length(s)) = s;
                s2=reshape(s2,ceil(length(s)/6),6);
                lateral = letter(304,[length(s)/2,type],s2);
                % define branching zone
                l = lb + [0; cumsum(ln)];
                times = zeros(ceil(length(l)/6)*6,1);
                times2 = zeros(ceil(length(l)/6)*6,1);
                for j = 1 : length(l)
                    times(j) = growthFunction(l(j),pgf,pos,true);
                    times2(j) = growthFunction(l(j)+la,pgf,pos,true);
                end
                delays = times2 - times;
                times = reshape(times,ceil(length(l)/6),6);
                delays = reshape(delays,ceil(length(l)/6),6);
                branching = letter(302,[0,nob,type],[pgf,ptr; rlt, dx, 0, ...
                    pos.R(:,1)'; times; delays; lateral; apical]);
            else
                branching=apical;
            end
            
            if lb>0 % basal zone
                l0 = 0;
                lend = lb;
                t0 = 0;
                tend = growthFunction(lend,pgf,pos,true);
                basal = letter(300,[0,0,type],[pgf,ptr;t0,tend,l0,lend,rlt,dx;...
                    pos.R(:,1)' 0 0 0; branching],pos); % section growth
            else
                basal=branching;
                if basal(1,1) >= 300
                    basal(2:4,:) = [[pos.x'; pos.C; pos.a, pos.t, 0],pos.R]; % set position
                end
            end
            
            nr = applyRule(basal,dt);  %apply time overhead
            nl = [initial; nr; letter(']')]; 
            
        else
            nl =[];
        end
        
    case 304 % CREATE SUCCESSOR ROOT
        
        % Parameters
        c = l(1,3);
        type = l(1,4);
        
        if c==1 % one successor
            if rand<=l(5,2)
                i = l(5,1);
            else
                i = 0;
            end
        else % more than one possible successor
            rows = ceil((2*c)/6);
            ind = l(5:4+rows,:);
            ind = ind(:);
            rti = ind(1:c); % root type indices
            p = ind(c+1:2*c); % probabilites
            sp = [1-sum(p); cumsum(p(:))];
            i = sum(rand>sp);
            if i>0
                i = rti(i);
            end
        end
        
        if i>0
            p = getPosition(l);
            if rand() < 1-(1-parameters{type}.sbpf(p))^dt

                nl = letter(303,i,[],[],l(2:4,:)); % create new root of type i
                nl = applyRule(nl,dt);
            else 
                nl = l;
            end
        else % create no root
            nl = [];
        end
        
    case 305 % root tip that stopped growing
        
        nl = l;
        
    otherwise 
        
        nl = l;
        
end



function pos = getPosition(l)
% getPosition: copies paramters into a struct for better readability
%
pos = struct('x',l(1,1:3)','C',l(2,1:3),'a',l(3,1),'t',l(3,2),'R',l(:,4:6));


function pos = updatePos2(dx,t,pos)
% fast position update for single segment 
%
R = pos(:,4:6);
a = t(4); % beta
R = R * [ 1 0 0; 0 cos(a) -sin(a) ; 0 sin(a)  cos(a) ] ;
a = t(3); % alpha
R = R * [ cos(a) sin(a) 0; -sin(a) cos(a) 0; 0 0 1 ];
pos(:,4:6) = R;
x = pos(1,1:3);
x = x + dx*R(:,1)';
pos(1,1:3)=x;
