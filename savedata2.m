function output = savedata2
% Runs main_continuation_tester2 multiple times, saves data from each run
tic
% How many times we want to run main_continuation_tester
for i = 1:10
    i
    % If we want the variables of each run to have separate names
    % Not working yet
%     output_tester = sprintf('output_tester_%i',i)
%     straight = sprintf('straight_%i',i)
%     bvpfail = sprintf('bvpfail_%i',i)
%     lsfail = sprintf('lsfail_%i',i)
%     noerr = sprintf('noerr_%i',i)

% This gives an error
%     [sprintf('output_tester_%i',i),sprintf('straight_%i',i),...
%         sprintf('bvpfail_%i',i),sprintf('lsfail_%i',i),...
%         sprintf('noerr_%i',i)] = main_continuation_tester
    
    [output_tester, straightstart, bvpfailstart, lsfailstart,...
    noerrstart, straightend, bvpfailend, lsfailend, noerrend] = ...
    main_continuation_tester2;
    filename = sprintf('plotp02ext_nolsf_%i',i);
    save(filename,'output_tester','straightstart','bvpfailstart',...
        'lsfailstart','noerrstart','straightend','bvpfailend',...
        'lsfailend','noerrend')
    
end

toc
end
