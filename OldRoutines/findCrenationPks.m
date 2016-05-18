function [pks, locs] = findCrenationPks(signal)
    time = zeros(1,size(signal(:),1));
    time = (1:1:size(signal(:),1));
    time = reshape(time,[size(signal,1),size(signal,2)]);
    assignin('base','time',time);
    sizeZ = size(time,2);
    
    for iEle = 1:sizeZ
        [pks,locs] = findpeaks(signal(:,iEle),time(:,iEle), 'MinPeakHeight',0.4, 'MinPeakDistance',3);
        locsName = strcat('locs',num2str(iEle));
        pksName = strcat('pks',num2str(iEle));
        assignin('base',locsName,locs);
        assignin('base',pksName,pks);
        disp(size(locs,1));
        figure(iEle);
        plot(time(:,iEle),signal(:,iEle));
        hold on;
        plot(locs,pks,'o');
    end
    
    
    
   
end