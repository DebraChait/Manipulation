function output = plotp0s
% Load the data from files and make major plots


for i = 1:3
    % Load the data
    filename = sprintf('plotp0_%i',i)
    load(filename)
    % Plot start p0s, colored by error
    if ~isempty(straightstart)
        hold on
        figure(1)
        straightstartplot = plot3(straightstart(:,1),...
            straightstart(:,2),straightstart(:,3), 'bo')
        title('Starting p0''s')
        legend('straightstart','bvpfailstart','lsfailstart', 'noerrstart',...
            'Location', 'Best')
        hold off
    end
    if ~isempty(bvpfailstart)
        hold on
        figure(1)
        bvpstartplot = plot3(bvpfailstart(:,1),bvpfailstart(:,2),...
            bvpfailstart(:,3), 'go')
        title('Starting p0''s')
        legend('straightstart','bvpfailstart','lsfailstart', 'noerrstart',...
            'Location', 'Best')
        hold off
    end
    if ~isempty(lsfailstart)
        hold on
        figure(1)
        lsfstartplot = plot3(lsfailstart(:,1),lsfailstart(:,2),...
            lsfailstart(:,3), 'ro')
        title('Starting p0''s')
        legend('straightstart','bvpfailstart','lsfailstart', 'noerrstart',...
            'Location', 'Best')
        hold off
    end
    if ~isempty(noerrstart)
        hold on
        figure(1)
        noerrstartplot = plot3(noerrstart(:,1),noerrstart(:,2),...
            noerrstart(:,3), 'mo')
        title('Starting p0''s')
        legend('straightstart','bvpfailstart','lsfailstart', 'noerrstart',...
            'Location', 'Best')
        hold off
    end
    
    % Plot end p0s, colored by error
    if ~isempty(straightend)
        hold on
        figure(2)
        straightendplot = plot3(straightend(:,1),straightend(:,2),...
            straightend(:,3), 'bo')
        title('Ending p0''s')
        legend('straightstart','bvpfailstart','lsfailstart', 'noerrstart')
        hold off
    end
    if ~isempty(bvpfailend)
        hold on
        figure(2)
        bvpendplot = plot3(bvpfailend(:,1),bvpfailend(:,2),...
            bvpfailend(:,3), 'go')
        title('Ending p0''s')
        legend('straightstart','bvpfailstart','lsfailstart', 'noerrstart')
        hold off
    end
    if ~isempty(lsfailend)
        hold on
        figure(2)
        lsfendplot = plot3(lsfailend(:,1),lsfailend(:,2),...
            lsfailend(:,3), 'ro')
        title('Ending p0''s')
        legend('straightstart','bvpfailstart','lsfailstart', 'noerrstart')
        hold off
    end
    if ~isempty(noerrend)
        hold on
        figure(2)
        noerrendplot = plot3(noerrend(:,1),noerrend(:,2),...
            noerrend(:,3), 'mo')
        title('Ending p0''s')
        legend('straightstart','bvpfailstart','lsfailstart', 'noerrstart')
        hold off
    end
end


end
