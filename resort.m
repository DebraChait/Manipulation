function [output_tester,bvpfailstart,lsfailstart,noerrstart,...
    straightstart,bvpfailend,lsfailend,noerrend,straightend] = resort

% resorts data from extensibility case to get lsfailend    

for s = 1:10
    
    % Method 1
    filename = sprintf('plotp02ext_w0_%i',s)
    load(filename,'output_tester')
    
    % Method 2
    %     filename = sprintf('plotp02_%i',s)
    %     load(filename,'output_tester')
    
    % Save errors
    maxsize = 0;
    for i = 1:100
        %i
        for j = 1:199
            % j
            % output_tester(i,j).error
            if isempty(output_tester(i,j).error)
                if j-1 > maxsize
                    maxsize = j-1;
                end
                break
            elseif j == 199
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
    for i = 1:100
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
    
    for i = 1:100
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
    
    for i = 1:100
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
            if last == 1
                if contains(errsave(i),'straight')
                    straightend = [straightend; output_tester(i,last).startp0];
                elseif contains(errsave(i),'BVP solver failed')
                    bvpfailend = [bvpfailend; output_tester(i,last).startp0];
                elseif contains(errsave(i),'line search failed')
                    lsfailend = [lsfailend; output_tester(i,last).startp0];
                elseif contains(errsave(i),'no error')
                    noerrend = [noerrend; output_tester(i,last).startp0];
                end
            end
        end
    % end of line 74 forloop, endp0 error sort    
    end
    
    filename2 = sprintf('plotp02ext_w0good_%i',s)
    save(filename2,'output_tester','straightstart','bvpfailstart',...
        'lsfailstart','noerrstart','straightend','bvpfailend',...
        'lsfailend','noerrend')
    
% end of s forloop
end

% end of function
end
