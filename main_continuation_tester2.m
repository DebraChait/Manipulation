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


% Total computation time
% tic

w = 5;

% Test n random p0 values for straightening
for n = 1:116
    
    fprintf('n = %i \n',n)

    % Randomly select a p0 to test
    % First 2 components b/n -30,30 and last b/n -10,10
    %p0 = [30 + (-30 - 30).*rand(1,2), 4 + (-4 - 4).*rand(1)];
    % p0 = [24.9850731799204,-0.759932016327859,-6.65729649562770]
    % p0 = [-2.31153446814127,13.0676901265067,-3.80766014303971];
    
    % p0s with instabilities before ext and w/o after ext
    % p0 = [-8.1946   -4.2535   -3.4169]
    % p0 = [-21.4978  -24.5647   -3.6933]
    % p0 = [19.7181   10.2015   -3.7318]
    % p0 = [20.9196    0.1968   -2.4692]

    p0full = [   21.0236   17.8352   -3.6397	;
    3.1276  -12.5783   -3.5547	;
  -25.3538    0.4612   -2.6721	;
  -29.6342   -6.2687   -3.5593	;
   28.0599   -3.4240   -1.7584	;
  -29.4784    4.3763   -3.6430	;
   10.1226    2.8049   -1.8991	;
   -0.5931    7.0491   -3.2439	;
   -7.0981    7.0188   -3.9295	;
   18.9340   27.2605   -3.0803	;
   22.7863   -4.3256   -3.5951	;
   17.4887   -9.9496   -3.7868	;
   -8.7271   -0.8113   -2.5154	;
   23.0876    7.4945   -2.6311	;
  -20.5066   -9.9143   -3.6811	;
    1.1518   26.0088   -3.1822	;
   -8.3127    6.9034   -2.1256	;
    9.4368    0.4020   -1.6142	;
   12.9424    3.8811   -3.2301	;
   28.6423   26.0956   -3.3917	;
    2.1121   22.1248   -3.0911	;
    2.0213  -27.0922   -3.7200	;
  -15.9171   -4.4720   -3.3274	;
   25.8613   19.9929   -3.5795	;
   29.8591   -8.4126   -2.4255	;
   15.6494   28.2445   -1.6185	;
  -23.0063   -9.9874   -2.7819	;
   -0.0240    4.0342   -3.2343	;
   19.2538   -8.0677   -3.7037	;
   -2.0408    1.2231   -2.3493	;
  -24.7892  -10.9511   -3.5739	;
  -16.6537    6.0569   -3.1864	;
   12.8089   25.3566   -3.2046	;
    4.1729    5.0269   -1.8301	;
  -23.4413    0.5597   -2.4466	;
  -12.9785  -25.2802   -3.8721	;
   22.3726   -9.2772   -2.9117	;
   -7.8600   11.0175   -3.6729	;
   26.0047    5.3383   -3.7527	;
  -14.0585    0.0311   -3.5464	;
   -7.9151   13.3078   -2.7187	;
  -28.5479   -1.3404   -3.2770	;
   24.8479   -1.8708   -3.1085	;
   12.2297    2.2331   -3.4019	;
   17.0467   29.9395   -3.2528	;
   11.0208  -17.0052   -3.7792	;
   -2.1049    6.0936   -1.3637	;
   -8.2777  -12.5667   -3.9410	;
  -29.0098   15.0994   -0.8508	;
   17.1457   -2.8237   -2.2777	;
   21.9152   10.5727   -3.6044	;
   -1.9278   15.1389    0.5018	;
  -19.0306    7.3471   -3.7808	;
   -6.3191    9.7058   -3.4239	;
    4.1288    1.4607   -2.2818	;
   -0.9407   -2.5549   -2.4679	;
   22.8201  -23.1959   -3.7623	;
  -13.9485   20.2230   -3.3686	;
  -17.2198    4.6459   -3.5498	;
    9.2998   10.2820   -3.4199	;
   17.7470   -9.7368   -3.3179	;
   21.9569   21.9249   -2.4476	;
   -1.4859  -26.6554   -3.9067	;
   20.7565   -2.4000   -3.4967	;
  -17.9737  -17.7701   -3.6327	;
  -10.7190    2.0958   -3.6261	;
   26.4577    7.1382   -1.7790	;
   -2.7599   23.2993   -3.2357	;
    9.0979    0.8214   -1.4361	;
   20.0576    6.0751   -3.3647	;
  -12.3647   27.6592   -0.9304	;
  -22.9576    3.7537   -2.6797	;
  -18.2446   -3.7596   -2.0070	;
  -29.8898   22.0881   -3.6374	;
    7.5699  -12.4041   -3.5793	;
   20.3162   -8.1273   -2.7515	;
   -7.8134   -9.8665   -3.9368	;
    4.3771   -4.6634   -3.1962	;
  -20.5319   -3.4138   -2.7191	;
   12.6276   28.8898   -1.6120	;
    5.7344   11.8658   -2.0585	;
   -9.7115   17.9985   -3.6799	;
   -9.9064   -2.4780   -2.9518	;
   14.3494    0.4152   -2.8467	;
   -6.2186    8.0858   -0.7887	;
   28.3204   25.9895   -3.4165	;
   15.2015   -2.5740   -2.2469	;
   -5.8764   28.6192   -3.1954	;
   -3.7128   15.5067   -3.3018	;
  -19.5441    3.3272   -3.8565	;
   -4.6961   15.9346   -2.4847	;
   21.4410   -0.7538   -3.7754	;
   -9.1811    2.3321   -2.9101	;
  -26.4780   15.3535   -3.6569	;
   -0.6495   -3.8748   -3.9497	;
    6.9502   -1.3876   -3.1372	;
  -25.1444    5.3577   -1.8589	;
   -3.0497  -11.6722   -3.4200	;
   27.7962   -2.3022   -1.8978	;
   21.7462    4.5548   -2.1165	;
   26.9126   11.5502   -3.7236	;
   -3.7520  -19.8336   -3.6616	;
   -5.8057   -5.1778   -3.7480	;
   10.8970   -0.6259   -2.1845	;
   -9.4310   -1.6989   -2.6062	;
   -6.1810   -3.6191   -2.7667	;
    8.7104   -2.1457   -3.9267	;
   -7.6658    3.1958   -2.4888	;
   24.6469   -1.2915   -2.6023	;
   22.9746    6.0870   -2.6511	;
    6.6258    0.5917   -3.0952	;
  -24.3029    0.0967   -0.2338	;
  -21.1753    0.8632   -2.9900	;
   11.4651   16.1473   -3.2735	;
   12.7254   13.9881   -3.1214	;
    8.0339   20.9991   -3.5706	];

p0 = p0full(n,:)

    
    output_tester(n).startp0 = p0;

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
    XF_IVP = output_IVP.x;
    % disp('Here is the first IVP sol = ')
    % disp(XF)
% nxf = [];

    % Straightening the rod by BVP, cut and rescale method
    % 199 to avoid discretization problems in solve_IVP
    for m = 1:199
        
        % Store initial p0 for each iteration of each random p0
        output_tester(n,m).startp0 = p0;
        
        if m == 1
            xf = XF_IVP;
        end
        xf(end,:) = [XF_IVP(201-m,1)/(1-m/200),...
            XF_IVP(201-m,2)/(1-m/200), XF_IVP(201-m,3)];
        newxf = xf(end,:);
%         nxf = [nxf; newxf];

        % Initialize list of rod points
       % xf = XF;
       
        % Cut and rescale rod by next-to-last entry
        % Adjust discretization by iteration number for efficiency
%         XF(end,:) = [xf(end-1,1)/(1-1/(201-m)), ...
%            xf(end-1,2)/(1-1/(201-m)), xf(end-1,3)];
% %        XF(end,:) = [xf_ivp(201-m,1)/(1-1/(201-m)), ...
% %            xf_ivp(201-m,2)/(1-1/(201-m)), xf_ivp(201-m,3)];
            % disp('rescaled')
            % disp(XF)

        % Update list of rod points
       %%% newxf = XF(end,:);
        
        output_BVP = solve_BVP(x0,p0,newxf,tf,params,m,w);
        %%%%output_BVP = solve_BVP(x0,p0,XF,tf,params,0);
        
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
            % XF = = output_BVP.x;
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
disp('error')
disp(output_tester(n,m).error)
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
 end
outputlength = maxsize;

for i = 1:outputlength
    err(:,i) = extractfield(output_tester(:,i),'error');
end
err2 = err';

disp('last error')
disp(err2(end,:))


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
%             fprintf('last for i = %i \n',i)
%             disp(last)
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
% toc


% End of function main_continuation_tester
end
