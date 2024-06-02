function objfun = tropismObjective(type, ap)
% getTropismObjective: returns objective function for common tropisms

switch type  
    case 0
        objfun = @(beta, alpha, y) testH(beta, alpha, y);                
    case 1
        objfun = @(beta, alpha, y) testZ(beta, alpha, y);
    case 2
        objfun = @(beta, alpha, y) testExo(beta, alpha, y, ap);
    case 3        
        objfun = @(beta, alpha, y) testChemo(beta, alpha, y, ap);
    case 4        
        objfun = @(beta, alpha, y) testCom(beta, alpha, y, ap);
end


function z=testH(r,t,y) 
R = y.R *  [ 1 0 0; 0 cos(r) -sin(r); 0 sin(r) cos(r) ]; 
R = R *    [ cos(t) sin(t) 0; -sin(t) cos(t) 0; 0 0 1]; 
z = abs(R(3,1)); 


function z=testZ(r,t,y)
R = y.R * [ 1 0 0; 0 cos(r) -sin(r); 0 sin(r)  cos(r) ]; 
R = R * [ cos(t) sin(t) 0; -sin(t) cos(t) 0; 0 0 1]; 
z = R(3,1); 


function z=testExo(r,t,y,iR) 
R = y.R * [ 1 0 0; 0 cos(r) -sin(r) ;0 sin(r) cos(r) ]; 
R = R * [ cos(t) sin(t) 0; -sin(t) cos(t) 0; 0 0 1];
s = (R(:,1)'*iR') / norm(R(:,1)) / norm(iR);
z = acos(s);


function z=testChemo(r,t,y,dx) 

global C;
global X;
global Y;
global Z;


R = y.R * [ 1 0 0; 0 cos(r) -sin(r) ;0 sin(r) cos(r) ]; % roll
R = R * [ cos(t) sin(t) 0; -sin(t) cos(t) 0; 0 0 1]; % turn
x_ = y.x+dx*R(:,1);
z = -interp3(X,Y,Z,C,x_(1),x_(2),x_(3))*1e6 + R(3,1);


function z=testCom(r,t,y,dx) 

global C;
global X;
global Y;
global Z;

if C==0
    z=testZ(r,t,y);
else
    z=0.8*testChemo(r,t,y,dx)+0.2*testZ(r,t,y);
end

