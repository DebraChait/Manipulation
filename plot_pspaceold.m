function output = plot_pspaceold

load('pspacedata_w5_range50504')

figure(1)
view(3)
hold on
if ~isempty(stablep0)
    plot3(stablep0(:,1),stablep0(:,2),...
             stablep0(:,3), '.b') 
end
if ~isempty(unstablep0)
plot3(unstablep0(:,1), unstablep0(:,2), ...
    unstablep0(:,3), '.r')
end
% title method 1
name = sprintf('p0 space, w = %i, range = %i,%i,%i',i,...
    xrange,yrange,zrange);
title(name);

legend('stable p0','unstable p0','Location', 'Best')
xlabel('p_1')
ylabel('p_2')
zlabel('p_3')

end
