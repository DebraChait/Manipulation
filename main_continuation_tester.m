function [output_tester, straightstart, bvpfailstart, lsfailstart,...
    noerrstart, straightend, bvpfailend, lsfailend, noerrend] = ...
    main_continuation_tester

%tic
w = 5;

for n = 1:100
    
    fprintf('n = %i \n',n);
    
    % Randomly select a p0 between -10 and 10 to test
    p0 = [30 + (-30 - 30).*rand(1,2), 4 + (-4 - 4).*rand(1)];
    %p0 = [18.41761104	9.501353721	-3.463183167];
    %p0 = [24.9850731799204,-0.759932016327859,-6.65729649562770]
    % Final time
    tf = 1;
    
    % Initial condition for x(0)
    x0 = [0 0 0];
    
    % Final position for straight rod, horizontal dist of 1 from x0 position
    goal = x0;
    goal(1) = x0(1) + 1;
    
    
    % Parameters
    params = parameters;
    
    % Solve IVP to find stable shape
    output_IVP = solve_IVP(x0,p0,tf,params,0,w);
    
    % Set up for straightening the rod
    % Gives position of discretized points on rod for starting stable shape
    XF = output_IVP.x;
    nxf = [];
    % Straightening the rod by BVP, cut and rescale method
    for m = 1:199
        
        output_tester(n,m).startp0 = p0;
        
        % fprintf('Entering forloop round %i \n', m)
        
        % Initialize list of rod points
        xf = XF;
        
        % Cut and rescale rod by next-to-last entry
        % Adjust discretization by iteration number for efficiency
        XF(end,:) = [xf(end-1,1)/(1-1/(201-m)), ...
            xf(end-1,2)/(1-1/(201-m)), xf(end-1,3)];
        
        % Update list of rod points
        newxf = XF(end,:);
        nxf = [nxf; newxf];
        output_tester(n,m).xf = newxf;
        output_BVP = solve_BVP(x0,p0,newxf,tf,params,m,w);
        
        % Before checking for errors, test for sufficient straightness
        % Check that the slope in between every 2 consecutive points is
        % close to 0
        suffstraight = 1;
        for i = 2:length(XF)
            slope = (XF(i,2)-XF(i-1,2))/(XF(i,1)-XF(i-1,1));
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
            output_tester(n,m).error = 'straight';
            break
        end
        
        % Alternative test for sufficient straightness
        % See if final xf is within small range of [1 0 0]
        suff = .005;
        if abs(XF(end,1)-goal(1))<suff && abs(XF(end,2)-goal(2))<suff
            output_tester(n,m).error = 'straight';
            break
        end
        
        % If not yet straight, store any error encountered in
        % straightening, or if no errors
        output_tester(n,m).error = output_BVP.catch;
        m;
        %disp(output_tester(n,m).error)
        
        % if contains(output_tester(n,m).error,'BVP solver failed')
        % disp('new xf')
        % disp(newxf)
        % disp(norm([newxf(1) newxf(2)]))
        % output_tester(n,199).error = 'BVP solver failed';
        % end
        
        
        try
            % Re-update
            p0 = output_BVP.p0;
            XF = output_BVP.x;
            
            output_tester(n,m).endp0 = p0;
            output_tester(n,m).tconj = output_BVP.tconj;
        catch
            break
        end
        
        if ~isempty(output_tester(n,m).tconj)
            fprintf('found a conjugate point at m = %i',m)
            disp(output_tester(n,m).tconj)
        end
        
        % end of m for loop
    end
    
    
    
    % end of n for loop
end

%%% Extract data from the output_tester
% We want to plot the initial and final p0 values sorted by error

% Save errors
maxsize = 0;
for i = 1:n
    %i
    for j = 1:m
        % j
        % output_tester(i,j).error
        if isempty(output_tester(i,j).error)
            if j-1 > maxsize
                maxsize = j-1;
            end
            break
        elseif j == m
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
for i = 1:n
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

for i = 1:n
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

for i = 1:n
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
    end
end

%toc


% end of function
end
