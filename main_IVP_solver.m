function output = main_IVP_solver
m=0;
% Set weight
w = 0;

% Initial conditions for x and p
x0 = [0 0 0];
p0 = [0 0 -1];

% Final time
tf = 1;

% Define parameters
params = parameters;

% Solve IVP
output = solve_IVP(x0,p0,tf,params,m,w);

% Make plot of x1 vs x2
comet(output.x(:,1),output.x(:,2))
daspect([1 1 1])
xlabel('x_1')
ylabel('x_2')

end
