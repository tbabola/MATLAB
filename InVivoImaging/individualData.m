function [stats] = individualData(groupData, leftOrRight)
%for groupData, column 1 is animal, 2 is amplitude, 3 is x location, 4 is
%time
numAnimals = max(groupData(:,1));
stats = [];
for i=1:numAnimals
    temp = groupData(groupData(:,1)==i, :);
    
    if leftOrRight
        lowFreq = temp(temp(:,3) >= 25 & temp(:,3) <= 75, :);
        highFreq = temp(temp(:,3) > 75, :);
    else
        lowFreq = temp(temp(:,3) >= 50 & temp(:,3) <= 100, :);
        highFreq = temp(temp(:,3) < 50,:);
    end
    
    stats = [stats; i size(lowFreq,1) mean(lowFreq(:,2)) size(highFreq,1) mean(highFreq(:,2))];
    
end

stats
end