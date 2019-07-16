function output = plot_pspace

% increment weights
% for each weight, select random p0s
% plot for each p0 whether it is stable or unstable

x0 = [0 0 0];
params = parameters;
tf = 1;
m = 0;

% set random weights
for i = [0:5:10, 20:20:120]
    
    w = i;
    
    stablep0 = [];
    unstablep0 = [];
    
    % set random p0s on the shell of an ellipse 
    r=randn(10000);
    r=bsxfun(@rdivide,r,sqrt(sum(r.^2,1)));
    x=r(1,:);
    y=r(2,:);
    z=r(3,:);
    n=sqrt(x.^2+y.^2+z.^2);
    xrange = 50;
    yrange = 50;
    zrange = 4;
    x=xrange*x./n; 
    y=yrange*y./n; 
    z=zrange*z./n;
    
    for j = 1:10000 
    
        p0 = [x(j), y(j), z(j)];
        
        for k = 0:.01:1
        
            p0now = [(k^2)*p0(1), (k^2)*p0(2) -w/2*(1 - k^2), k*p0(3)];
            output_IVP = solve_IVP(x0,p0now,tf,params,m,w);

            % Check if there's a tconj
            if ~isempty(output_IVP.tconj) 
               unstablep0 = [unstablep0; output_IVP.p];
            else
               stablep0 = [stablep0; output_IVP.p];
            end  
            
        % end of k forloop
        end
           
    % end of j forloop
    end
    
% save data for plotting
filename = sprintf('pspacedata_w%i_ext_range%i%i%i',w,xrange,...
    yrange,zrange);
save(filename,'unstablep0','stablep0');

% end of i forloop
end

% end of function
end
