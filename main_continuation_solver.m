function output = main_continuation_solver

% Computation time start
tic

% Test n random p0 values
for n = 1:50

% Final time
tf = 1;

% Initial condition for x(0)
x0 = [0 0 0];

% Parameters
params = parameters;

% Randomly select a p0 between -10 and 10 to test
p0 = 10 + (-10 - 10).*rand(1,3);

% Solve IVP to find stable shape
output_IVP = solve_IVP(x0,p0,tf,params,0);
% disp('solved IVP');

% Set up for straightening the rod
XF = output_IVP.x;
% disp('Here is the first IVP sol = ')
% disp(XF)

% Straightening the rod
for m = 1:200
        
        % Store p0
        output_tester(n,m).startp0 = p0;

        % fprintf('Entering forloop round %i \n', m)
        
        % Initialize list of rod points
        xf = XF;
        
        % Cut and rescale rod by next-to-last entry
        % Adjust discretization by iteration number for efficiency
        XF(end,:) = [xf(end-1,1)/(1-1/(201-m)), ...
            xf(end-1,2)/(1-1/(201-m)), xf(end-1,3)];
        % disp('rescaled')
        % disp(XF)
        
        % Update list of rod points
        newxf = XF(end,:);
        
        % Determine if there was an error in solve_BVP for this p0
        try
                % Solve BVP with final position in line with updated rod
                output_BVP = solve_BVP(x0,p0,newxf,tf,params,m);
                % output_BVP.p0 will not exist if there was an error in solve_BVP
                testing = output_BVP.p0;
        catch
                % disp('bad p0')
                % If there was an error in solve_BVP, store the specific error
                output_tester(n,m).error = output_BVP.catch;
                break
        end
        % If there was no error, store that information
        output_tester(n,m).error = 'no error';
        
        % Re-update
        p0 = output_BVP.p0;
        XF = output_BVP.x;
        % disp('after BVP')
        % disp(XF)
        
        % Test for sufficient straightness
        endx1 = XF(end,1);
        endx2 = XF(end,2);
        % fprintf('endx1 = %.3d, endx2 = %.3d \n', endx1,endx2)
        slopenow = endx2/endx1;
        % fprintf('slope is %.3d at iteration %i \n',slopenow,m)
        if abs(slopenow)<.03
            break
        end
        
        % Store final p0 and conjugate points (if any)
        output_tester(n,m).endp0 = p0;
        output_tester(n,m).tconj = output_BVP.tconj;

% m forloop
end 

% n forloop
end

% Computation time end
toc

% function
end
