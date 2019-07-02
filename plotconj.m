function output = plotconj

conjstart = [];
conjend = [];
noconjstart = [];
noconjend = [];

for i = 1:10
    
    % Load the data method 1
    % filename = sprintf('plotp0_%i',i)
    
    % Load the data method 2
    filename = sprintf('plotp02_%i',i)
    
    load(filename) 
    
    % Within each file, go through output_tester.tconj(n) for every n
    
    for n = 1:100
    
        % If we want to make this more efficient, determine last entry
        for m = 1:199
            
           if ~isempty(output_tester(n,m).tconj)
%               fprintf('n = %i, m = % i \n',n,m)
%               disp(output_tester(n,m).tconj) 
              conjstart = [conjstart; output_tester(n,1).startp0];
              
              % Get endp0
              last = 199;
              for j = 1:199
                 if isempty(output_tester(n,200-j).endp0)
                     last = last-1;
                 elseif ~isempty(output_tester(n,200-j).endp0)
                     break
                 end
              end
              conjend = [conjend; output_tester(n,last).endp0];
              
              % We know it has a conj point, so mark it as conj and break
              break
               
           end
           
           if m == 199
              noconjstart = [noconjstart; output_tester(n,1).startp0];
              
              % Get endp0
              last = 199;
              for j = 1:199
                 if isempty(output_tester(n,200-j).endp0)
                     last = last-1;
                 elseif ~isempty(output_tester(n,200-j).endp0)
                     break
                 end
              end
              noconjend = [noconjend; output_tester(n,last).endp0];
           end
            
        end
    
    end
    

end

figure(1)
view(3)
hold on
if ~isempty(conjstart)
plot3(conjstart(:,1), conjstart(:,2), ...
    conjstart(:,3), 'or')
end
if ~isempty(noconjstart)
plot3(noconjstart(:,1),noconjstart(:,2),...
             noconjstart(:,3), 'ob')
end
% title method 1
% title('start p0s conj/noconj')

% title method 2
title('start p0s conj/noconj method 2')

legend('conjstart','noconjstart','Location', 'Best')
xlabel('p_1(0)')
ylabel('p_2(0)')
zlabel('p_3(0)')

figure(2)
view(3)
hold on
if ~isempty(conjend)
plot3(conjend(:,1), conjend(:,2), ...
    conjend(:,3), 'or')
end
if ~isempty(noconjend)
plot3(noconjend(:,1),noconjend(:,2),...
             noconjend(:,3), 'ob')
end

% title method 1
% title('end p0s conj/noconj')

% title method 2
title('end p0s conj/noconj method 2')

legend('conjend','noconjend','Location', 'Best')
xlabel('p_1(1)')
ylabel('p_2(1)')
zlabel('p_3(1)')

end
