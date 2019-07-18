function p0paths = save_pspace_raw

% increment weights
% for each weight, select random p0s
% plot for each p0 whether it is stable or unstable

tic

% set random weights
for i = [0:10:10, 20:20:120]
    
    w = i;
    
    % Initialize cell to store p0 paths
    p0paths = cell(101,3000);
    for row = 1:101
        for col = 1:30000
            p0paths{row,col} = zeros(1,3);
        end
    end
    
    % set random p0s on the shell of an ellipse
    r=randn(3000);
    r=bsxfun(@rdivide,r,sqrt(sum(r.^2,1)));
    x=r(1,:);
    y=r(2,:);
    z=r(3,:);
    n=sqrt(x.^2+y.^2+z.^2);
    xrange = 50;
    yrange = 50;
    zrange = 4;
    x=xrange*x./n;
    y=yrange*y./n;
    z=zrange*z./n;
    
    for j = 1:3000
        fprintf('w = %i, j = %i \n', w, j)        
        p0 = [x(j), y(j), z(j)];
        
        for k = 0:.01:1
            
            m = round((k*100)+1);
            p0now = [(k^2)*p0(1), (k^2)*p0(2), k*p0(3)];
            % p0now = [(k^2)*p0(1), (k^2)*p0(2)-w/2*(1 - k^2), k*p0(3)];
            p0paths{m,j} = p0now;
            
        % end of k forloop
        end
        
    % end of j forloop
    end
    
    % save data for plotting
    filename = sprintf('pspacedata_w%i_raw',w);
    save(filename,'p0paths');
    
% end of i forloop
end

toc

% end of function
end

%     if i == 1
%         w = 0;
%     elseif i == 2
%         w = 5;
%     elseif i == 3
%         w = 10;
%     elseif i == 4
%         w = 20;
%     elseif i == 5
%         w = 40;
%     elseif i == 6
%         w = 60;
%     elseif i == 7
%         w = 80;
%     elseif i == 8
%         w = 100;
%     elseif i == 9
%         w = 120;
%     end