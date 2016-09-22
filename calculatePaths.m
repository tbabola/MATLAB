function [ myelinPercent ] = calculatePaths( pathData )
%CALCULATEPATHS This function calculates the percentage myelination from
%the path lengths described in pathData

    pathNames = pathData(:,1);
    pathMatData = cell2mat(pathData(:,2:4));
    axon_num = max(pathMatData(:,1)); % pulls out the number of axons
    totalAxonLength = [];
    totalSheathLength = [];
    axonName = [];
    
    for i = 1:axon_num
        axon = find(pathMatData(:,1)==i & pathMatData(:,2)==0);
        temp = pathMatData(axon,:);
        tempStr = pathNames(axon);
        totalAxonLength = [totalAxonLength; sum(temp(:,3))];
        axonName = [axonName; tempStr];
        
        sheath = find(pathMatData(:,1)==i & pathMatData(:,2)~=0);
        temp = pathMatData(sheath,:);
        totalSheathLength = [totalSheathLength; sum(temp(:,3))];
    end
    
    percentMyelin = (totalSheathLength ./ totalAxonLength)  * 100;
    myelinPercent = table(axonName,totalAxonLength,totalSheathLength,percentMyelin);
    


end

