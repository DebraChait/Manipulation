function output = solve_continuation(x0,p0,XF,tf,params)

% Solves continuation of BVP, list of boundary conditions for xf 
% rather than a single specified xf 
for i=1:length(XF(:,1))
   
    % Set desired boundary conditions
    xf = XF(i,:); % i-th row of XF
    
    % Solve the boundary value problem
    output_BVP = solve_BVP(x0,p0,xf,tf,params);
    
    % Store solution of boundary value problem
    output(i) = output_BVP;
    
    % Update initial guess for p0
    p0 = output_BVP.p0;
    
end

end
