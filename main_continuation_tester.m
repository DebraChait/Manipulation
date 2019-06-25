function [output_tester, straightstart, bvpfailstart, lsfailstart,...
    noerrstart, straightend, bvpfailend, lsfailend, noerrend] = ...
    main_continuation_tester
% Tests n random p0s for straightening
% output_tester n x m array of fields startp0, error, endp0, tconj
% .startp0 stores starting p of the n-th random p0 value in BVP
% .error stores no error, line search failed, or BVP solver failed for each step
% .endp0 stores new p0 after each BVP
% .tconj stores any conjugate points
% straightstart, bvpfailstart, etc store the initial p0s sorted by error
% straightend, bvpfailend, etc store the final p0s sorted by error


% Total computation time
tic

% Test n random p0 values for straightening
for n = 1:50
    
    % fprintf('n = %i \n',n)

    % Randomly select a p0 between -10 and 10 to test
    p0 = 10 + (-10 - 10).*rand(1,3);

    % output_tester(n).startp0 = p0;

    % Final time
    tf = 1;

    % Initial condition for x(0)
    x0 = [0 0 0];

    % Parameters
    params = parameters;

    % Solve IVP to find stable shape
    output_IVP = solve_IVP(x0,p0,tf,params,0);
    % disp('solved IVP');

    % Set up for straightening the rod with BVP
    % Gives position of discretized points on rod for starting stable shape
    XF = output_IVP.x;
    % disp('Here is the first IVP sol = ')
    % disp(XF)


    % Straightening the rod by BVP, cut and rescale method
    % 199 to avoid discretization problems in solve_IVP
    for m = 1:199

        % Store initial p0 for each iteration of each random p0
        output_tester(n,m).startp0 = p0;

        % fprintf('Entering forloop round %i \n', m)

        % Initialize list of rod points
        xf = XF;

        % Cut and rescale rod by next-to-last entry
        % Adjust discretization by iteration number for efficiency
        XF(end,:) = [xf(end-1,1)/(1-1/(201-m)), ...
            xf(end-1,2)/(1-1/(201-m)), xf(end-1,3)];
            % disp('rescaled')
            % disp(XF)

        % Update list of rod points
        newxf = XF(end,:);
        
        output_BVP = solve_BVP(x0,p0,newxf,tf,params,m);
        
        % Before checking for errors, test for sufficient straightness
        % Check that slope in between every 2 consecutive points is 
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
        
        % Second test for sufficient straightness
        % See if final xf is within small range of [1 0 0]
        suff = .001;
        if abs(XF(end,1)-goal(1))<suff && abs(XF(end,2)-goal(2))<suff
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
            XF = output_BVP.x;
            % disp('after BVP')
            % disp(XF)

            output_tester(n,m).endp0 = p0;
            output_tester(n,m).tconj = output_BVP.tconj;
            
        catch 
            % If encountered an error, break from straightening loop
            break 
        end
     
    % End of straightening loop m for a specific random p0
    end

% End of random p0 loop n
end

% Save errors 
outputlength = length(output_tester);
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

% Plot the initial p0s sorted by error
% Might want to make a separate function for this, ignore for now
% if ~isempty(straight)
%     figure(2)
%     straightplot = plot3(straight(:,1),straight(:,2),straight(:,3), 'bo')
%     title('Straight')
% end
% if ~isempty(bvpfail)
%     figure(3)
%     bvpplot = plot3(bvpfail(:,1),bvpfail(:,2),bvpfail(:,3), 'go')
%     title('BVP solver fail')
% end
% if ~isempty(lsfail)
%     figure(4)
%     lsfplot = plot3(lsfail(:,1),lsfail(:,2),lsfail(:,3), 'ro')
%     title('Line search fail')
% end
% if ~isempty(noerr)
%     figure(5)
%     noerrplot = plot3(noerr(:,1),noerr(:,2),noerr(:,3), 'mo')
%     title('No error, not straight')
% end

% End computation time
toc


% End of function main_continuation_tester
end
