function output = plotp0s
% Load the data from files and make major plots
    
% Initialize data arrays    
straightstartdata = [];
bvpfailstartdata = [];
lsfailstartdata = [];
noerrstartdata = [];
straightenddata = [];
bvpfailenddata = [];
lsfailenddata = [];
noerrenddata = [];

for i = 1:3
    
    % Load the data
    filename = sprintf('plotp0_%i',i)
    load(filename) 
    
    straightstartdata = [straightstartdata; straightstart];
    bvpfailstartdata = [bvpfailstartdata; bvpfailstart];
    lsfailstartdata = [lsfailstartdata; lsfailstart];
    noerrstartdata = [noerrstartdata; noerrstart];
    straightenddata = [straightenddata; straightend];
    bvpfailenddata = [bvpfailenddata; bvpfailend];
    lsfailenddata = [lsfailenddata; lsfailend];
    noerrenddata = [noerrenddata; noerrend];

end

% Plot the start p0s, colored by error
view(3)
figure(1)
hold on
if ~isempty(bvpfailstartdata)
plot3(bvpfailstartdata(:,1), bvpfailstartdata(:,2), ...
    bvpfailstartdata(:,3), 'or')
end
if ~isempty(noerrstartdata)
plot3(noerrstartdata(:,1),noerrstartdata(:,2),...
             noerrstartdata(:,3), 'ob')
end
if ~isempty(straightstartdata)
plot3(straightstartdata(:,1),...
             straightstartdata(:,2),straightstartdata(:,3), 'og')
end
if ~isempty(lsfailstartdata)
plot3(lsfailstartdata(:,1),lsfailstartdata(:,2),...
             lsfailstartdata(:,3), 'oy')
end
title('start p0s')
legend('bvpfailstart','noerrstart','straightstart',...
    'lsfailstart', 'Location', 'Best')

% Plot the end p0s, colored by error
view(3)
figure(2)
hold on
if ~isempty(bvpfailenddata)
plot3(bvpfailenddata(:,1), bvpfailenddata(:,2), ...
    bvpfailenddata(:,3), 'or')
end
if ~isempty(noerrenddata)
plot3(noerrenddata(:,1),noerrenddata(:,2),...
             noerrenddata(:,3), 'ob')
end
if ~isempty(straightenddata)
plot3(straightenddata(:,1),...
             straightenddata(:,2),straightenddata(:,3), 'og')
end
if ~isempty(lsfailenddata)
plot3(lsfailenddata(:,1),lsfailenddata(:,2),...
             lsfailenddata(:,3), 'oy')
end
title('end p0s')
legend('bvpfailend','noerrend','straightend',...
    'lsfailend', 'Location', 'Best')


% End of function
end
