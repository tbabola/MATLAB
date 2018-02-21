% %%SGN average events
% dname = 'M:\Bergles Lab Data\Projects\In Vivo Imaging and VG3 Paper\In Vitro Experiments\'
% [fn dname] = uigetfile(dname);
% %WTfile = 'M:\Bergles Lab Data\Projects\In Vivo Imaging and VG3 Paper\In Vitro Experiments\WT + NBQX\Image2_WT_NBQX\Image2_VG3KO_SGNs.mat';
% %BBEfile = 'M:\Bergles Lab Data\Projects\In Vivo Imaging and VG3 Paper\In Vitro Experiments\VG3KO + NBQX + BBE\170910_Image9_VG3KO_NBQX_BBE\Image9_VG3KO_SGNs.mat';
% S = load([dname fn]);
% fns = fieldnames(S);
% SGNs = S.(fns{1});
% Fo = prctile(SGNs,10); %bottom tenth percentile for baseline
% [m,n] = size(SGNs);
% SGNdFoF = (SGNs - Fo)./(repmat(Fo,m,1));
% % WT
% %stdStart =800;
% % stdEnd = 1000;
% % VG3
% stdStart =1200;
% stdEnd = 1300;
% 
% measureStart = 1;
% measureEnd = 600;
% means = mean(SGNdFoF(stdStart:stdEnd,:));
% stds = std(SGNdFoF(stdStart:stdEnd,:),1,1);
% thr = 3 * stds;
% 
% figure;
% scale = max(max(SGNs,[],1))/4
% for i = 1:n
%     plot(SGNs(:,i)+(i-1)*scale); hold on;
% end
% 
% eventStruct = struct();
% SGNevents = {};
% meanEvents = [];
% timeBefore = 10;
% timeAfter = 40;
% stopLookingAt = 1000;
% for i=1:n
%     workingTrace = smooth(SGNdFoF(measureStart:measureEnd,i));
%     longEvents = getLongEvents(SGNdFoF(measureStart:measureEnd+200,i) > means(i) + 8*stds(i));
%     longEventsNum = size(longEvents,1);
%     keepLongEvents = [];
%     if longEventsNum > 0
%         figh = figure(1); figh.Position =[1000 800 1500 300]; hold off; plot(SGNdFoF(:,i),'Color','r'); xlim([0 stopLookingAt]);
%         if input('Any long events?')
%             eventStruct.SGN(i).hasLongEvents = 1;
%             for k = 1:size(longEvents,1)
%                 figh = figure(1); figh.Position =[1000 800 1500 300];
%                 if longEvents(k,1) < stopLookingAt
%                     plot(SGNdFoF(:,i)); hold on; line([longEvents(k,1) longEvents(k,2)],[1 1]);
%                     xlim([0 stopLookingAt]);
%                     if input('Keep?')
%                         keepLongEvents = [keepLongEvents; longEvents(k,:)];
%                     end
%                 end
%             end
%         else
%             eventStruct.SGN(i).hasLongEvents = 0;
%         end
%    else
%        eventStruct.SGN(i).hasLongEvents = 0;
%    end
% 
%     %debug peak detection
%     h = figure(5); findpeaks(workingTrace,'MinPeakProminence',thr(i),'Annotate','extents')
%     pause(0.75);
%     [pks, locs, w] = findpeaks(workingTrace,'MinPeakProminence',thr(i))
%     [mm, nn] = size(locs);
%     events = [];
%     if ~isempty(locs)
%         for j=1:mm
%             if locs(j)-timeBefore > 1 & locs(j)+timeAfter <= m
%                 events(j,:) = SGNdFoF(locs(j)-timeBefore:locs(j)+timeAfter,i);   
%             end
%         end
%     end
%     eventStruct.SGN(i).allEvents = events;
%     eventStruct.SGN(i).allEventsWidths = w;
%     eventStruct.SGN(i).allEventsPeaks = pks;
%     eventStruct.SGN(i).allEventsPeaks = locs;
%     
%     [pks, locs, w] = removeEvents(keepLongEvents, pks, locs, w);
%     [mm, nn] = size(locs);
%     events = [];
%     if ~isempty(locs)
%         for j=1:mm
%             if locs(j)-timeBefore > 1 & locs(j)+timeAfter <= m
%                 events(j,:) = SGNdFoF(locs(j)-timeBefore:locs(j)+timeAfter,i);   
%             end
%         end
%     end
%     eventStruct.SGN(i).shortEvents = events;
%     eventStruct.SGN(i).shortEventsWidths = w;
%     eventStruct.SGN(i).shortEventsPeaks = pks;
%     eventStruct.SGN(i).shortEventsPeaks = locs;
%     
%     timeBefore = 10;
%     totalTime = 200;
%     longEvents = []; locs = []; pks = []; w = [];
%     for j = 1:size(keepLongEvents,1)
%         start = keepLongEvents(j,1);
%         if start-timeBefore > 1 & start+totalTime <= m
%             longEvents(j,:) = SGNdFoF(start-timeBefore:start+totalTime,i);   
%         end
%     end
%     eventStruct.SGN(i).longEvents = longEvents;
%     
%     if ~isempty(eventStruct.SGN(i).allEvents)
%       if size(eventStruct.SGN(i).allEvents,1) > 1
%         eventStruct.SGN(i).meanAllEvents = nanmean(eventStruct.SGN(i).allEvents);
%       elseif size(eventStruct.SGN(i).allEvents,1) == 1
%         eventStruct.SGN(i).meanAllEvents = eventStruct.SGN(i).allEvents;
%       end
%     end
%     if ~isempty(eventStruct.SGN(i).shortEvents)
%       if size(eventStruct.SGN(i).shortEvents,1) > 1
%         eventStruct.SGN(i).meanShortEvents = nanmean(eventStruct.SGN(i).shortEvents);
%       elseif size(eventStruct.SGN(i).shortEvents,1) == 1
%         eventStruct.SGN(i).meanShortEvents = eventStruct.SGN(i).shortEvents;
%       end
%     end
%     if ~isempty(eventStruct.SGN(i).longEvents)
%       if size(eventStruct.SGN(i).longEvents,1) > 1
%         eventStruct.SGN(i).meanLongEvents = nanmean(eventStruct.SGN(i).longEvents);
%       elseif size(eventStruct.SGN(i).longEvents,1) == 1
%         eventStruct.SGN(i).meanLongEvents = eventStruct.SGN(i).longEvents;
%       end
%     end
% end
% 
% allEvents = [];
% meanShort = [];
% meanAll = [];
% meanLong = [];
% for i = 1:n
%     allEvents = [allEvents; eventStruct.SGN(i).allEventsWidths];
%     meanShort = [meanShort; eventStruct.SGN(i).meanShortEvents];
%     meanAll = [meanAll; eventStruct.SGN(i).meanAllEvents];
%     if ~isempty(eventStruct.SGN(i).longEvents)
%         meanLong = [meanLong; eventStruct.SGN(i).meanLongEvents];
%     end
% end
% figure; histogram(allEvents,[0:2.5:150]);
% figure; plot(mean(meanShort,1),'o'); hold on; plot(mean(meanAll),'o'); plot(mean(meanLong),'o');
% 
% eventStruct.numCells = size(SGNs,2);
% eventStruct.timeAnalyzed = datetime('now');
% 
% %save([dname 'SGNEvents.mat'],'eventStruct');
% 
% % function longEvents = getLongEvents(binSGN)
% %     labels = bwlabel(binSGN);
% %     longEvents = [];
% %     for i=1:max(labels)
% %         if size(labels(labels == i),1) > 30
% %             indices = find(labels == i);
% %             longEvents = [longEvents; indices(1) indices(end)];
% %         end
% %     end
% %     
% % end
% % 
% % function [pks, locs, w] = removeEvents(keepLongEvents, pks, locs, w)
% %     [m,n] = size(keepLongEvents);
% %     for i=1:m
% %         pks(locs > keepLongEvents(i,1) & locs < keepLongEvents(i,2)) = [];
% %         w(locs > keepLongEvents(i,1) & locs < keepLongEvents(i,2)) = [];
% %         locs(locs > keepLongEvents(i,1) & locs < keepLongEvents(i,2)) = [];
% %     end
% % end


%% new SGN analysis
dname = 'M:\Bergles Lab Data\Projects\In Vivo Imaging and VG3 Paper\In Vitro Experiments\';
dname = 'M:\Bergles Lab Data\Papers\';
[fn dname] = uigetfile(dname);

%ask for WT or VG3
correctExp = 0;
while ~correctExp
    condition = input('WT or VG3KO? ','s');
    if strcmp(condition, 'WT') 
        correctExp = 1;
        stdStart = 800; %measurement period for standard deviation; note: VG3 KO has additional drugs, hence STD measurement is further out
        stdEnd   = 1000;
    elseif strcmp(condition,'VG3KO')
        correctExp = 1;
        stdStart =1200; %measurement period for standard deviation
        stdEnd = 1300;
    elseif strcmp(condition,'TMIEKO')
        correctExp = 1;
        stdStart =2000; %measurement period for standard deviation
        stdEnd = 2100;
    else
        disp('Please enter WT or VG3KO or TMIEKO. ');
    end
end

%load data and create dFoF signals
S = load([dname fn]);
fns = fieldnames(S);
SGNs = S.(fns{1});
Fo = prctile(SGNs, 5); %bottom fifth percentile for baseline
[m,n] = size(SGNs);
SGNdFoF = (SGNs - Fo)./(repmat(Fo,m,1));

%setup parameters
measureStart = 1;
measureEnd = 1200;
means = mean(SGNdFoF(stdStart:stdEnd,:)); %means for all SGNs
stds = std(SGNdFoF,[],1); %stds for all SGNs
thr = 3 * stds; %threshold for all SGNs



eventStruct = struct();
eventStruct.condition = condition; eventStruct.numCells = size(SGNs,2);
eventStruct.stdPeriod = [stdStart stdEnd];
SGNevents = {};
avgEvent = [];
meanEvents = [];
totalWidths = [];
timeBefore = 10;
timeAfter = 40;
stopLookingAt = 1000;

%reject any noisy/non-responsive cells
for i=1:n
    workingTrace = SGNdFoF(:,i);
    if mean(workingTrace(end-100:end)) < means(i) + 3*stds(i)
        eventStruct.SGN(i).keepTrace = 0;
    else
        eventStruct.SGN(i).keepTrace = 1;
    end
    eventStruct.SGN(i).keepTrace = 1;
end
%plot of cells
figure(4);
scale = max(max(SGNs,[],1))/4;
j=1;
for i = 1:n
    if eventStruct.SGN(i).keepTrace
        plot(SGNs(:,i)+(j-1)*scale,'k'); hold on;
        j = j +1;
    end
end

%look for any events that come out of trace by 3 stds
for i=1:n
    if eventStruct.SGN(i).keepTrace
        workingTrace = smooth(SGNdFoF(measureStart:measureEnd,i));

        %debug peak detection
         h = figure(5); findpeaks(workingTrace,'MinPeakProminence',thr(i),'Annotate','extents')
         %pause(0.75);
         [pks, locs, w] = findpeaks(workingTrace,'MinPeakProminence',thr(i));
         [mm, nn] = size(locs);
         events = [];

         eventStruct.SGN(i).widths = w;
         eventStruct.SGN(i).origPeaks = pks;
         eventStruct.SGN(i).altLocs = locs; %used for adjustments in peak location for long events
         eventStruct.SGN(i).locs = locs;
    
         %check for very large widths and prompt user to verify width
        eventStruct.SGN(i).keepEvents = ones(size(w));
        %figure(6); plot(workingTrace);
        indices = find(w > 20);
%         if ~isempty(indices)
%             for j = 1:size(indices,1)
%                 indices(j)
%                 xlim([locs(indices(j))-200 locs(indices(j))+200]);
%                 if ~input('Keep?')
%                   eventStruct.SGN(i).keepEvents(indices(j))= 0;
%                 else
%                   if ~input('Keep Peak Location?')
%                       newPeakLoc = input('New Peak Location: ');
%                       if isnumeric(newPeakLoc)
%                           i
%                           eventStruct.SGN(i).altPeaks(indices(j)) = newPeakLoc;
%                       end
%                   end
%                 end
%             end
%         end
        
        %extract events
        indices = find(eventStruct.SGN(i).keepEvents);
        if ~isempty(indices)
            locs = eventStruct.SGN(i).altLocs(indices);
            for j=1:size(locs,1)
                if locs(j)-timeBefore > 1 & locs(j)+timeAfter <= m
                    events(j,:) = SGNdFoF(locs(j)-timeBefore:locs(j)+timeAfter,i);   
                end
            end
            
            eventStruct.SGN(i).events = events;
            eventStruct.SGN(i).avgEvent = mean(events,1);
         
            avgEvent(i,:) = eventStruct.SGN(i).avgEvent;
            totalWidths = [totalWidths;  eventStruct.SGN(i).widths(indices)];
        end
    else
        %even
    end
    eventStruct.SGN(i).dFoF = SGNdFoF(:,i);
    eventStruct.SGN(i).rawData = SGNs(:,i);
end

eventStruct.avgEvent = mean(avgEvent,1);
eventStruct.groupWidths = totalWidths;
eventStruct.timeAnalyzed = datetime('now');
save([dname '\SGNEventsV3.mat'],'eventStruct');


%% Correlation analysis
measureStart = 1;
measureEnd = 600;
groupTrace = [];
workingTrace = [];
for i=1:eventStruct.numCells
    if eventStruct.SGN(i).keepTrace
        workingTrace = smooth(eventStruct.SGN(i).dFoF(measureStart:measureEnd));
        groupTrace = [groupTrace; workingTrace'];
    else
        %even
    end
    
end

groupTrace = groupTrace';
corrMatrix = corr(groupTrace);
figure; imagesc(corrMatrix); clim([0 1]);
eventStruct.corrMatrix = corrMatrix;
%save([dname '\SGNEventsV4.mat'],'eventStruct');




