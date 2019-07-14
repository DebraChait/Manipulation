function [straightp0s,bvpfailp0s,lsfailp0s,noerrp0s] = savep0patherr

straightp0s = [];
bvpfailp0s = [];
lsfailp0s = [];
noerrp0s = [];

for s = 1:10
    
    % For method 1
    % filename = sprintf('plotp0_%i',s)
    % For method 2
    filename = sprintf('plotp0ext_nolsf_%i',s)
    load(filename)
    
    for p = 1:100
        if ~isempty(output_tester(p,199).error)
            p;
            disp(output_tester(p,199).error);
        end
    end
    
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
    end
    outputlength = maxsize;
    
    for q = 1:outputlength
        err(:,q) = extractfield(output_tester(:,q),'error');
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
    
    % errsave
    
    for k = 1:100
        if contains(errsave(k),'straight')
            for l = 1:199
                if ~isempty(output_tester(k,l).startp0)
                    straightp0s = [straightp0s; output_tester(k,l).startp0];
                end
            end
        elseif contains(errsave(k),'BVP solver failed')
            for l = 1:199
                if ~isempty(output_tester(k,l).startp0)
                    bvpfailp0s = [bvpfailp0s; output_tester(k,l).startp0];
                end
            end
        elseif contains(errsave(k),'line search failed')
            for l = 1:199
                if ~isempty(output_tester(k,l).startp0)
                    lsfailp0s = [lsfailp0s; output_tester(k,l).startp0];
                end
            end
        elseif contains(errsave(k),'no error')
            for l = 1:199
                if ~isempty(output_tester(k,l).startp0)
                    noerrp0s = [noerrp0s; output_tester(k,l).startp0];
                end
            end
        end
    end
    
    % For method 1
    % filename = sprintf('plotp0patherr_%i',s)
    % For method 2
    filename = sprintf('plotp0patherr_ext_nolsf_%i',s)
    save(filename,'straightp0s','bvpfailp0s','lsfailp0s','noerrp0s')
    
end




end
