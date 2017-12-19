%function [ROIstats, SGNdFoF] = SGN_ROIsignals()
    [t,n] = size(test);
    time = [1:1:t]/10;
    ROIbl = test;
    ROImean = mean(ROIbl,2);
    
    
    Fo = prctile(ROIbl,10); %bottom tenth percentile for baseline
    ROIdFoF = (ROIbl - Fo)./(repmat(Fo,t,1));
    [r,c] = size(ROIdFoF);
    ROIdFoF = smooth(ROIdFoF,5);
    ROIdFoF = reshape(ROIdFoF,r,c);
    
    figure; plot(ROIdFoF);
    ROImean = mean(ROIdFoF,1);
    ROIstd = std(ROIdFoF,1,1);
    ROIthr = ROImean + ROIstd;
    
    before = 30;
    after = 100;
    eventsGroup = {};
    for i=1:n/2
        dFoF = ROIdFoF(:,1+2*(i-1));
        dFoFnp = ROIdFoF(:,2+2*(i-1));
        thr = ROIthr(1+2*(i-1));
        [pks, locs] = findpeaks(dFoF,'MinPeakHeight',thr,'MinPeakDistance',100,'Annotate','extents');
        [m1] = size(locs,1);
        events = [];
        
        for j = 1:m1
            wloc = locs(j);
            if locs(j) - before < 1
                lpt = 0;
                rpt = wloc + after;
            elseif locs(j) + after > t
                lpt = wloc - before;
                rpt = t;
            else
                lpt = wloc - before;
                rpt = wloc + after;
                events(j,:,1) = dFoF(lpt:rpt);
                events(j,:,2) = dFoFnp(lpt:rpt);
            end
        end
        eventsGroup{i} = events;
    end
    
    eventsAvg = [];
    figure;
    for i=1:size(eventsGroup,2)
        subplot(size(eventsGroup,2),1,i);
        events = eventsGroup{i};
        eventsAvg(:,i,1) = mean(events(:,:,1),1);
        eventsAvg(:,i,2) = mean(events(:,:,2),1);
        plot(eventsAvg(:,i,1)); hold on; plot(eventsAvg(:,i,2));
    end
    
    figure; subplot(2,1,1);
    meanNeuron = mean(eventsAvg(:,:,1),2);
    meanNP = mean(eventsAvg(:,:,2),2);
    plot(meanNeuron - mean(meanNeuron(1:10)),'o');
    hold on; plot(meanNP-mean(meanNP(1:10)),'o');
    
    subplot(2,1,2);
    plot(mean(eventsAvg(:,:,1),2)/max(mean(eventsAvg(:,:,1),2)),'o');
    hold on; plot(mean(eventsAvg(:,:,2),2)/max(mean(eventsAvg(:,:,2),2)),'o');
    

%end

% %% generate random seeds for cell traces
% numRands = 10;
% radius = 5;
% randx = round(rand(numRands,1)*512);
% randx(randx <= radius) = radius + 1;
% randx(randx + radius > 512) = 512 - radius;
% randy = round(rand(numRands,1)*512);
% randy(randy <= radius) = radius + 1;
% randy(randy + radius > 512) = 512 - radius;
% 
% seed = zeros(512,512);
% for i=1:numRands
%     seed(randy(i)-radius:randy(i)+radius, randx(i)-radius:randx(i)+radius) = 512;
% end
% figure(26);imagesc(seed);
% %%
% 
% function [chi, chiShuf, inputShuf] = synchronyIndex(input)
% %synchrony index computed as outlined @ http://www.scholarpedia.org/article/Neuronal_synchrony_measures
%     input = input;
%     [t,n] = size(input);
%     Vt = mean(input,2);
% 
%     %shuffle data;
%     R = randi(t,n,1);
%     inputShuf = zeros(t,n);
%     for i = 1:n
%         inputShuf(:,i) = [input(R(i):end,i); input(1:R(i)-1,i)];   
%     end
%     VtShuf = mean(inputShuf,2);
% 
%     time = [1:t]';
%     sig = trapz(time,Vt.^2)/time(end) - (trapz(time,Vt)/time(end)).^2;
%     sigSing = trapz(time,input.^2)/time(end) - (trapz(time,input)/time(end)).^2;
%     sigSing = mean(sigSing);
%     chi2 = sig/sigSing;
%     chi = sqrt(chi2)
% 
%     sigShuf = trapz(time,VtShuf.^2)/time(end) - (trapz(time,VtShuf)/time(end)).^2;
%     sigSingShuf = trapz(time,inputShuf.^2)/time(end) - (trapz(time,inputShuf)/time(end)).^2;
%     sigSingShuf = mean(sigSingShuf);
%     chi2shuf = sigShuf/sigSingShuf;
%     chiShuf = sqrt(chi2shuf)
% 
%     figure; plot(Vt);
% 
% end

