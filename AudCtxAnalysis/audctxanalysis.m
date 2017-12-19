%load raw data files, convert to tif, and save
%[fn dname] = uigetfile();
 cd(dname);
 list = dir('*.czi');
[m,n] = size(list);
 
 for i = 1:m
     img = bfLoadTif(list(i).name);
     [pathStr, name, ext] = fileparts(list(i).name);
     writeTif(img, [pathStr name '.tif'],16);
 end
 
%load Tifs and Analyze
list = dir('*.tif');

m = size(list,1);
starttone = 57; %frames
toneISI = 50; %frames
before = 10;
after = 30;

toneImg = {};
for i = 1:m
    img = loadTif(list(i).name,16);
    for j = 1:16
        startImg = starttone + toneISI * (j - 1) - before;
        endImg = starttone + toneISI * (j - 1) + after;
        toneImg{i,j} = img(:,:,startImg:endImg);
    end 
    
end

list = dir('*_*.mat');
m = size(list,1);
copyToneImg = toneImg;

for i = 1:m
    load(list(i).name);
    freqs = data.freqs;
    [freqSort, order] = sort(freqs);
    copyToneImg(i,:) = copyToneImg(i,order);
end

avgToneImg = {};
totalImg = [];
[mm,nn,tt] = size(copyToneImg{1,1});
for i = 1:16
    totalImg = zeros(mm,nn);
    for j = 1:m
        totalImg = double(totalImg) + double(copyToneImg{j,i});
    end
    avgToneImg{1,i} = totalImg/m;
end

concat = [];
for i = 1:4
   concat = [concat; normalizeImg(avgToneImg{1,(4*(i-1)+1)},10,0) normalizeImg(avgToneImg{1,(4*(i-1)+2)},10,0) normalizeImg(avgToneImg{1,(4*(i-1)+3)},10,0) normalizeImg(avgToneImg{1,(4*(i-1)+4)},10,0)];
end

%%implay(normalizeImg(avgToneImg{1,2},10))

figure;
for i = 1:16
    subplot(1,16,i)
    img = std(single(avgToneImg{1,i}),1,3);
    sig(:,i )= squeeze(mean(mean(avgToneImg{1,i},2),1));
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



%% One tone
[fn dname] = uigetfile();
cd(dname);
list = dir('*.tif');

m = size(list,1);
starttone = 50; %frames
toneISI = 50; %frames
before = 10;
after = 30;

toneImg = {};
for i = 1:m
    img = loadTif(list(i).name,16);
    for j = 1:16
        startImg = starttone + toneISI * (j - 1) - before;
        endImg = starttone + toneISI * (j - 1) + after;
        [startImg endImg]
        toneImg{i,j} = img(:,:,startImg:endImg);
    end 
    
end

avgToneImg = {};
[m,n,t] = size(copyToneImg{1,1});
for i = 1:16
    totalImg = zeros(m,n);
    totalImg = double(totalImg) + double(copyToneImg{1,i});
end
avgToneImg{1,i} = totalImg/16;
imagesc(avgToneImg);
