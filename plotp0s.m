function output = plotp0s
% Load the data from files and make major plots


for i = 1:10
    filename = sprintf('plotp0_%i',i)
    load(filename)
    
    if ~isempty(straightstart)
        figure(2)
        straightstartplot = plot3(straightstart(:,1),...
            straightstart(:,2),straightstart(:,3), 'bo')
        title('Straight start p0s')
    end
    if ~isempty(bvpfailstart)
        figure(3)
        bvpstartplot = plot3(bvpfailstart(:,1),bvpfailstart(:,2),...
            bvpfailstart(:,3), 'go')
        title('BVP solver fail start p0s')
    end
    if ~isempty(lsfailstart)
        figure(4)
        lsfstartplot = plot3(lsfailstart(:,1),lsfailstart(:,2),...
            lsfailstart(:,3), 'ro')
        title('Line search fail start p0s')
    end
    if ~isempty(noerrstart)
        figure(5)
        noerrstartplot = plot3(noerrstart(:,1),noerrstart(:,2),...
            noerrstart(:,3), 'mo')
        title('No error, not straight start p0s')
    end
    if ~isempty(straightend)
        figure(2)
        straightendplot = plot3(straightend(:,1),straightend(:,2),...
            straightend(:,3), 'bo')
        title('Straight end p0s')
    end
    if ~isempty(bvpfailend)
        figure(3)
        bvpendplot = plot3(bvpfailend(:,1),bvpfailend(:,2),...
            bvpfailend(:,3), 'go')
        title('BVP solver fail end p0s')
    end
    if ~isempty(lsfailend)
        figure(4)
        lsfendplot = plot3(lsfailend(:,1),lsfailend(:,2),...
            lsfailend(:,3), 'ro')
        title('Line search fail end p0s')
    end
    if ~isempty(noerrend)
        figure(5)
        noerrendplot = plot3(noerrend(:,1),noerrend(:,2),...
            noerrend(:,3), 'mo')
        title('No error, not straight end p0s')
    end
end


end
