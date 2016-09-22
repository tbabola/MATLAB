function [pathData] = loadPathData(file)
%LOADPATHDATA Loads relevant information from Fiji path files

    fid = readtable(file);
    pathName = fid{:,2};
    pathLength = fid{:,4};
    
    %parse information
    %axon information
    axon_index = find(cellfun(@isempty,strfind(pathName,'sheath')));
    axon_size = size(axon_index,1);
    axonNames = pathName(axon_index);
    axonLengths = pathLength(axon_index);
    %parse out axon number
    for i = 1:length(axonNames)
        s = axonNames{i,1};
        axonNames{i,2} = str2num(s(5:end));
        axonNames{i,3} = 0;
    end
    
    %sheath extraction
    sheath_index = find(~cellfun(@isempty,strfind(pathName,'sheath'))); %finds all indices where 'sheath' is in the name
    sheath_size = size(sheath_index,1);
    sheathNames = pathName(sheath_index);
    sheathLengths = pathLength(sheath_index);
    sheath_indexPos = cell2mat(strfind(pathName,'sheath'));
    for i = 1:length(sheathNames)
        s = sheathNames{i,1};
        if sheath_indexPos(i) == 6
            sheathNames{i,2} = str2num(s(sheath_indexPos(i)-1));
        elseif sheath_indexPos(i) == 7
            sheathNames{i,2} = str2num(s(sheath_indexPos(i)-2:sheath_indexPos(i)-1));
        end   
        sheathNames{i,3} = str2num(s(sheath_indexPos(i)+6:end));
    end
    
    %create array to return with all information
       %1 = name, 2=axon, 3=sheath, 4=length
    pathData = [axonNames num2cell(axonLengths)]; % add axon information
    pathData = [pathData; sheathNames num2cell(sheathLengths)];
      
    
end

