% %load movie
%  d = 'M:\Bergles Lab Data\Projects\In vivo 2P Imaging\Snap25GC6s_SR101\';
%  [fn dname] = uigetfile(d);
%  img = loadTif([dname fn],16);
%  img = imresize(img,.25);
%img = normalizeImg(img, 5, 1);
% 
% 
% %
f = squeeze(mean(mean(img,1),2));
f = smooth(f);
time = [1:1:size(f,1)];
f = msbackadj(time',f);
thrImg = mean(img,3) + 3*std(double(img),[],3);
[pks, locs] = findpeaks(f,'MinPeakProminence',std(f));
datas = struct();
datas.time = size(img,3);
%%
length = size(img,1);
matrix = zeros(length, length, 90);
rectSize = 10; %width of the rectangle
rectPts = [-length*1.25 length*1.25 length*1.25 -length*1.25;0+rectSize 0+rectSize 0-rectSize 0-rectSize]; 

%%initialize angles and images of rotated bars
rots = (45:-2.5:-135)';
rotStruct = struct();

for i = 1:size(rots,1)
        rotMat = [cosd(rots(i))  -sind(rots(i)); sind(rots(i)) cosd(rots(i))];
        rotPts = rotMat * rectPts;
        rotPts = [rotPts(1,1) rotPts(2,1) rotPts(1,2) rotPts(2,2) rotPts(1,3) rotPts(2,3) rotPts(1,4) rotPts(2,4) ]; 
        rectMat = insertShape(matrix(:,:,1),'FilledPolygon',[rotPts]+length/2,'LineWidth',5);
        rectMat = rectMat(:,:,1);
        rectMat(rectMat ~= 0) = 1;
        %rectMat = imresize(rectMat,.5);
        rectMat = fliplr(rectMat);
        rotStruct(i).angle = rots(i);
        rotStruct(i).matrix = rectMat;
end

data2 = [];
data = struct();
figure;
 
for i = 1:size(locs,1)
    data(i).loc = locs(i);
    data(i).pks = pks(i);
    %randRot = round(rand*180)-90;
    %test = imrotate(img(:,:,locs(i))>thrImg,randRot);
    test = img(:,:,locs(i)) > thrImg;
    subplot(1,2,1); 
    imagesc(test); 
    caxis([0 1]);
    temp = [];
    for j = 1:size(rotStruct,2)
        correlation = xcorr2(test,rotStruct(j).matrix);
        %imshow(correlation/max(max(correlation))+imresize(rectMat,1.997));
        temp = [temp; rotStruct(j).angle squeeze(max(max(correlation)))];
    end
    
    maxValue = max(temp(:,2));
    [r,c,v] = find(temp == maxValue);
    maxAngle = temp(r,1);
    data(i).rotValues = temp;
    data(i).maxValues = [maxAngle(1) maxValue];
    subplot(1,2,2); 
    quiver(0,0,maxValue*cosd(maxAngle(1)), maxValue*sind(maxAngle(1))); xlim([-5000 5000]); ylim([-5000 5000]); drawnow;
    hold off;
    keep = input('Do you want to keep this trial?');
    data(i).keep = keep;
    
end
datas.events = data;
%figure; plot(data(:,1), data(:,2));

%% calculate total peaks   
[m,n] = size(datas.events);
normimg = normalizeImg(img, 5, 1);
normimg = normimg(10:118,10:118,:);
f = squeeze(nanmean(nanmean(normimg,1),2));
f = smooth(f);

groupPts = [];
for i=1:n
    datas.events(i).maxAmp = f(datas.events(i).loc);
    if datas.events(i).keep
        groupPts(i, :) = [datas.events(i).maxAmp*cosd(datas.events(i).maxValues(1)) datas.events(i).maxAmp*sind(datas.events(i).maxValues(1))];
    else
    end
end
figure;
line([zeros(size(groupPts,1))';groupPts(:,1)'],[zeros(size(groupPts,1))';groupPts(:,2)'],'Marker','o','Color',[0.7 0.7 0.7]);
datas.groupPts = groupPts;
datas.avgPts = mean(groupPts);
save([dname 'direction.mat'],'datas');

% %% playing with pot
% figure;
% line([zeros(size(groupPts,1))';-groupPts(:,1)'],[zeros(size(groupPts,1))';-groupPts(:,2)'],'Marker','o','Color',[0.7 0.7 0.7]);
% datas.groupPts = groupPts;
% datas.avgPts = mean(groupPts);
% maxRad = 0.075;
% xlim([-maxRad maxRad]);
% ylim([-maxRad maxRad]);
% 
% th = linspace(pi/4,5*pi/4,1000);
% xs = maxRad*cos(th);
% ys = maxRad*sin(th);
% hold on;
% plot(xs,ys,'Color', [0.7 0.7 0.7]);
% plot(xs*2/3,ys*2/3,'Color', [0.7 0.7 0.7]);
% plot(xs/3, ys/3,'Color', [0.7 0.7 0.7]);
% 
%%
list = dir(['M:\Bergles Lab Data\Projects\In vivo 2P Imaging\Snap25GC6s_SR101\*\direction.mat']);

binCounts = [];
for i = 1:size(list,1)
    fn = [list(i).folder '\' list(i).name];
    load(fn);
    angles = [];
    for j = 1:size(datas.events,2)
        if datas.events(j).keep
          angles = [angles; datas.events(j).maxValues(1)];
        end
    end
    
    avgPts = [avgPts; datas.avgPts];
    datas.degrees = angles;
    save(fn,'datas');
    figure;
    temp = polarhistogram(degtorad(180+datas.degrees),[-3*pi/2-pi/32:pi/16:pi/4+pi/32]);
    binCounts = [binCounts; temp.BinCounts];
    thetaticks([0:45:315]);
    rlim([0 40]);
    
end

figure;
temp = polarhistogram(degtorad(180+datas.degrees),[-3*pi/2-pi/32:pi/16:pi/4+pi/32]);
temp.BinCounts = mean(binCounts);
thetaticks([0:45:315]);
hold on; 
stdErr = std(binCounts,[],1)/sqrt(5);
midBin = conv(temp.BinEdges,[0.5 0.5]);
midBin = midBin(2:end-1);
for i = 1:size(midBin,2)
    polarplot([midBin(i) midBin(i)],[temp.BinCounts(i)-stdErr(i) temp.BinCounts(i)+stdErr(i)],'Color','k');
end
 rlim([0 40]);
% 
%% 
i = 1;
fn = [list(i).folder '\' list(i).name];
load(fn);

vals = [];

for i = 1:size(datas.events,2)
    if datas.events(i).keep
        vals = [vals; datas.events(i).maxValues];
    end
end

corrRot = datas.events(4).rotValues;
figure;
plot(corrRot(:,1),corrRot(:,2)/max(corrRot(:,2)),'o');
ylim([0 1.1])

% 
% 
% 
