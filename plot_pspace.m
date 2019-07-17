function output = plot_pspace

% Take in stability and straightness arrays, plot staight/not straight and
% stable/unstable in different colors.
% Make sandwiches red

% find entries with 1 in stability/straightness arrays -> the index of the
% p0 where interesting things happened
% Save as stable/unstable, straight/not straight as individual arrays to
% plot
%help

for i = 5
    
%     unstable = [];
%     stable = [];
%     straight = [];
%     notstraight = [];
%     sandwichp0s =[];
%     endunstablep0s =[];
%     
%     
%     filename = sprintf('pspacedata_ext_w%i_key',i)
%     load(filename)
%     filename = sprintf('pspacedata_ext_w%i_raw',i)
%     load(filename)
%     
%     for col = 1:3000
%         for row = 1:101
%             if stability(row,col) == 0
%                 stable = [stable; p0paths{row,col}];
%             else
%                 unstable = [unstable; p0paths{row,col}];
%             end
%             
%             if straightness(row,col) == 0
%                 notstraight = [notstraight; p0paths{row,col}];
%             else
%                 straight = [straight; p0paths{row,col}];
%             end
%         end
%         
%         if sandwich(1,col) == 1
%             sandwichp0s = [sandwichp0s; p0paths{:,col}];
%         end
%         if endunstable(1,col) == 1
%             endunstablep0s = [endunstablep0s; p0paths{:,col}];
%         end
%     end

sort = sprintf('pspacedata_ext_w%i_sorted',i);
load(sort)
    
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
%     if ~isempty(notstraight)
%         plot3(notstraight(:,1), notstraight(:,2), ...
%             notstraight(:,3), '.b')
%     end
    if ~isempty(straight)
        plot3(straight(:,1),straight(:,2),...
            straight(:,3), '.g')
    end

    name = sprintf('pspace straightness w = %i',i);
    title(name);
    
    legend('straight','Location', 'Best')
    xlabel('p_1')
    ylabel('p_2')
    zlabel('p_3')
hold off

figure(3)
view(3)
 hold on
    if ~isempty(sandwichp0s)
        plot3(sandwichp0s(:,1), sandwichp0s(:,2), ...
            sandwichp0s(:,3), '.b')
    end

    name = sprintf('pspace sandwich p0s w = %i',i);
    title(name);
    
    legend('p0','Location', 'Best')
    xlabel('p_1')
    ylabel('p_2')
    zlabel('p_3')
hold off

figure(4)
view(3)
 hold on
    if ~isempty(endunstablep0s)
        plot3(endunstablep0s(:,1), endunstablep0s(:,2), ...
            endunstablep0s(:,3), '.b')
    end

    name = sprintf('pspace ends unstable w = %i',i);
    title(name);
    
    legend('p0s','Location', 'Best')
    xlabel('p_1')
    ylabel('p_2')
    zlabel('p_3')
hold off
    
    
end