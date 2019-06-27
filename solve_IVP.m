function output_IVP = solve_IVP(x0,p0,tf,params,m)
% Inputs x0 = initial cond for x(0), p0 = guess for intial cond for a p(0)
% that minimizes cost function, tf = final time
% output_IVP contains fields t, x, p, M, J, and tconj
% output_IVP.t : nx1 vector of time values t along solution
% output_IVP.x : nx3 vector containing the solution for x(t) 
%    (e.g., output.x(:,2) is the solution for x2(t))
% output_IVP.p : nx3 vector containing the solution for p(t)
% output_IVP.M : 3x3xn matrix containting Jacobian of p(t) wrt p(0)
%    (e.g., output.M(:,:,10) is the jacobian of output.p(10,:)
%    with respect to a change in output.p(1,:)) -- ie change in p(t) for
%    min energy sol
% output_IVP.J : Jacobian of x(t) with respect to p(0) -- ie change in x(t)
% output.tconj : vector containing times of conjugate points

% Initial conditions for matrices J and M as per suff cond's
M0 = eye(3); % Identity matrix
J0 = zeros(3,3); % 3x3 matrix of zeros

% Initial condition vector
Y0 = [x0 p0 reshape(M0',1,9) reshape(J0',1,9)];

% Solve ODEs
[t,sol,tconj,~,ie] = ode45(@(t,Y) diff_eqns(t,Y,params), [linspace(0,1,201-m)],... 
                        Y0,params.ode_options);    
                        % @ tells Matlab which parameters to use and which
                        % to ignore. Matlab really only wants t,Y
% ode45 input(system of diff eqs to solve, [start end], initial cond, 
% extra input for error tolerance and to get conjugate points)
% linspace discretizes rod length 1 into 201-m points from 0 to 1
% ode45 outputs t = evaluation points, sol = solutions corresponding to
% evaluation points specified by t, tconj = times of conjugate points
                        
% Store vectors t, x, and p    
output_IVP.t = t; % . tells Matlab to store t inside the structure
output_IVP.x = sol(:,1:3); % we want all entries in columns 1 thru 3
output_IVP.p = sol(:,4:6); % : tells Matlab to index the entries

% Store matrices M and J
output_IVP.M = permute(reshape(sol(:,7:15)',3,3,length(t)),[2 1 3]);
output_IVP.J = permute(reshape(sol(:,16:24)',3,3,length(t)),[2 1 3]);
% Matlab messes up the order when we make this into a 3x3xlengh(t) matrix,
% so permute restores the matrix to its original order

% Store times of conjugate points
tconjpts = is_stable(tconj,ie);
output_IVP.tconj = tconjpts;

end


function tconj = is_stable(tconj,ie)
% Ensure that conj points found are true conj points by requiring det(J)
% to pass a certain threshold before finding det(J)=0
% This prevents Matlab from mistaking small det(J) as det(J) = 0

ithreshold = find(ie==2,1,'first');
if (~isempty(ithreshold))
    iconj = find(ie==1);
    iconj = iconj(iconj>ithreshold);
    if (~isempty(iconj))
        tconj = tconj(iconj);
    else
        tconj = [];
    end
else
    tconj = [];
end
    
    
end
