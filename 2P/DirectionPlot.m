% %load movie
% d = 'M:\Bergles Lab Data\Projects\In vivo 2P Imaging\Snap25GC6s_SR101\'
% [fn dname] = uigetfile(d);
% img = loadTif([dname fn],16);
% img = imresize(img,.25);
% 
% 
% %
f = squeeze(mean(mean(img,1),2));
f = smooth(f);
time = [1:1:size(f,1)];
f = msbackadj(time',f);
thrImg = mean(img,3) + 3*std(double(img),[],3);
[pks, locs] = findpeaks(f,'MinPeakProminence',1.5*std(f));
%%
length = size(img,1);

matrix = zeros(length, length, 90);


rectSize = 30;
rectPts = [-length*1.25 length*1.25 length*1.25 -length*1.25;0+rectSize 0+rectSize 0-rectSize 0-rectSize]; 

%%initialize angles and 
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
figure;
for i = 1:size(locs,1)
    randRot = round(rand*180)-90;
    %test = imrotate(img(:,:,locs(i))>thrImg,randRot);
    test = img(:,:,locs(i)) > thrImg;
    subplot(1,2,1); 
    imagesc(test); 
    caxis([0 1]);
    data = [];
    for j = 1:size(rotStruct,2)
        correlation = xcorr2(test,rotStruct(j).matrix);
        %imshow(correlation/max(max(correlation))+imresize(rectMat,1.997));
        data = [data; rotStruct(j).angle squeeze(max(max(correlation)))];
    end
    
    maxValue = max(data(:,2));
    [r,c,v] = find(data == maxValue);
    maxAngle = data(r,1);
    data2 = [data2; locs(i) maxAngle(1) maxValue]
    maxAngle(1)
    subplot(1,2,2); hold on;
    quiver(0,0,maxValue*cosd(maxAngle(1)), maxValue*sind(maxAngle(1))); xlim([-5000 5000]); ylim([-5000 5000]); drawnow;
    %hold off;
    pause(1);
    
end

%figure; plot(data(:,1), data(:,2));
    
    
