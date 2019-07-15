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

for s = 1:10
    
    % Load the data
    filename = sprintf('plotp0ext_nolsf_%i',s)
    load(filename,'output_tester')
    
    % Save errors
    maxsize = 0;
    for i = 1:100
        %i
        for j = 1:199
            % j
            % output_tester(i,j).error
            if isempty(output_tester(i,j).error)
                if j-1 > maxsize
                    maxsize = j-1;
                end
                break
            elseif j == 199
                maxsize = j;
            end
        end
    end %%%%%%%%%%%%%% just added this end
    outputlength = maxsize;
    
    for i = 1:outputlength
        err(:,i) = extractfield(output_tester(:,i),'error');
    end
    err2 = err';
    
    % errsavetemp tells us the error at each step
    % errsave(i) tells us result of random p0 #i
    errsavetemp='';
    errsave = [];
    
    % Collect final error for each random p0
    for i = 1:100
        for j = 1:outputlength
            errsavetemp = err2(j,i);
            if ~contains(err2(j,i),'no error')
                break
            end
        end
        errsave = [errsave,errsavetemp];
    end
    % disp(errsave)
    
    % Sort initial p0 values by error
    bvpfailstart = [];
    lsfailstart = [];
    straightstart = [];
    noerrstart = [];
    
    for i = 1:100
        if contains(errsave(i),'straight')
            straightstart = [straightstart; output_tester(i,1).startp0];
        elseif contains(errsave(i),'BVP solver failed')
            bvpfailstart = [bvpfailstart; output_tester(i,1).startp0];
        elseif contains(errsave(i),'line search failed')
            lsfailstart = [lsfailstart; output_tester(i,1).startp0];
        elseif contains(errsave(i),'no error')
            noerrstart = [noerrstart; output_tester(i,1).startp0];
        end
    end
    
    % Sort final p0 values by error
    bvpfailend = [];
    lsfailend = [];
    straightend = [];
    noerrend = [];
    
    for i = 1:100
        for j = 0:outputlength-1
            last = outputlength-j;
            if ~isempty(output_tester(i,last).endp0)
                % fprintf('last for i = %i \n',i)
                % disp(last)
                if contains(errsave(i),'straight')
                    straightend = [straightend; output_tester(i,last).endp0];
                elseif contains(errsave(i),'BVP solver failed')
                    bvpfailend = [bvpfailend; output_tester(i,last).endp0];
                elseif contains(errsave(i),'line search failed')
                    lsfailend = [lsfailend; output_tester(i,last).endp0];
                elseif contains(errsave(i),'no error')
                    noerrend = [noerrend; output_tester(i,last).endp0];
                end
                break
            end
            if last == 1
                if contains(errsave(i),'straight')
                    straightend = [straightend; output_tester(i,last).startp0];
                elseif contains(errsave(i),'BVP solver failed')
                    bvpfailend = [bvpfailend; output_tester(i,last).startp0];
                elseif contains(errsave(i),'line search failed')
                    lsfailend = [lsfailend; output_tester(i,last).startp0];
                elseif contains(errsave(i),'no error')
                    noerrend = [noerrend; output_tester(i,last).startp0];
                end
            end
        end
        % end of line 74 forloop, endp0 error sort
    end
    
    
    straightstartdata = [straightstartdata; straightstart];
    bvpfailstartdata = [bvpfailstartdata; bvpfailstart];
    lsfailstartdata = [lsfailstartdata; lsfailstart];
    noerrstartdata = [noerrstartdata; noerrstart];
    straightenddata = [straightenddata; straightend];
    bvpfailenddata = [bvpfailenddata; bvpfailend];
    lsfailenddata = [lsfailenddata; lsfailend];
    noerrenddata = [noerrenddata; noerrend];
    
% end of s forloop
end
% [m1,n1] = size([noerrenddata])
% [m2,n2] = size([straightenddata])
% save('startp0extw0nolsf_byerr','noerrstartdata')
% save('endp0extw0nolsf_byerr','noerrenddata')

% Plot the start p0s, colored by error
figure(1)
view(3)
hold on
% if ~isempty(lsfailstartdata)
% plot3(lsfailstartdata(:,1),lsfailstartdata(:,2),...
%              lsfailstartdata(:,3), 'oy')
% end
if ~isempty(straightstartdata)
    plot3(straightstartdata(:,1),...
        straightstartdata(:,2),straightstartdata(:,3), 'og')
end
if ~isempty(noerrstartdata)
    plot3(noerrstartdata(:,1),noerrstartdata(:,2),...
        noerrstartdata(:,3), 'ob')
end
if ~isempty(bvpfailstartdata)
    plot3(bvpfailstartdata(:,1), bvpfailstartdata(:,2), ...
        bvpfailstartdata(:,3), 'or')
end
title('start p0s no lsf w = 5 extensible')

% legend('lsfailstart','straightstart','noerrstart',...
%     'bvpfailstart','Location', 'Best')
legend('straightstart','noerrstart','bvpfailstart',...
    'Location', 'Best')

xlabel('p_1(0)')
ylabel('p_2(0)')
zlabel('p_3(0)')

% Plot the end p0s, colored by error
figure(2)
view(3)
hold on
% if ~isempty(lsfailenddata)
% plot3(lsfailenddata(:,1),lsfailenddata(:,2),...
%              lsfailenddata(:,3), 'oy')
% end
if ~isempty(straightenddata)
    plot3(straightenddata(:,1),...
        straightenddata(:,2),straightenddata(:,3), 'og')
end
if ~isempty(noerrenddata)
    plot3(noerrenddata(:,1),noerrenddata(:,2),...
        noerrenddata(:,3), 'ob')
end
if ~isempty(bvpfailenddata)
    plot3(bvpfailenddata(:,1), bvpfailenddata(:,2), ...
        bvpfailenddata(:,3), 'or')
end
title('end p0s no lsf w = 5 extensible')

% legend('lsfailend','straightend','noerrend','bvpfailend',...
%     'Location', 'Best')
legend('straightend','noerrend','bvpfailend','Location', 'Best')

xlabel('p_1(0)')
ylabel('p_2(0)')
zlabel('p_3(0)')


% End of function
end
