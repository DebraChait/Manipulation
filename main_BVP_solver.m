function output = main_BVP_solver
m=0;
% Set weight
w = 5;

% Final time
tf = 1;

% Initial condition for x(0)
x0 = [0 0 0];

% Desired boundary condition for x(tf)
xf = [0.5 0 0]

% Parameters vector
params = parameters;

% Guess for initial value of p(0)
%p0 = [0 0 -1];
p0 = [-53.7853953739189,2.50000396557782,9.78090610625897];

% Solve the boundary value problem
output = solve_BVP(x0,p0,xf,tf,params,m,w);

end
