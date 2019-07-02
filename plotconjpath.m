function output = plotconjpath

% Goal: plot path of one rod's p0s from start through to end
% Differentiate between stable and unstable p0 locations

unstablep0 = [];
stablep0 = [];

for i = 1:10

    % Load the data method 1
    % filename = sprintf('plotp0_%i',i)

    % Load the data method 2
    filename = sprintf('plotp02_%i',i)

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
        end

    % end of n forloop
    end

% end of i forloop
end

% plot it all at the end
figure(1)
view(3)
hold on
if ~isempty(unstablep0)
plot3(unstablep0(:,1), unstablep0(:,2), ...
    unstablep0(:,3), '*r')
end
if ~isempty(stablep0)
plot3(stablep0(:,1),stablep0(:,2),...
             stablep0(:,3), '.b')
end

% title method 1
% title('p0 paths')

% title method 2
title('p0 paths method 2')

legend('unstable p0','stable p0','Location', 'Best')
xlabel('p_1')
ylabel('p_2')
zlabel('p_3')
end
