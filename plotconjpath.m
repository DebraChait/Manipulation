function output = plotconjpath

% Goal: plot path of one rod's p0s from start through to end
% Differentiate between stable and unstable p0 locations

% unstablep0 = [];
% stablep0 = [];
% % For plotting all paths, not just ones that have a conj point
% stablep0nc = [];

for i = 1:10
    
unstablep0 = [];
stablep0 = [];
% For plotting all paths, not just ones that have a conj point
stablep0nc = [];

    
    % Load the data method 1
    filename = sprintf('plotp0extgood_%i',i)
    
    % Load the data method 2
    % filename = sprintf('plotp02extgood_%i',i)
    
    load(filename)
    % load('plotp0_1')
    
    % Go through output_tester for each n and plot every p0
    % unstablep0 = [];
    % stablep0 = [];
    for n = 1:100
        
        % Keep track of whether rod stayed stable whole time
        unstablenow = [];
        stablenow = [];
        
        for m = 1:199
            
            if ~isempty(output_tester(n,m).tconj)
                % store that p0 as unstable
                unstablenow = [unstablenow; output_tester(n,m).startp0];
            else
                % store that p0 as stable
                stablenow = [stablenow; output_tester(n,m).startp0];
            end
            
            % end of m forloop
        end
        
        % Only store rods that underwent an instability
        if ~isempty(unstablenow)
            unstablep0 = [unstablep0; unstablenow];
            stablep0 = [stablep0; stablenow];
            % else for plotting all paths, not just ones with conj points
        else
            stablep0nc = [stablep0nc; stablenow];
        end
        
        % end of n forloop
    end
    
    % end of i forloop
    %end
    
    % plot it all at the end
    % For plotting all paths and not just ones with conj pts, move end of i loop
    % to after plots and use figure(i) to separate plots, and
    % name = sprintf('p0 paths plotp0 %i all',i); title(name), and add to legend
    
    figure(i)
    view(3)
    hold on
    if ~isempty(stablep0nc)
        plot3(stablep0nc(:,1), stablep0nc(:,2), ...
            stablep0nc(:,3), '.g')
    end
    if ~isempty(stablep0)
        plot3(stablep0(:,1),stablep0(:,2),...
            stablep0(:,3), '.b')
    end
    if ~isempty(unstablep0)
        plot3(unstablep0(:,1), unstablep0(:,2), ...
            unstablep0(:,3), '*r')
    end
    
    % title method 1
    % title('p0 paths ext method 1')
    
    % title method 2
    % title('p0 paths ext method 2')
    name = sprintf('p0 paths plotp0 ext %i all',i);
    title(name);
    
    legend('stable complete', 'stable p0','unstable p0','Location', 'Best')
    xlabel('p_1')
    ylabel('p_2')
    zlabel('p_3')

% end of i forloop    
end

end
