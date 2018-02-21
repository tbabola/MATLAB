%% the goal is to find the "spread" of events

%load file
% dname = 'M:\Bergles Lab Data\Projects\In Vivo Imaging and VG3 Paper\In Vitro Experiments\WT + NBQX\';
% WTlist = loadFileList([dname '\*\*V3.mat']);
% WTCM = loadFileList([dname '\*\*CM.csv']);
% dname = 'M:\Bergles Lab Data\Projects\In Vivo Imaging and VG3 Paper\In Vitro Experiments\VG3KO + NBQX + BBE\';
% WTlist = loadFileList([dname '\*\*V3.mat']);
% WTCM = loadFileList([dname '\*\*CM.csv']);
dname = 'M:\Bergles Lab Data\Papers\TMIE\Fig. 8 - TMIE KO\Data\TMIE KO SGN Imaging\';
WTlist = loadFileList([dname '\*\*V3.mat']);
WTCM = loadFileList([dname '\*\*CM.csv']);
activeFile = 1;
WTlist{activeFile}
WTCM{activeFile}
%%


S = load(WTlist{activeFile});
fields = fieldnames(S);
eventStruct = S.(fields{1});
keepTrace = int8(find([eventStruct.SGN(:).keepTrace]));

%figure;
for i = 1:eventStruct.numCells
    if eventStruct.SGN(i).keepTrace
        workingTrace = smooth(eventStruct.SGN(i).dFoF);
        time = [1:1:size(workingTrace,1)]';
        workingTrace = msbackadj(time, workingTrace);
        endTime = 1200;
        fivePercent = prctile(workingTrace,5,1);
        variation = workingTrace < fivePercent;
        stdDFOF = std(variation,1,1); %stds for all SGNs
        meanDFOF = mean(workingTrace(1:endTime,:),1);
        eventStruct.SGN(i).CV = stdDFOF/meanDFOF * 100;
        
        thr = meanDFOF + 3*stdDFOF;
        [pks, locs, widths] = findpeaks(workingTrace(1:2500), 'MinPeakProminence', thr);
        %findpeaks(workingTrace(1:endTime), 'MinPeakProminence', thr,'Annotate', 'extents')
        
        longWidths = find(widths > 20);
        longNum = size(longWidths);
        if longNum > 0
%             for i = 1:longNum
%                 xlim([locs(longWidths(i))-100 locs(longWidths(i))+100]);
%                 if input('Keep? ')
%                     if input('Change Time? ')
%                         locs(longWidths(i)) = input('Peak Times (s)');
%                     end
%                 else
%                     pks(longWidths(i)) = [];
%                     locs(longWidths(i)) = [];
%                     widths(longWidths(i)) = [];
%                 end   
%             end
        end
        
        eventStruct.SGN(i).thrBinary = zeros(size(workingTrace));
        eventStruct.SGN(i).thrBinary(locs) = 1;
        eventStruct.SGN(i).thrBinary = conv(eventStruct.SGN(i).thrBinary,[1 1]);
    end
    %plot(thrTrace + 1.1*i); hold on;
end
%%
figure;
group = [];
for i = 1:eventStruct.numCells
    if eventStruct.SGN(i).keepTrace
        group = [group; eventStruct.SGN(i).thrBinary'];
        plot(eventStruct.SGN(i).thrBinary + i * - 1.1); hold on;
    end
    
end

numCellsForEvent = 3;
[eventPks, eventLocs] = findpeaks(sum(group,1),'MinPeakHeight', numCellsForEvent);
eventNum = size(eventLocs,2);
cellsPerEvent = {};
for i=1:eventNum
    cellsPerEvent{i} = find(group(:,eventLocs(i)));
end

%% load CM
csvR = csvread(WTCM{activeFile},1,1);
csvR = csvR(keepTrace',:);
pts = csvR;

distances = [];
for j=1:size(csvR,1)
    pt = csvR(j,:); 
    distances(:,j) = sqrt((pts(:,1)-pt(:,1)).^2+(pts(:,2)-pt(:,2)).^2);
end

h1 = figure('Position',[50 -50 800 800]);
newCellsPerEvents = {};
SGNeventSpread = struct();
j = 1;
for i = 1:size(cellsPerEvent,2)
    figure(h1); clf;
    viscircles(pts,repmat(5,size(pts,1),1),'Color',[0.7 0.7 0.7]); hold on;
    cells = cellsPerEvent{i};
    ptsEvents = pts(cells,:);
    viscircles(ptsEvents,repmat(5,size(ptsEvents,1),1),'Color','k');
    avgPt = mean(ptsEvents,1);
    stdPts = std(ptsEvents,[],1);
    tempdistances = ptsEvents - avgPt;
    tempdistances = sqrt(tempdistances(:,1).^2+tempdistances(:,2).^2)
    bigD = sum(find(tempdistances > 125)) > 0
    
    viscircles(avgPt,5,'Color','b');
    centerPt = findCenter(ptsEvents, avgPt);
    viscircles(centerPt,4,'Color','g');
    
    if bigD && input('Multiple Events?')
       idx = kmeans(ptsEvents,2);
       event1 = cells(idx == 1);
       numCells1 = size(event1,1);
       event2 = cells(idx == 2);
       numCells2 = size(event2,1);
       
       clf;
       viscircles(pts,repmat(5,size(pts,1),1),'Color',[0.7 0.7 0.7]); hold on;   
       
       if numCells1 >= numCellsForEvent
           ptsEvents = pts(event1,:);
           viscircles(ptsEvents,repmat(5,size(ptsEvents,1),1),'Color','k');
           avgPt = mean(ptsEvents,1);
           centerPt = findCenter(ptsEvents, avgPt);
           viscircles(centerPt,4,'Color','g');
           k = boundary(ptsEvents);
           plot(ptsEvents(k,1),ptsEvents(k,2));
           
           SGNeventSpread(j).avgPt = avgPt;
           SGNeventSpread(j).centerPt = centerPt;
           SGNeventSpread(j).cells = event1;
           SGNeventSpread(j).boundary = k;
           j = j+1;
    
       end
       
       if numCells2 >= numCellsForEvent
           ptsEvents = pts(event2,:);
           viscircles(ptsEvents,repmat(5,size(ptsEvents,1),1),'Color','k');
           avgPt = mean(ptsEvents,1);
           centerPt = findCenter(ptsEvents, avgPt);
           viscircles(centerPt,4,'Color','g');
           k = boundary(ptsEvents);
           plot(ptsEvents(k,1),ptsEvents(k,2));
           
           SGNeventSpread(j).avgPt = avgPt;
           SGNeventSpread(j).centerPt = centerPt;
           SGNeventSpread(j).cells = event2;
           SGNeventSpread(j).boundary = k;
           j = j+1; 
       end      
    else
        k = boundary(ptsEvents);
        plot(ptsEvents(k,1),ptsEvents(k,2));
        
        SGNeventSpread(j).avgPt = avgPt;
        SGNeventSpread(j).centerPt = centerPt;
        SGNeventSpread(j).cells = cells;
        SGNeventSpread(j).boundary = k;
        j = j+1;
    end
%pause(1);

end

%%

for i = 1:size(SGNeventSpread,2)
    cells = SGNeventSpread(i).cells;
    ptsEvents = pts(cells,:);
    
    distanceToAvg = findDistances(pts,SGNeventSpread(i).avgPt);
    distanceToAvg(cells,2) = 1;
    proportion = [];
    for j=1:25
        sholl = [(j-1)*20 j*20];
        distanceToAvg(distanceToAvg(:,1) > sholl(1) & distanceToAvg(:,1) <= sholl(2),3) = j;
        proportion(j,1) = sholl(2);
        proportion(j,2) = sum(distanceToAvg(:,1) > sholl(1) & distanceToAvg(:,1) <= sholl(2));
        proportion(j,3) = sum(distanceToAvg(:,2)==1 & distanceToAvg(:,3)==j);
    end
    
    proportion(proportion(:,3) > 0,4) = proportion(proportion(:,3) > 0,3)./proportion(proportion(:,3) > 0,2)
    SGNeventSpread(i).proportion = proportion;

    
    
end
tally = [];
for i = 1:size(SGNeventSpread,2)
    tally(:,i) = SGNeventSpread(i).proportion(:,4);
end

figure; plot(SGNeventSpread(1).proportion(:,1),mean(tally,2));

[path,name,ext] = fileparts(WTlist{activeFile})
save([path '\SGNspread.mat'],'SGNeventSpread'); 

%% group data
dname = 'M:\Bergles Lab Data\Papers\TMIE\Fig. 8 - TMIE KO\Data\TMIE WT SGN Imaging\';
WTlist = loadFileList([dname '\*\*Spread.mat']);
WTevents = [];
for i=2:2
    load(WTlist{i});
    tally = [];
    numCells = [];
    for j = 1:size(SGNeventSpread,2)
        tally(:,j) = SGNeventSpread(j).proportion(:,4);
        numCells(j) = size(SGNeventSpread(j).cells,1);
    end
    WTevents(i-1,:) = [size(SGNeventSpread,2) mean(numCells)];
end

figure;
plot(SGNeventSpread(i).proportion(:,1),mean(tally,2)); hold on;

dname = 'M:\Bergles Lab Data\Papers\TMIE\Fig. 8 - TMIE KO\Data\TMIE KO SGN Imaging\';
TMIElist = loadFileList([dname '\*\*Spread.mat']);
TMIEevents = [];
for i=1:size(TMIElist,1)
    load(TMIElist{i});
    tally = [];
    numCells = [];
    for j = 1:size(SGNeventSpread,2)
        tally(:,j) = SGNeventSpread(j).proportion(:,4);
        numCells(j) = size(SGNeventSpread(j).cells,1);
    end
   TMIEevents(i,:) = [size(SGNeventSpread,2) mean(numCells)];
   tallyAvg(:,i) = mean(tally,2);
end

plot(SGNeventSpread(i).proportion(:,1),mean(tallyAvg,2));


%%
function centerPt = findCenter(pts, avgPt)
    distances = findDistances(pts,avgPt);
    index = find(distances == min(distances));
    centerPt = pts(index,:);
    centerPt = centerPt(1,:);
end

function dist = findDistances(pts, refPt)
    dist = sqrt((pts(:,1)-refPt(1,1)).^2 + (pts(:,2)-refPt(1,2)).^2);
end




