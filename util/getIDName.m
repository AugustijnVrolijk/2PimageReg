function filenamesShort = getIDName(filenames, filedates)
    arguments (Input)
        filenames (:,1) string
        filedates (:,1) datetime
    end
    arguments (Output)
        filenamesShort (:, 1) string
    end
    
    nfiles = length(filenames);
    filenamesShort(nfiles, 1) = "";
    
    for i = 1:nfiles
        temp_name = regexp(filenames(i), '^(.*?)_', 'tokens');
        name = temp_name{1}{1};  % Extract the first matched token
        filenamesShort(i) = append(name, ' ', string(filedates(i)));
    end
end