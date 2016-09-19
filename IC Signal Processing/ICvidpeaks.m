clear all;
[fname fpath] = uigetfile();
%load file and condense to 1-dimensional vecotr for analysis, smooth using
%Guassian
meanIC = loadTif([fpath fname],32);
meanIC = mean(meanIC,1);
meanIC = squeeze(meanIC);
smIC = imgaussfilt(meanIC,3);
time = [1:1:size(meanIC,2)];

%find peaks in signal
peaks = imregionalmax(smIC);
leftOrRight = 0; %0 is left, 1 is right

%blank out whole IC events, (events that are far left or far right)
peak_locs = find(peaks);
[r,c] = ind2sub(size(peaks),peak_locs);
if leftOrRight %picks out far left or far right events
    ctodel = c(r <= 15);
    c = c(r > 15);
    r = r(r > 15);
else
    ctodel = c(r >= 110);
    c = c(r < 110);
    r = r(r < 110);
end
blank_area = 5;
for i=1:size(ctodel,1)
    if i > blank_area
        peaks(:,ctodel(i)-blank_area:ctodel(i)+blank_area)= zeros(size(peaks(:,ctodel(i)-blank_area:ctodel(i)+blank_area)));
    end
end

sum_peaks = sum(peaks');
pks_smIC = smIC.*peaks;
pks_smIC(pks_smIC < 15) = 0;


figure;
imagesc(smIC');
hold on
h(2) = scatter(r,c,'LineWidth',2);
ylim([0,600]);
colormap jet;
caxis([0,70]);

histoBuild = [];
for i=1:size(sum_peaks,2)
    histoBuild = [histoBuild i*ones(1,sum_peaks(i))]
end
figure;
histogram(histoBuild,20);
xlim([0,125]);



% peaks = zeros(size(meanIC));
% time = [1:1:size(meanIC,2)];
% 
% figure;
% surf([1:1:125],time,meanIC','EdgeColor','none');
% view(2);
% figure;
% surf([1:1:125],time,imgaussfilt(meanIC,2)','EdgeColor','none');
% view(2);
% figure;
% imagesc(imregionalmax(meanIC));
% figure;
% imagesc(imregionalmax(smIC));



% for i=1:size(meanIC,1)
%     [pks, locs] = findpeaks(double(meanIC(i,:)),time,'MinPeakProminence',5);
%     peaks(i,locs(:))=1;
% end
% 
% %times = meanIC .* peaks;
% times = meanIC;
% figure;
% surf([1:1:125],time,times','EdgeColor','none');
% view(2);
