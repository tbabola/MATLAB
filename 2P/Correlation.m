%load file
filedir = 'M:\Bergles Lab Data\Projects\In vivo 2P Imaging\Snap25GC6s_SR101\';
[fn dname] = uigetfile(filedir);
img = loadTif([dname fn], 16);

%% downsample
imgR = imresize(img, 0.5);
[m,n,t] = size(imgR);
figure; imshow(mean(imgR,3)); caxis([0 max(max(mean(imgR,3)))]);
imgR = reshape(imgR,m*n,t);

%display image and pick point
[x,y] = getpts(gcf);
 y = [round(y(1)):40:256]
 [m,n] = size(y);
 x = repmat(round(x(1)),m,n);

 %%
corrImg = [];
for i = 1:n
    probe = img((y(i)-3:y(i)+3)*2,(x(i)-3:x(i)+3)*2,:);
    probe = squeeze(mean(mean(probe,1),2));
    
    workingCorr = corr(double(probe),double(imgR)');
    corrImg(:,:,i) = reshape(workingCorr,256,256);
end

%%
corrRGB = zeros(256,256,3);
%corrRGB(:,:,1) = corrImg(:,:,1)*1.5 + corrImg(:,:,4);
%corrRGB(:,:,2) = corrImg(:,:,2)*1.25 + corrImg(:,:,5);
%corrRGB(:,:,3) = corrImg(:,:,3)*0.75 + corrImg(:,:,6)*1.5;
corrRGB(:,:,1) = corrImg(:,:,1)*.8 + corrImg(:,:,3)/max(max(corrImg(:,:,1) + corrImg(:,:,3)));
corrRGB(:,:,2) = (corrImg(:,:,5) + corrImg(:,:,3))/max(max(corrImg(:,:,5) + corrImg(:,:,3)));
corrRGB(:,:,3) = corrImg(:,:,6)/max(max(corrImg(:,:,6)));

figure; imagesc(corrRGB)
data.corrImg = corrImg; data.corrRGB = corrRGB;
save([dname '2Pcorr.mat'],'data');