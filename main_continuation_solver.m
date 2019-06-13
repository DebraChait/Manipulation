function output = main_continuation_solver

% Final time
tf = 1;

% Initial condition for x(0)
x0 = [0 0 0];

% List of desired boundary conditions for x(tf)
n = 20;
XF = [0.6*ones(n,1) linspace(0,.7,n)' zeros(n,1)];
    %vector of ones

% Parameters
params = parameters;

% Guess for initial condition p(0)
p0 = [0 0 1];

% Solve the continuation problem
output = solve_continuation(x0,p0,XF,tf,params);

end
