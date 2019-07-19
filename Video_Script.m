% make_jam_session_videos.m

% Change video title here
TITLE = 'Straighten with Weight';
clear F;
framenum = 1;

% Stored data from a simulation
load('WeightFail.mat');

fighandle1 = figure;
% Setting window size
fighandle1.Position = [440 106 900 700];


p0 = [-11.6897   10.9740   -4.5022];
% works with no weight, fails w weight 5

% Final time
tf = 1;

% Initial condition for x(0)
x0 = [0 0 0];

params = parameters;

% Solve the initial IVP to constuct solution for given p0
output_IVP = solve_IVP(x0, p0, tf, params,0);
XF = output_IVP.x;


% Loop through frames
% CHEAT: Make this one less than the length(output_tester) if there is an
% error
    for m = 1:197
        xf = XF;
        XF(end, :) = [xf(end-1,1)/(1-(1/(201-m))), xf(end-1,2)/(1-(1/(201-m))),...
            xf(end-1,3)];
        newxf = XF(end,:);
        output_BVP = solve_BVP(x0,p0,newxf,tf, params,m);
        if ~isempty(p0)
            p0 = output_BVP.p0;
        else
            break
        end
        XF = output_BVP.x;
        hold on
        
        % Test for sufficient straightness (1)
        suffstraight = 1;
        for i = 2:length(XF)
            slope = (XF(i,2)-XF(i-1,2))/(XF(i,1)-XF(i-1,1));
            if abs(slope) > 0.025
                suffstraight = 0;
                break
            end
        end
        
        % Second test for sufficient straightness
        % See if final xf is within small range of [1 0 0]
        suff = .001;
        goal = [1, 0, 0];
        if abs(XF(end,1)-goal(1))<suff && abs(XF(end,2)-goal(2))<suff
            % output_tester(n,m).error = 'straight';
            break
        end
        normp0 = norm(p0);
        
%         % If not yet straight, store any error encountered in
%         % straightening, or if no errors
%         output_tester(n,m).error = output_BVP.catch;
%         
        % Try/catch block in case error prevented creation of output_BVP fields
        % p0, x, tconj
%         try
%             % Re-update
%             p0 = output_BVP.p0;
%             XF = output_BVP.x;
%             % disp('after BVP')
%             % disp(XF)
%             
%             output_tester(1,m).endp0 = p0;
%             output_tester(1,m).tconj = output_BVP.tconj;
%             
%         catch
%             % If encountered an error, break from straightening loop
%             break
%         end
%         if ~isempty(output_tester(1,m).tconj)
%             fprintf('found a conjugate point at m = %i',m)
%             disp(output_tester(1,m).tconj)
%         end 
%         % End of straightening loop m for a specific random p0
%         if isempty(output_BVP.p0)
%             break
%         end
        
            % axis labels
    xlabel('x_1')
    ylabel('x_2')
    
    % aspect ratio
    daspect([1 1 1])
    
    % set font size
    set(gca, 'FontSize', 20, 'color', 'w')
    drawnow;
    pause(0.01);
    % Adding frames and incrementing framenum
    F(:, framenum) = getframe(fighandle1);
    framenum = framenum + 1;
    hold off;
    end


  

% Write frames to mp4
v = VideoWriter(TITLE,'MPEG-4');
v.FrameRate = 4;
v.open();
v.writeVideo([F]);
v.close();
