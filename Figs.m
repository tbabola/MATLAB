%%Figs for paper

%%Figure 1
rawFile = 'C:\Users\Bergles Lab\Desktop\temp\Experiment-330-P8-Snap25GC6s_baseline.tif';
pathStr = fileparts(rawFile);
img = loadTif(rawFile,16);
norm = normalizeImg(img,10,1);
filt = imgaussfilt3(norm(:,:,4000:5996));

handle = implay(filt);
handle.Visual.ColorMap.MapExpression = 'gfb';
handle.Visual.ColorMap.UserRangeMin = -0.1;
handle.Visual.ColorMap.UserRangeMax = 0.8;

filt = imgaussfilt3(norm(:,:,1:2058));

low = -.1;
hi = 0.8;
images = [1906; 1921; 1955; 2003; 2025; 2058];
images = [288; 328; 368; 
figure(3);
for i = 1:size(images,1)
    subplot(1,6,i);
    imagesc(filt(100:450,:,images(i)));
    colormap(gfb);
    caxis([low hi]);
    UL=[512*6 300];
    po=get(gcf,'position');
    po(3:4)=UL;
    set(gcf,'position',po);
    %imwrite([pathStr '\' num2str(i) '.tif'],
end

%load ICinfo
load('M:\Bergles Lab Data\Projects\In vivo imaging\WILDTYPE\DUP_Experiment-330_processed\ICinfo16_dFoF.mat');

rawFile = 'M:\Bergles Lab Data\Projects\In vivo imaging\Bilateral Mannitol Sham\DUP_Experiment-618_P7_Snap25GC6s_bilat_mannitol_PCA\Experiment-618_P7_Snap25GC6s_bilat_mannitol.tif';
pathStr = fileparts(rawFile);
img = loadTif(rawFile,16);
img = img(:,:,2900:5900);
norm = normalizeImg(img,10,1);
filt = imgaussfilt3(norm);

handle = implay(filt);
handle.Visual.ColorMap.MapExpression = 'gfb';
handle.Visual.ColorMap.UserRangeMin = -0.1;
handle.Visual.ColorMap.UserRangeMax = 0.8;

low = -.1;
hi = 0.8;
images = [1694;; ];
figure(3);
for i = 1:size(images,1)
    subplot(1,6,i);
    imagesc(filt(100:450,:,images(i)));
    colormap(gfb);
    caxis([low hi]);
    UL=[512*6 300];
    po=get(gcf,'position');
    po(3:4)=UL;
    set(gcf,'position',po);
    %imwrite([pathStr '\' num2str(i) '.tif'],
end








