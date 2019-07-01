function output = savedata
% Runs main_continuation_tester multiple times, saves data from each run

% How many times we want to run main_continuation_tester
for i = 1:2
    
    [output_tester, straightstart, bvpfailstart, lsfailstart,...
    noerrstart, straightend, bvpfailend, lsfailend, noerrend] = ...
    main_continuation_tester
    filename = sprintf('plotp0_%i',i)
    save(filename,'output_tester','straightstart','bvpfailstart',...
        'lsfailstart','noerrstart','straightend','bvpfailend',...
        'lsfailend','noerrend')
    
end


end
