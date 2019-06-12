function plot_function(output,xf)

% Plot solution
plot(output.x(:,1),output.x(:,2),'b-') % b- means blue line

hold on

% Plot initial condition for x at t=0
plot(output.x(1,1),output.x(1,2),'go') % green circle

% Plot desired boundary condition for x at t=tf
plot(xf(1),xf(2),'ro')

hold off

% Set axis limits
axis([-.5 1 -1 1])
% Axis labels
xlabel('x_1')
ylabel('x_2')
% Aspect ratio
daspect([1 1 1])
% Set font size
set(gca,'FontSize',20,'color','w')

% Draw plot now
drawnow

end
