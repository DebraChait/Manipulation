function output_BVP = solve_BVP(x0,p0,xf,tf,params,m,w)
% Inputs x0 = initial cond for x, p0 = guess for p(0), xf = desired value
%   of x at time tf
% Solves BVP by using IVP and reducing error between guess output and
%   desired value for tf through Newton's method
% output_BVP has fields t, x, p, M, J. tconj similar to output_IVP, and 
%   fields eta, err, p0
% output_BVP.eta: error vector between desired value of x(1) and the
%   computed value of x(1)
% output_BVP.err : norm of output.eta
% output_BVP.p0 : initial condition p(0) found by BVP solver

% Initialize counter and output
i = 0;
output_BVP = [];
output_IVP = [];

% We need the try/catch so that if we encounter a line search fail,
% solve_BVP still outputs output_BVP.catch
try

    % Boundary value problem loop
    while i < params.nmax

        % Iterate i
        i = i+1;
        % Solve IVP
        output_IVP = solve_IVP(x0,p0,tf,params,m,w);
        % Compute error between current and desired value of x(tf)
        output_IVP.eta = ...
            [output_IVP.x(end,1)-xf(1); % For component x1
             output_IVP.x(end,2)-xf(2); % For component x2
             wrapToPi(output_IVP.x(end,3)-xf(3))]; % Adjusts the angle x3 to 
                                                   % be between -pi and pi     
        output_IVP.err = norm(output_IVP.eta);

        % Print variables of interest
        % fprintf('iteration: %.0f    error: %.10f \n',i,output_IVP.err)

        % Plot solution, pause to see starting shape
        plot_function(output_IVP,xf)
        if m==1
            pause(1)
        end

        % If error is minute, we've found a solution
        if output_IVP.err <= params.tol
            output_BVP = output_IVP;
            output_BVP.p0 = p0;
            break
        end

        % Compute search direction for p0
        jacobian = output_IVP.J(:,:,end); % all columns and rows thru end
            % J gives change in x needed to reach sol, functions as slope
            % of tan line for our guess
        dp0 = -jacobian\output_IVP.eta; 
        % A\B gives sol x for Ax=B, so A\B = {A inverse}*B
        % We are trying to reduce the error in x1(tf), x2(tf), x3(tf) to 0, 
        % so we use output_IVP.eta as the function that we approximate

        % Enforce maximum step size
        if norm(dp0) > params.maxstep
            dp0 = dp0/norm(dp0)*params.maxstep;
        end

        % Update p0 basic for a better guess
        % p0 = p0 + dp0';

        % Use line search to find step size that ensures error decreases
        step = line_search(x0,p0,xf,dp0,tf,output_IVP.err,params,m,w);

        % Update p0 with line search for a better guess
        if ~isempty(step)
            p0 = p0+step*dp0';
        else
            % If line search failed, store the specific error
            output_BVP.catch = 'line search failed';
            error('line search failed')
        end

    end

    if output_IVP.err > params.tol
        output_BVP.catch = 'BVP solver failed';
        error('BVP solver failed')
    else
        output_BVP.catch = 'no error';
    end

% If caught an error, end the program and return output_BVP values created
catch
end
 
% End solve_BVP function 
end

function step = line_search(x0,p0,xf,dp0,tf,err,params,m,w)

% This function uses a line search to ensure that the error decreases when
% updating p0
% Function Inputs:
%   x0 : initial condition for x(0)
%   p0 : guess for initial condition p(0) 
%   xf : desired boundary condition for x(tf)
%   dp0 : search direction for p0
%   tf : end of time interval
%   err : err at current value of p(0)
%   params : structure containing parameters
% Function Outputs:
%   step :  step size that ensures error decreases in the direction dp0

% Initialize step size and new error
step = 1/params.step_ratio;
newerr = 2*err;
    
% Line search loop
while newerr > (1-params.decrease_param)*err
    
    % Compute step size and p0 after step
    step = params.step_ratio*step;
    newp0 = p0+step*dp0';
    
    % Compute error after step
    output_IVP = solve_IVP(x0,newp0,tf,params,m,w);
    
    % Store error between current and desired value of x(tf)
    neweta = [output_IVP.x(end,1)-xf(1)... 
              output_IVP.x(end,2)-xf(2)...
              wrapToPi(output_IVP.x(end,3))-xf(3)];
    newerr = norm(neweta);
    
    % Check if step is less than minstep
    if norm(step) < params.minstep
        step = [];
        break
    end 
end
   
% End line_search function   
end
