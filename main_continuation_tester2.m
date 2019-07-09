function [output_tester, straightstart, bvpfailstart, lsfailstart,...
    noerrstart, straightend, bvpfailend, lsfailend, noerrend] = ...
    main_continuation_tester2
% Tests n random p0s for straightening
% output_tester n x m array of fields startp0, error, endp0, tconj
% .startp0 stores starting p of the n-th random p0 value in BVP
% .error stores no error, line search failed, or BVP solver failed for each step
% .endp0 stores new p0 after each BVP
% .tconj stores any conjugate points
% straightstart, bvpfailstart, etc store the initial p0s sorted by error
% straightend, bvpfailend, etc store the final p0s sorted by error

% Set weight
w = 5;

% Total computation time
tic

% Test n random p0 values for straightening
for n = 1:1
    
    % fprintf('n = %i \n',n)

    % Randomly select a p0 to test
    % First 2 components b/n -30,30 and last b/n -10,10
    p0 = [30 + (-30 - 30).*rand(1,2), 4 + (-4 - 4).*rand(1)];

    % output_tester(n).startp0 = p0;

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
    % disp('solved IVP');

    % Set up for straightening the rod with BVP
    % Gives position of discretized points on rod for starting stable shape
    XF_IVP = output_IVP.x
    % disp('Here is the first IVP sol = ')
    % disp(XF)
    nxf = [];

    % Straightening the rod by BVP, cut and rescale method
    % 199 to avoid discretization problems in solve_IVP
    for m = 1:199
        m
        % Store initial p0 for each iteration of each random p0
        output_tester(n,m).startp0 = p0;
        
        if m == 1
            xf = XF_IVP;
        end
        
        % Cut and rescale rod by original IVP entries
        % Adjust discretization by iteration number for efficiency
        xf(end,:) = [XF_IVP(201-m,1)/(1-m/200),...
            XF_IVP(201-m,2)/(1-m/200), XF_IVP(201-m,3)]
        newxf = xf(end,:);
        nxf = [nxf; newxf];

        % Update list of rod points
       %%% newxf = XF(end,:);
        
        output_BVP = solve_BVP(x0,p0,newxf,tf,params,m,w);
        
        % Before checking for errors, test for sufficient straightness
        % Check that slope in between every 2 consecutive points is 
        % close to 0
        suffstraight = 1;
        for i = 2:length(xf)
            slope = (xf(i,2)-xf(i-1,2))/(xf(i,1)-xf(i-1,1));
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
        
        % Second test for sufficient straightness
        % See if final xf is within small range of [1 0 0]
        suff = .001;
        if abs(xf(end,1)-goal(1))<suff && abs(xf(end,2)-goal(2))<suff
            output_tester(n,m).error = 'straight';
            break
        end
        
        % If not yet straight, store any error encountered in 
        % straightening, or if no errors
       output_tester(n,m).error = output_BVP.catch;

        % Try/catch block in case error prevented creation of output_BVP fields
        % p0, x, tconj
        try
        
            % Re-update
            p0 = output_BVP.p0;
            xf = output_BVP.x;
            % disp('after BVP')
            % disp(XF)

            output_tester(n,m).endp0 = p0;
            output_tester(n,m).tconj = output_BVP.tconj;
            
        catch 
            % If encountered an error, break from straightening loop
            break 
        end
        
        if ~isempty(output_tester(n,m).tconj)
            fprintf('found a conjugate point at m = %i',m)
            disp(output_tester(n,m).tconj)
        end 
     
    % End of straightening loop m for a specific random p0
    end

% End of random p0 loop n
end

% Save errors 
maxsize = 0;
for i = 1:n
    for j = 1:m
        if isempty(output_tester(i,j).error)
            if j-1 > maxsize
                maxsize = j-1;
            end
            break
        elseif j == m
            maxsize = j;
        end
end
outputlength = maxsize;

for i = 1:outputlength
    err(:,i) = extractfield(output_tester(:,i),'error')
end
err2 = err'

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
            fprintf('last for i = %i \n',i)
            disp(last)
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

% End computation time
toc


% End of function main_continuation_tester
end
