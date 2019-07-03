function output = plot_pspace

% select random weights
% for each weight, select random p0s
% plot for each p0 whether it is stable or unstable

x0 = [0 0 0];
params = parameters;
tf = 1;
m = 0;



% set random weights
for i = 0:5
    
    w = i;
    
    stablep0 = [];
    unstablep0 = [];
    
    % set random p0s
    for j = 1:100
        
        p0 = [30 + (-30 - 30).*rand(1,2), 4 + (-4 - 4).*rand(1)];

        output_IVP = solve_IVP(x0,p0,tf,params,m,w);
        disp(output_IVP.tconj)
        
        % Plot every unstable? p from the IVP
        % Mark the border of our range
        %for k = 1:202
            
           % Check if there's a tconj
           if ~isempty(output_IVP.tconj) 
               unstablep0 = [unstablep0; output_IVP.p];
           else
               stablep0 = [stablep0; output_IVP.p];
           end
            
       % end
        
        
    end
    
    % plot it all at the end
figure(i+1)
view(3)
hold on
if ~isempty(unstablep0)
plot3(unstablep0(:,1), unstablep0(:,2), ...
    unstablep0(:,3), '*r')
end
if ~isempty(stablep0)
plot3(stablep0(:,1),stablep0(:,2),...
             stablep0(:,3), '.b')
end
% title method 1
name = sprintf('p0 space, w = %i',i)
title(name)

legend('unstable p0','stable p0','Location', 'Best')
xlabel('p_1')
ylabel('p_2')
zlabel('p_3')

end

end




r=randn(1000);
r=bsxfun(@rdivide,r,sqrt(sum(r.^2,1)));
x=r(1,:);
y=r(2,:);
z=r(3,:);
n=sqrt(x.^2+y.^2+z.^2);
x=x./n; 
y=y./n; 
z=.2*z./n;
figure
plot3(x,y,z,'.')
daspect([1 1 1])
