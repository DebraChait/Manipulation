function output = plotconjpath

% Goal: plot path of one rod's p0s from start through to end
% Differentiate between stable and unstable p0 locations

% Load the data method 1
% filename = sprintf('plotp0_%i',i)
load('plotp0_1')

% Go through output_tester for each n and plot every p0
unstablep0 = [];
stablep0 = [];
for n = 1:100
    
    for m = 1:199
        
       if ~isempty(output_tester(n,m).tconj)
           % store that p0 as unstable
           unstablep0 = [unstablep0; output_tester(n,m).startp0];
       else
          % store that p0 as stable 
           stablep0 = [stablep0; output_tester(n,m).startp0];
       end
        
    end
    
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
title('p0 paths')
legend('unstable p0','stable p0','Location', 'Best')
xlabel('p_1')
ylabel('p_2')
zlabel('p_3')
end
