function output_tester = main_continuation_tester
% Tests n random p0s for straightening
% Output n x m array of fields startp0, error, endp0, tconj
% .startp0 stores starting p of the n-th random p0 value in BVP
% .error stores no error, line search failed, or BVP solver failed for each step
% .endp0 stores new p0 after each BVP
% .tconj stores any conjugate points


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
disp('This is where the error should be outputting')
for i = 1:198
    err(:,i) = extractfield(output_tester(:,i),'error')
end

err2 = err'

% End computation time
toc


% End of function main_continuation_tester
end
