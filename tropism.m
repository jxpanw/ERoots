function l=tropism(tp,ap,pos,dx,s)
% getTropism:
%
% tp            tropism parameters (type,N,sigma),  
% ap            additional parameters
% pos           global position
% dx            axial resolution
% (s)           random stream (default: global stream)


global geometry; 
if nargin<5
    s = RandStream.getGlobalStream;
end

[alpha,beta] = tropism2(tp,ap,pos,dx,s); 

d = geometry(testAlphaBeta(alpha,beta,pos,dx));

i=0;
dmin=inf;
while (d>0) 
    i=i+1;
    j=0;
    while d>0 && j<5
        beta = 2*pi*rand(s); 
        d = geometry(testAlphaBeta(alpha,beta,pos,dx));
        if (d<dmin)
            dmin=d;
            bestA = alpha;
            bestB = beta;
        end
        j=j+1;
    end
    if d>0
        alpha=abs(alpha)+pi/40; 
    end
    if i>20
        alpha=bestA;
        beta=bestB;
        break
    end
end

l = letter('r',[alpha,beta]); 



function x = testAlphaBeta(alpha,beta,pos,dx)
% testAlphaBeta: returns coordinates moving in new direction 

R = pos.R * [ 1 0 0; 0 cos(beta) -sin(beta); 0 sin(beta) cos(beta) ];  
R = R * [ cos(alpha) sin(alpha) 0; -sin(alpha) cos(alpha) 0; 0 0 1 ]; 
x(1:3) = pos.x + dx*R(:,1);



function [alpha, beta] = tropism2(tp,ap,pos,dx,s) 
% tropism: constrains the tropsim 
if tp(1) == 3
    objfun = tropismObjective(tp(1),dx); 
else
    objfun = tropismObjective(tp(1),ap); 
end
N = tp(2);
sigma = tp(3);

alpha = sigma*randn(s)*sqrt(dx); 
beta = rand(s)*2*pi;

if N>0
    N=N*sqrt(dx); 
    dn = N-floor(N); 
    if dn>0
        if rand(s)<dn
            N=ceil(N);   
        else
            N=floor(N);
        end
    end
   tt = alpha;
    rr = beta;
    zm = objfun(beta,alpha,pos);
    for i=1:N
        beta = rand(s)*2*pi;
        alpha = sigma*randn(s)*sqrt(dx);
        z=objfun(beta,alpha,pos);
        if (z<zm)
            zm=z;
            tt=alpha;
            rr=beta;
        end
    end
    alpha = tt;
    beta = rr;
end
