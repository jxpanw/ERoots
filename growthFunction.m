function len = growthFunction(t, p, pos, invert)
% growthFunction: determines root length at a given time


if nargin<4
    invert = false;
end

id = p(1);
r = p(2);
k = p(3);

if ~invert 
    
    switch id
    
        case 1 
             len = k*(1-exp(-(r/k)*(t+8)));
                 %len = k*(1-exp(-(r/k)*t));
                % len=k*p*exp(r*t)/(k+p*(exp(r*t)-1));
               %  len=-0.103*t^3+10.801*t^2-127.17*t+410.78;
               % len=-r*(k/3*T^3)*t^3+r*(k/2*T^2)*t^2+410.78;
              %len = -0.05275*t^3+5.566*t^2+k;
        case 2
            len = min(k,r * t);
       
        otherwise
            disp(['Error: ' num2str(id)]);
            
    end
        
else
    
    switch id
        
        case 1 
            k = k*1.001; 
            len = t;
            t = - k/r*log(1-len/k)-8;
            %t = - k/r*log(1-len/k);
           %t=log((k*t - p*t)/(k*p - p*t))/r;
          % t=(((1/(8*T^3) - (3*(len - 1300))/(2*T^3*k*r))^2 - 1/(64*T^6))^(1/2) + 1/(8*T^3) - (3*(len - 1300))/(2*T^3*k*r))^(1/3) + 1/(4*T^2*(((1/(8*T^3) - (3*t - 3900)/(2*T^3*k*r))^2 - 1/(64*T^6))^(1/2) + 1/(8*T^3) - (3*len - 3900)/(2*T^3*k*r))^(1/3)) + 1/(2*T)         
             len = t;    
        case 2 
            len = t;        
            t = len/r;   
            len = t;             
        otherwise 
            len = fzero(@(t_) growthFunction(t_,p,pos)-t,[0,3650]);
            
    end    
    
end

