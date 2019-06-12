function output = main_BVP_solver

% Final time
tf = 1;

% Initial condition for x(0)
x0 = [0 0 0];

% Desired boundary condition for x(tf)
xf = [0.5 0 0]

% Parameters vector
params = parameters;

% Guess for initial value of p(0)
p0 = [0 0 1];

% Solve the boundary value problem
output = solve_BVP(x0,p0,xf,tf,params);

end
