function output = plot_pspace

% Take in stability and straightness arrays, plot staight/not straight and
% stable/unstable in different colors.
% Make sandwiches red

% find entries with 1 in stability/straightness arrays -> the index of the
% p0 where interesting things happened
% Save as stable/unstable, straight/not straight as individual arrays to
% plot
%help

for i = 0
    
    sort = sprintf('pspacedata_ext_w%i_sorted',i);
    load(sort)
    
    % Only plot non-zeros entries
    stableplot = zeros(countsb,3);
    unstableplot = zeros(countu,3);
    nstraightplot = zeros(countnsr,3);
    straightplot = zeros(countsr,3);
    sandwich_uplot = zeros(countsw_u,3);
    sandwich_splot = zeros(countsw_s,3);
    endunstable_uplot = zeros(counte_u,3);
    endunstable_splot = zeros(counte_s,3);
    
    for row = 1:countsb
        stableplot(row,:) = stable(row,:);
    end
    
    for row = 1:countu
        unstableplot(row,:) = unstable(row,:);
    end
    
    for row = 1:countsr
        straightplot(row,:) = straight(row,:);
    end
    
    for row = 1:countnsr
        nstraightplot(row,:) = notstraight(row,:);
    end
    
    for row = 1:countsw_u
        sandwich_uplot(row,:) = sandwichp0s_u(row,:);
    end
    
    for row = 1:countsw_s
        sandwich_splot(row,:) = sandwichp0s_s(row,:);
    end
    
    for row = 1:counte_u
        endunstable_uplot(row,:) = endunstablep0s_u(row,:);
    end
    
    for row = 1:counte_s
        endunstable_splot(row,:) = endunstablep0s_s(row,:);
    end
    
    
    % Stability plot
    figure(1)
    view(3)
    hold on
    if ~isempty(stable)
        plot3(stableplot(:,1), stableplot(:,2), ...
            stableplot(:,3), '.b')
    end
    if ~isempty(unstable)
        plot3(unstableplot(:,1),unstableplot(:,2),...
            unstableplot(:,3), '.r')
    end
    
    name = sprintf('pspace stability w = %i',i);
    title(name);
    
    legend('stable', 'unstable','Location', 'Best')
    xlabel('p_1')
    ylabel('p_2')
    zlabel('p_3')
    
    figname = sprintf('pspace_stability_ext_w%i.fig',i)
    savefig(figname)
    hold off
    
%     figure(2)
%     view(3)
%     hold on
%     if ~isempty(unstable)
%         plot3(unstableplot(:,1),unstableplot(:,2),...
%             unstableplot(:,3), '.r')
%     end
%     
%     name = sprintf('pspace stability w = %i',i);
%     title(name);
%     
%     legend('stable', 'unstable','Location', 'Best')
%     xlabel('p_1')
%     ylabel('p_2')
%     zlabel('p_3')
%     
%     figname = sprintf('PspaceUnstable_ext_w%i.fig')
%     savefig(figname)
%     hold off
%     
%     figure(3)
%     view(3)
%     hold on
%     %     if ~isempty(notstraight)
%     %         plot3(notstraightplot(:,1), notstraightplot(:,2), ...
%     %             notstraightplot(:,3), '.b')
%     %     end
%     if ~isempty(straight)
%         plot3(straightplot(:,1),straightplot(:,2),...
%             straightplot(:,3), '.g')
%     end
%     
%     name = sprintf('pspace straightness w = %i',i);
%     title(name);
%     
%     legend('straight','Location', 'Best')
%     xlabel('p_1')
%     ylabel('p_2')
%     zlabel('p_3')
%     hold off
%     
%     figure(4)
%     view(3)
%     hold on
%     if ~isempty(endunstablep0s_u)
%         plot3(endunstable_uplot(:,1), endunstable_uplot(:,2), ...
%             endunstable_uplot(:,3), '.r')
%     end
%     if ~isempty(endunstablep0s_s)
%         plot3(endunstable_splot(:,1), endunstable_splot(:,2), ...
%             endunstable_splot(:,3), '.b')
%     end
%     
%     name = sprintf('pspace ends unstable w = %i',i);
%     title(name);
%     
%     legend('unstable p0','stable p0','Location', 'Best')
%     xlabel('p_1')
%     ylabel('p_2')
%     zlabel('p_3')
%     hold off
%     
%     figure(5)
%     view(3)
%     hold on
%     if ~isempty(sandwichp0s_u)
%         plot3(sandwich_uplot(:,1), sandwich_uplot(:,2), ...
%             sandwich_uplot(:,3), '.r')
%     end
%     if ~isempty(sandwichp0s_s)
%         plot3(sandwich_splot(:,1), sandwich_splot(:,2), ...
%             sandwich_splot(:,3), '.b')
%     end
%     
%     name = sprintf('pspace sandwich p0s w = %i',i);
%     title(name);
%     
%     legend('unstable p0','stable p0','Location', 'Best')
%     xlabel('p_1')
%     ylabel('p_2')
%     zlabel('p_3')
%     hold off
    
end

end