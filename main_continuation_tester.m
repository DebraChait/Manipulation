function output_tester = main_continuation_tester

tic
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

% Set up for straightening the rod
XF = output_IVP.x;
% disp('Here is the first IVP sol = ')
% disp(XF)


% Straightening the rod
for m = 1:200
    
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
        
        try 
            % Solve BVP with final position in line with updated rod
            output_BVP = solve_BVP(x0,p0,newxf,tf,params,m);
%             output_tester(n,m).error = output_BVP.catch;
            testing = output_BVP.p0;
        catch
            % disp('bad p0')
            % try
            output_tester(n,m).error = output_BVP.catch;
            % catch
            %     output_tester(n,m).error = 'weird'
            % end
            % find a way to show what error it encountered
            % if encountered a conjugate point, store that point
            break
        end
        output_tester(n,m).error = 'no error';
        
        
        % Re-update
        p0 = output_BVP.p0;
        XF = output_BVP.x;
        % disp('after BVP')
        % disp(XF)
        
        % Test for sufficient straightness
        % See if final xf is within small range of [1 0 0]
        
        endx1 = XF(end,1);
        endx2 = XF(end,2);
        % fprintf('endx1 = %.3d, endx2 = %.3d \n', endx1,endx2)
        slopenow = endx2/endx1;
        % fprintf('slope is %.3d at iteration %i \n',slopenow,m)
        if abs(slopenow)<.03
            break
        end
        
        output_tester(n,m).endp0 = p0;
        output_tester(n,m).tconj = output_BVP.tconj;
end

% Store starting p0, final p0, conj pts (if any), and error (if any)
% Plot the p0s

% disp('p0 = ')
% disp(p0)
% fprintf('norm(p0) = %.3d \n', norm(p0))

% If there was an error, there will be no output_BVP.tconj
try
    if ~isempty(output_BVP.tconj)
%         disp('conjugate points')
%         disp(output_BVP.tconj)
    else
       % disp('no conjugate points')
    end
catch
end
 
% output_tester(n).endp0 = p0;
% if ~isempty(output_BVP.tconj)
%         output_tester(n).tconj = output_BVP.tconj
%     else
%         disp('no conjugate points')
% end 

end

toc
end
