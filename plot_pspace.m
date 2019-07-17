function output = plot_pspace

% Take in stability and straightness arrays, plot staight/not straight and
% stable/unstable in different colors.
% Make sandwiches red

% find entries with 1 in stability/straightness arrays -> the index of the
% p0 where interesting things happened
% Save as stable/unstable, straight/not straight as individual arrays to
% plot


for i = [5]
    
    filename = sprintf('pspacedata_ext_w%i_sorted',i)
    load(filename)
    
% Stability plot 
figure(1)
view(3)
 hold on
    if ~isempty(stable)
        plot3(stable(:,1), stable(:,2), ...
            stable(:,3), '.b')
    end
    if ~isempty(unstable)
        plot3(unstable(:,1),unstable(:,2),...
            unstable(:,3), '.r')
    end

    name = sprintf('pspace stability w = %i',i);
    title(name);
    
    legend('stable', 'unstable','Location', 'Best')
    xlabel('p_1')
    ylabel('p_2')
    zlabel('p_3')
hold off

figure(2)
view(3)
 hold on
    if ~isempty(notstraight)
        plot3(notstraight(:,1), notstraight(:,2), ...
            notstraight(:,3), '.b')
    end
    if ~isempty(straight)
        plot3(straight(:,1),straight(:,2),...
            straight(:,3), '.g')
    end

    name = sprintf('pspace straightness w = %i',i);
    title(name);
    
    legend('notstraight', 'straight','Location', 'Best')
    xlabel('p_1')
    ylabel('p_2')
    zlabel('p_3')
hold off
    
    
end