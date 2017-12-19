%SGN Analysis
WTdir = 'M:\Bergles Lab Data\Projects\In Vivo Imaging and VG3 Paper\In Vitro Experiments\WT + NBQX';
VG3dir = 'M:\Bergles Lab Data\Projects\In Vivo Imaging and VG3 Paper\In Vitro Experiments\VG3KO + NBQX + BBE';

%load WT files
list = dir([WTdir '\**\SGNeventsV2.mat']);
WTallEvents = [];
WTallEventsTrace = [];
WTavgAll = [];
for i = 1:size(list,1)
    load([list(i).folder '\' list(i).name]);
    WTallEvents = [WTallEvents; eventStruct.groupWidths];
    for j=1:eventStruct.numCells
        if eventStruct.SGN(i).keepTrace
            WTallEventsTrace = [WTallEventsTrace; eventStruct.SGN(j).events];
        end
    end
    WTavgAll(i,:) =  eventStruct.avgEvent;
end
disp('complete');
list = dir([VG3dir '\**\SGNeventsV2.mat']);
VG3allEvents = [];
VG3avgAll = [];
VG3allEventsTrace = [];
figure; 
for i = 1:size(list,1)
    load([list(i).folder '\' list(i).name]);
    for j=1:eventStruct.numCells

           VG3allEventsTrace = [VG3allEventsTrace; eventStruct.SGN(j).events];

    end
    VG3allEvents = [VG3allEvents; eventStruct.groupWidths];
    VG3avgAll(i,:) = eventStruct.avgEvent;

end

figure; histogram(WTallEvents,[0:2.5:100],'Normalization','pdf'); hold on; histogram(VG3allEvents,[0:2.5:100],'Normalization','pdf');
% WTavg = mean(WTavgAll,1);
% VG3avg = mean(VG3avgAll,1);
WTavg = mean(WTallEventsTrace,1);
VG3avg = mean(VG3allEventsTrace,1);

figure; subplot(2,1,1); plot(WTavg-mean(WTavg(1:5)));  hold on; plot(VG3avg-mean(VG3avg(1:5))); subplot(2,1,2); plot(WTavg);  hold on; plot(VG3avg);
figure; plot((WTavg-mean(WTavg(1:5)))/max(WTavg-mean(WTavg(1:5))));  hold on; plot((VG3avg-mean(VG3avg(1:5)))/max(VG3avg-mean(VG3avg(1:5))));

%% fix for avgAllEvents
% list = dir([VG3dir '\**\SGNevents.mat']);
% for i = 1:size(list,1)
%     load([list(i).folder '\' list(i).name]);
%     for j=1:eventStruct.numCells
%          if ~isempty(eventStruct.SGN(j).allEvents)
%           if size(eventStruct.SGN(j).allEvents,1) > 1
%             eventStruct.SGN(j).meanAllEvents = nanmean(eventStruct.SGN(j).allEvents);
%           elseif size(eventStruct.SGN(j).allEvents,1) == 1
%             eventStruct.SGN(j).meanAllEvents = eventStruct.SGN(j).allEvents;
%           end
%         end
%     end
%     save([list(i).folder '\' list(i).name],'eventStruct');
% end

%% for widths
% list = dir([VG3dir '\**\SGNeventsV3.mat']);
% percentLong = [];
% figure(4); hold off; 
% VG3size = size(list,1);
% for i = 1:size(list,1)
%     figure(i); hold off; 
%     load([list(i).folder '\' list(i).name]);
%     VG3allEvents = [];
%     longNum = 0;
%     total = 0; 
%     for j = 1:eventStruct.numCells
%         if eventStruct.SGN(j).keepTrace
%             widths = eventStruct.SGN(j).keepEvents .* eventStruct.SGN(j).widths;
%             if find(widths > 30)
%                 longNum = longNum + 1;
%                 plot(smooth(eventStruct.SGN(j).dFoF+j*2),'r'); hold on;
%             else
%                 plot(smooth(eventStruct.SGN(j).dFoF+j*2),'k'); hold on;
%             end
%             total = total + 1;
%         end
%     end
%     percentLong(i) = longNum/total
%     %VG3allCell(i) = VG3allEvents;
%     %subplot(size(list,1),1,i); histogram(VG3allEvents,0:2.5:100);
% end
% 
% list = dir([WTdir '\**\SGNeventsV3.mat']);
% percentLongWT = [];
% 
% for i = 1:size(list,1)
%     figure(i + VG3size); hold off;
%     load([list(i).folder '\' list(i).name]);
%     WTallEvents = [];
%     longNum = 0;
%     total = 0; 
%     for j = 1:eventStruct.numCells
%         if eventStruct.SGN(j).keepTrace
%             widths = eventStruct.SGN(j).keepEvents .* eventStruct.SGN(j).widths;
%             if find(widths > 30)
%                 longNum = longNum + 1;
%                 plot(smooth(eventStruct.SGN(j).dFoF+2*j),'r'); hold on;
%             else
%                 plot(smooth(eventStruct.SGN(j).dFoF+2*j),'k'); hold on;
%             end
%             total = total + 1;
%         end
%     end
%     percentLongWT(i) = longNum/total
%     %VG3allCell(i) = VG3allEvents;
%     %subplot(size(list,1),1,i); histogram(WTallEvents,0:2.5:100);
% end

%% add raw data to files
%dname = 'M:\Bergles Lab Data\Projects\In Vivo Imaging and VG3 Paper\In Vitro Experiments\WT + NBQX';
% [fn dname] = uigetfile(dname);
% [fn2 dname2] = uigetfile(dname);
% 
% S = load([dname fn]);
% load([dname2 fn2]);
% 
% fns = fieldnames(S);
% SGNs = S.(fns{1});
% Fo = prctile(SGNs, 5); %bottom fifth percentile for baseline
% [m,n] = size(SGNs);
% SGNdFoF = (SGNs - Fo)./(repmat(Fo,m,1));
% 
% for i=1:n
%     eventStruct.SGN(i).rawData = SGNs(:,i);
%     eventStruct.SGN(i).dFoF = SGNdFoF(:,i);
% end
% 
% save([dname '\SGNeventsV3.mat'],'eventStruct');

