function diff_eqns_ext(t,Y,params,w) 
    % Inputs t=time, Y=vector containing solution at time t
    % Outputs diff eqns to be solved
    % Sets up necessary and suff cond's for local minima
    
    % Set extensibility constant ce, bending constant cb, weight w
    ce = 1000;
    cb = 1;
    % w = 5;
    
    % Get vectors x and p
    x = Y(1:3);
    p = Y(4:6);
    
    % Get matrices M and J
    M = reshape(Y(7:15),3,3)'; % transpose is '
    J = reshape(Y(16:24),3,3)';
    
    % u1 controls extensibility, u2 controls curvature
    u1 = p(1)*cos(x(3))/ce + p(2)*sin(x(3))/ce;
    u2 = p(3) / cb;
    
    % Compute the derivatives of x and p
    dx = [(1+u1)*cos(x(3)), (1+u1)*sin(x(3)), u2]; 
    dp =[0, w, p(1)*(1+u1)*sin(x(3))-p(2)*(1+u1)*cos(x(3))]; 
    %dp = -Hx
    
    % Compute coefficient matrices for sufficient conditions
    Hxx = [0, 0, 0;
         0, 0, 0;
         0, 0, (1/ce)*(-p(1)*sin(x(3))+p(2)*cos(x(3)))^2 ...
                - (1+(1/ce)*(p(1)*cos(x(3))+p(2)*sin(x(3)))) * ...
                (p(1)*cos(x(3))+p(2)*sin(x(3)))];
     
    Hpp = [(1/ce)*(cos(x(3)))^2, (1/ce)*sin(x(3))*cos(x(3)), 0;
         (1/ce)*sin(x(3))*cos(x(3)), (1/ce)*(sin(x(3)))^2, 0;
         0, 0, 1/cb];
    
    Hxp = [0, 0, -sin(x(3))-(2/ce)*p(1)*sin(x(3))*cos(x(3))+...
                (1/ce)*p(2)*((cos(x(3)))^2-(sin(x(3)))^2);
         0, 0, cos(x(3))+(2/ce)*p(2)*sin(x(3))*cos(x(3))+...
                (1/ce)*p(1)*((cos(x(3)))^2-(sin(x(3)))^2);
         0, 0, 0];
    
    Hpx = Hxp';
    
    % Compute derivatives of M and J
    dM = -Hpx*M-Hxx*J;
    dJ = Hpp*M+Hxp*J;
    
    % Collect derivatives
    dY = [dx dp reshape(dM',1,9) reshape(dJ',1,9)]';
    
    end
    
