%load raw data files, convert to tif, and save
 [fn dname] = uigetfile();
  cd(dname);
%  list = dir('*.czi');
% [m,n] = size(list);
%  
%  for i = 1:m
%      img = bfLoadTif(list(i).name);
%      [pathStr, name, ext] = fileparts(list(i).name);
%      writeTif(img, [pathStr name '.tif'],16);
%  end
%   
%load Tifs and Analyze
list = dir('*.tif');

m = size(list,1);
starttone = 57; %frames
toneISI = 50; %frames
toneDur = 10; %frames
before = 10;
after = 40;

toneImg = {};
for i = 1:m
    img = loadTif(list(i).name,16);
    img = normalizeImg(img,10,0);
    if i == 1
        [LICmask, RICmask,ctxmask] = ROIselectionIC(img, [512 512]);
        leftInd = find(LICmask);
        rightInd = find(RICmask);
    end
    
    for j = 1:16
        startImg = starttone + toneISI * (j - 1) - before;
        endImg = starttone + toneISI * (j - 1) + toneDur + after;
        toneImg{i,j} = img(:,:,startImg:endImg);
    end 
end

list = dir('*_*.mat');
m = size(list,1);
copyToneImg = toneImg;

%sort order based on random ordering of frequencies presented
for i = 1:m
    load(list(i).name);
    freqs = data.freqs;
    [freqSort, order] = sort(freqs);
    copyToneImg(i,:) = copyToneImg(i,order);
end

avgToneImg = {};
totalImg = [];
[mm,nn,tt] = size(copyToneImg{1,1});
LICsig = [];
RICsig = [];

for i = 1:16
    totalImg = zeros(mm,nn);
    for j = 1:m
        wimg = copyToneImg{j,i};
        totalImg = double(totalImg) + double(wimg);
        for k = 1:size(wimg,3)
            tempImg = wimg(:,:,k);
            LICsig(j,k,i) = mean(tempImg(leftInd));
            RICsig(j,k,i) = mean(tempImg(rightInd));
        end
        
    end
    avgToneImg{1,i} = totalImg/m;
end

%makes Brady-bunch style splaying of images versus frequency presented
concat = [];
for i = 1:4
   concat = [concat; normalizeImg(avgToneImg{1,(4*(i-1)+1)},10,0) normalizeImg(avgToneImg{1,(4*(i-1)+2)},10,0) normalizeImg(avgToneImg{1,(4*(i-1)+3)},10,0) normalizeImg(avgToneImg{1,(4*(i-1)+4)},10,0)];
end

%%implay(normalizeImg(avgToneImg{1,2},10))

figure;
leftInd = find(LICmask);
rightInd = find(RICmask);
for i = 1:16
    subplot(1,16,i)
    img = std(single(avgToneImg{1,i}),1,3);
    wimg = avgToneImg{1,i};
    for j = 1:size(wimg,3)
        tempImg = wimg(:,:,j);
        avgLIC(i,j) = mean(tempImg(leftInd));
        avgRIC(i,j) = mean(tempImg(rightInd));
    end
    
    imagesc(img);
end

figure;
for i = 1:16
    subplot(1,16,i)
    work = single(avgToneImg{1,i});
    img = std(work(:,:,1:12),1,3);
    imagesc(img);
    caxis([0 500]);
end

%%single traces tones
copySigR = RICsig;
copySigL = LICsig;
for j = 1:size(RICsig,1)
    copySigR(j,:,:) = copySigR(j,:,:) - (j-1) * 0.4;
    copySigL(j,:,:) = copySigL(j,:,:) - (j-1) * 0.4;
end

lt_org = [255, 166 , 38]/255;
dk_org = [255, 120, 0]/255;
lt_blue = [50, 175, 242]/255;
dk_blue = [0, 13, 242]/255;
figure;
for i = 1:16
    subplot(1,16,i);
    plot(copySigL(:,:,i)','Color',dk_org);
    hold on;
    plot(copySigR(:,:,i)','Color',dk_blue); 
    ylim([-3.75 0.5]);
    xlim([0 60]);
    patch([10 10 20 20], [1 -6 -6 1],'k','EdgeColor','none','FaceAlpha',0.2);
    yticklabels('');
end

Animal1.RICsig = RICsig;
Animal1.LICsig = LICsig;
%Animal1.sortedToneImg = copyToneImg;
%Animal1.avgToneImg = avgToneImg;
%Animal1.leftInd = leftInd;
%Animal1.rightInd = rightInd;
save([dname 'Animal1_sound.mat'],'Animal1');
