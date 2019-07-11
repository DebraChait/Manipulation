function output = plotp0patherr

for s = 1:10
    
    % For method 1
    % filename = sprintf('plotp0patherr_%i',s)
    % For method 2
    filename = sprintf('plotp0patherr2_%i',s)
    load(filename,'straightp0s','bvpfailp0s','lsfailp0s','noerrp0s')
    
    figure(s)
    view(3)
    hold on
    if ~isempty(straightp0s)
        plot3(straightp0s(:,1),straightp0s(:,2),...
            straightp0s(:,3), '.g')
    end
    if ~isempty(bvpfailp0s)
        plot3(bvpfailp0s(:,1),bvpfailp0s(:,2),...
            bvpfailp0s(:,3), '.r')
    end
    if ~isempty(lsfailp0s)
        plot3(lsfailp0s(:,1),lsfailp0s(:,2),...
            lsfailp0s(:,3), '.y')
    end
    if ~isempty(noerrp0s)
        plot3(noerrp0s(:,1),noerrp0s(:,2),...
            noerrp0s(:,3), '.b')
    end
    
    % For method 1
    % name = sprintf('p0 paths by error, %i',s);
    % For method 2
    name = sprintf('p0 paths by error method 2, %i',s);
    title(name);
    legend('straight', 'bvpfail', 'lsfail', 'no error','Location', 'Best')
    xlabel('p_1')
    ylabel('p_2')
    zlabel('p_3')
    
end

end
