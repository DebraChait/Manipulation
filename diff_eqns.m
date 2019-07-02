function dY = diff_eqns(t,Y,params) 
% Inputs t=time, Y=vector containing solution at time t
% Outputs diff eqns to be solved
% Sets up necessary and sufficient cond's for local minima

% Set bending constant c and weight w
c = 1;
w = 5;

% Get vectors x and p
x = Y(1:3);
p = Y(4:6);

% Get matrices M and J
M = reshape(Y(7:15),3,3)'; % transpose is '
J = reshape(Y(16:24),3,3)';

% Define control input u in terms of x and p
% u chosen to minimize H in necessary conditions step
u = p(3)/c;

% Compute the derivatives of x and p
dx = [cos(x(3)) sin(x(3)) u]; 
dp =[0 w p(1)*sin(x(3))-p(2)*cos(x(3))]; %dp = -Hx

% Compute coefficient matrices for sufficient conditions
Hxx = [0 0 0;
     0 0 0;
     0 0 -p(1)*cos(x(3))-p(2)*sin(x(3))];
Hpp = [0 0 0;
     0 0 0;
     0 0 1/c];
 
Hxp = [0 0 -sin(x(3));
     0 0 cos(x(3));
     0 0 0];

Hpx = Hxp';

% Compute derivatives of M and J
dM = -Hpx*M-Hxx*J;
dJ = Hpp*M+Hxp*J;

% Collect derivatives
dY = [dx dp reshape(dM',1,9) reshape(dJ',1,9)]';

end
