function output = main_continuation_solver

% Final time
tf = 1;

% Initial condition for x(0)
x0 = [0 0 0];

% Parameters
params = parameters;

% Guess for initial condition p(0)
p0 = [0 0 1];

% Solve IVP to find stable shape
output_IVP = solve_IVP(x0,p0,tf,params);
% disp('solved IVP');

% Set up for continuation problem
XF = output_IVP.x;
% disp('Here is the first IVP sol = ')
% disp(XF)

% Solve the continuation problem for straightening the rod
for m = 1:500

        % fprintf('Entering forloop round %i \n', m)
        
        % Initialize list of rod points
        xf = XF;
        
        % Cut and rescale rod by next-to-last entry
        XF(end,:) = [xf(200,1)/.995, xf(200,2)/.995, xf(200,3)];
        % disp('rescaled')
        % disp(XF)
        
        % Update list of rod points
        newxf = XF(end,:);
        
        % Solve BVP with final position in line with updated rod
        output_BVP = solve_BVP(x0,p0,newxf,tf,params);
        
        % Re-update
        p0 = output_BVP.p0;
        XF = output_BVP.x;
        % disp('after BVP')
        % disp(XF)
        
end 

end
