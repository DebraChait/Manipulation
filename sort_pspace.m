function [unstable,stable,straight,notstraight,sandwichp0s,...
    endunstablep0s] = sort_pspace

% Goals:
% Run IVP on p0s of each path
% Determine stability of p0s
% Determine straightness of p0s
% Scheme:
% Store indices of sandwich columns and end unstable cols (1 number)
% Store entry number of straight p0s and unstable p0s (2 numbers)

tic

x0 = [0 0 0];
params = parameters;
tf = 1;
m = 0;

for i = 5
    
    w = i
    
    % Load data
    filename = sprintf('pspacedata_ext_w%i_raw',w);
    load(filename)
    
    % 101 x 3000 arrays
    % 0 indicates stuff we don't care about, 1 indicates stuff we care about
    % entry = 0 if stable, 1 if unstable
    % entry = 0 if not straight, 1 if straight
    stability = zeros(101,3000);
    straightness = zeros(101,3000);
    
    % 1 x 3000 arrays
    % 0 indicates stuff we don't care about, 1 indicates stuff we care about
    % entry = 0 if path(column) does not have a sandwich, 1 if it does
        % sandwich == goes from stable -> unstable -> stable
        % (practically speaking, we just check for unstable -> stable)
    % entry = 0 if path(column) does not end unstable, 1 if it does
    sandwich = zeros(1,3000);
    endunstable = zeros(1,3000);
    
    for col = 1:3000
        
        col
        hitunstable = 0;
        
        for row = 1:101
            
            p0now = p0paths{row,col};
            output_IVP = solve_IVP(x0,p0now,tf,params,m,w);
            
            % Test each p0 for stability and each path for sandwich or if
            % it ends unstable
            if ~isempty(output_IVP.tconj) % unstable p0
                stability(row,col) = 1;
                hitunstable = 1;
                if row == 101
                    endunstable(1,col) = 1;
                end
            else % stable p0
                if hitunstable == 1
                    sandwich(1,col) = 1;
                end
            end
            
            % Test each p0 for straightness
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
                straightness(row,col) = 1;
            elseif abs(XF(end,1)-goal(1))<suff && ...
                    abs(XF(end,2)-goal(2))<suff
                straightness(row,col) = 1;
            end
            
        % end of row forloop    
        end
        
    % end of col forloop    
    end
    
    sort = sprintf('pspacedata_ext_w%i_key',i);
    save(sort)
    
    load('pspacedata_ext_w5_key')
    
    % Initialize to preallocate storage, runs faster
    unstable = zeros(303000,3);
    stable = zeros(303000,3);
    straight = zeros(303000,3);
    notstraight = zeros(303000,3);
    sandwichp0s = zeros(303000,3);
    endunstablep0s = zeros(303000,3);
    
    for col = 1:3000
        col
        for row = 1:101
            if stability(row,col) == 0
                stable = [stable; p0paths{row,col}];
            else
                unstable = [unstable; p0paths{row,col}];
            end
            
            if straightness(row,col) == 0
                notstraight = [notstraight; p0paths{row,col}];
            else
                straight = [straight; p0paths{row,col}];
            end
        end
        
        if sandwich(1,col) == 1
            for r = 1:101
                sandwichp0s = [sandwichp0s; p0paths{r,col}];
            end
        end
        if endunstable(1,col) == 1
            for r = 1:101
                endunstablep0s = [endunstablep0s; p0paths{r,col}];
            end
        end
    end
    
    sort = sprintf('pspacedata_ext_w%i_sorted',i);
    save(sort)

% end of i forloop    
end

toc

end