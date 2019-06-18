function params = parameters

% This function contains parameters for BVP
params.ode_options = odeset('AbsTol',1e-6,'RelTol',1e-6,...
                            'Events',@conj_pt_test);
                            % Error tolerance
                            
params.nmax = 200; % max number of iterations to run BVP loop
params.tol = 1e-6; % error tolerance for solution of BVP
params.maxstep = 1; % max step size to make in p0 when solving BVP
params.step_ratio = 0.5; % step size decrease to use in line search
params.decrease_param = 0; % minimum error decrease in line search
params.minstep = 1e-6; % minimum step size in line search

end
