function [unstablep0, stablep0, straightp0, notstraightp0,...
    sandwichp0,endunstable] = save_pspace

% increment weights
% for each weight, select random p0s
% plot for each p0 whether it is stable or unstable

tic

x0 = [0 0 0];
params = parameters;
tf = 1;
m = 0;

% set random weights
parfor o = 1:9
    
    if o == 1
        i = 0;
    elseif o == 2
        i = 5;
    elseif o == 3
        i = 10;
    elseif o == 4
        i = 20;
    elseif o == 5
        i = 40;
    elseif o == 6
        i = 60;
    elseif o == 7
        i = 80;
    elseif o == 8
        i = 100;
    elseif o == 9
        i = 120;
    end;
    w = i
    
    % Save points that are un/stable not/straight
    stablep0 = [];
    unstablep0 = [];
    straightp0 = [];
    notstraightp0 = [];
    % Save paths of sandwich and end unstable
    sandwichp0 = [];
    endunstable = [];
    
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
        
        fprintf('w = %i, j = %i \n', w,j)
        
        p0 = [x(j), y(j), z(j)];
        p0path = [];
        hitunstable = 0;
        
        for k = 0:.01:1
            
            p0now = [(k^2)*p0(1), (k^2)*p0(2), k*p0(3)];
            % p0now = [(k^2)*p0(1), (k^2)*p0(2)-w/2*(1 - k^2), k*p0(3)];
            p0path = [p0path; p0now];
            output_IVP = solve_IVP(x0,p0now,tf,params,m,w);
            
            % Check if there's a tconj
            if ~isempty(output_IVP.tconj)
                hitunstable = 1;
                unstablep0 = [unstablep0; output_IVP.p];
%                 if k ~= 1
%                     % Check if path goes from unstable to stable
%                     nextp0 = [((k+.01)^2)*p0now(1), ...
%                         ((k+.01)^2)*p0now(2)-w/2*(1 - (k+.01)^2), ...
%                         (k+.01)*p0now(3)];
%                     next_output_IVP = solve_IVP(x0,nextp0,tf,params,m,w);
%                     if ~isempty(next_output_IVP.tconj)
%                         % Add that line of p0s to sandwichp0
%                         sandwichp0 = [sandwichp0; p0path];
%                     end
%                 end
                % Check if it ends unstable
                if k == 1
                    endunstable = [endunstable; p0path];
                end
            else
                stablep0 = [stablep0; output_IVP.p];
                % Check if previous was unstable
                if hitunstable == 1
                    sandwichp0 = [sandwichp0; p0path];
                end
            end
            
            
            % Check if this is a straight p0
            XF = output_IVP.x;
            suffstraight = 1;
            suff = .005;
            goal = [1,0,0];
            for l = 2:length(XF)
                slope = (XF(l,2)-XF(l-1,2))/(XF(l,1)-XF(l-1,1));
                if abs(slope) > 0.025
                    suffstraight = 0;
                    break
                end
            end
            % If every point has slope ~0, break from straightening loop
            if suffstraight == 1
                % Note that sometimes doesn't pass this test but has no
                % tolerance error from BVP solver. Still okay or require
                % rod to pass this test?
                straightp0 = [straightp0; output_IVP.p];
            elseif abs(XF(end,1)-goal(1))<suff && ...
                    abs(XF(end,2)-goal(2))<suff
                straightp0 = [straightp0; output_IVP.p];
            else
                notstraightp0 = [notstraightp0; output_IVP.p];
            end
            
            % end of k forloop
        end
        
        %         if ~isempty(unstablep0now)
        %             unstablep0 = [unstablep0; unstablep0now];
        %         end
        %         if ~isempty(stablep0now)
        %             stablep0 = [stablep0; stablep0now];
        %         end
        
        % end of j forloop
    end
    
    % save data for plotting
    filename = sprintf('pspacedata_w%i',w);
    save(filename);
    
    % end of i forloop
end

toc

% end of function
end
