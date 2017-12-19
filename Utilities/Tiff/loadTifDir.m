function [img] = loadTifDir(dname, search)
    list = dir([dname '\' search '*.tif'])
    list = struct2cell(list);
    list = list(1,:)';
    
    m = size(list,1);
    for i = 1:m
        %exclude "Preview" images
        if isempty(strfind(list{i},'Preview'))
            img(:,:,i) = imread([dname '\' list{i}]);
        end   
    end
end
