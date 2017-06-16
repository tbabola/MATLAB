%% load image
 [fname, dname] = uigetfile('M:\Bergles Lab Data\Projects\In vivo imaging\*.tif','Multiselect','on');
 [pathstr, name, ext] = fileparts([dname fname]);
 X = loadTif([dname fname],16);
%X = bleachCorrect(X,10);
X = normalizeImg(X,10,1);
[m,n,t] = size(X);

X = flipud(X);
figure;
imagesc(X(:,:,1));
h = imellipse();
wait(h);
indices = [];
indices = find(h.createMask);
hvc = imellipse();
wait(hvc);
hvcindices = [];
hvcindices = find(hvc.createMask);

hsc = imellipse();
wait(hsc);
hscindices = [];
hscindices = find(hsc.createMask);

ICsignal = zeros(1,t);
VCsignal = zeros(1,t);
SCsignal = zeros(1,t);
for i=1:t
    Xw = X(:,:,i);
    ICsignal(i) = squeeze(mean(Xw(indices)));
    VCsignal(i) = squeeze(mean(Xw(hvcindices)));
    SCsignal(i) = squeeze(mean(Xw(hscindices)));
end

reX = single(reshape(X,m*n,t));

corrmat = corr(ICsignal', reX');
corrmat = reshape(corrmat,m,n);
figure; imagesc(corrmat);
%save([dname  name '_corrTestL'], 'corrmat');

indices = find(corrmat > 0.8);
indices = indices(indices > 40000);

ACsignal = zeros(1,t);
for i=1:t
    Xw = X(:,:,i);
    ACsignal(i) = squeeze(mean(Xw(indices)));
end

figure; plot(ICsignal); hold on; plot(ACsignal);
ICsignalMean = mean(ICsignal);
ACsignalMean = mean(ACsignal);
figure; plot(ICsignal-ICsignalMean); hold on; plot(ACsignal-ACsignalMean);
[corrx, lag] = xcorr(ICsignal-ICsignalMean, ACsignal-ACsignalMean);
lag = lag/10; %converts to seconds
figure; plot(lag, corrx,'o'); xlim([-.5 .2])

[ICpeaks, ACpeaks, VCpeaks, SCpeaks] = eventAvg(ACsignal, ICsignal, VCsignal, SCsignal)
save([dname  name '_corrdfof'], 'corrmat','corrx','lag','ICsignal','ACsignal','VCsignal','SCsignal',...
    'ICpeaks', 'ACpeaks', 'VCpeaks', 'SCpeaks');
%%alternative VC
corrmat = corr(SCsignal', reX');
corrmat = reshape(corrmat,m,n);
figure; imagesc(corrmat);
%save([dname  name '_corrTestL'], 'corrmat');

indices = find(corrmat > 0.8);
indices = indices(indices > 40000);
VCsignal = zeros(1,t);
for i=1:t
    Xw = X(:,:,i);
    ACsignal(i) = squeeze(mean(Xw(indices)));
end

%% plot all the plots
[fname, dname] = uigetfile('M:\Bergles Lab Data\Projects\In vivo imaging\*.tif','Multiselect','on');
cd(dname);
list = dir('*_corr.mat');
m = size(list,1);
corrx_tot =[];
corr_brain = [];
lag_tot = [];
figure;
for i=1:m
    load(list(i).name);
    subplot(m,2,1+(2*(i-1)));
    imagesc(corrmat);
    subplot(m,2,2+(2*(i-1)));
    %%contour(imgaussfilt(corrmat,3),[.6 .6]);
    size(ICsignal)
    ICsignal = ICsignal(:,1:5997);
    ACsignal =  ACsignal(:,1:5997);
    VCsignal =  VCsignal(:,1:5997);
    ICsignalMean = mean(ICsignal);
    ACsignalMean = mean(ACsignal);
    
    [corrx, lag] = xcorr(ICsignal-ICsignalMean, ACsignal-ACsignalMean,'coeff');
    corrx_tot(i,:) = corrx;
    lag_tot(i,:) = lag/10;
    mean_corrx = mean(corrx_tot);
    std_corrx = std(corrx_tot,1);
    temp = corr([ICsignal',ACsignal',VCsignal'])
    coor_brain(i,:) = temp(1,2:3);
end

lgray = [0.9 0.9 0.9];
figure(3); hold off; plot(lag_tot', corrx_tot','Color',lgray); hold on; 
scatter(lag_tot(:), corrx_tot(:),15,lgray,'filled');
plot(lag_tot(1,:),mean_corrx,'.','Color',[0 0 0],'MarkerSize',20)
errorbar(lag_tot(1,:),mean_corrx,std_corrx,'CapSize',0,'Color',[0 0 0],'LineStyle','none');
xlim([-1 1]);
ylim([0 1]);
xlabel('Auditory cortex lag relative to IC (s)'); ylabel('Correlation coefficient');
set(gcf, 'Renderer', 'Painters');

figure;
plot(smooth((ICsignal-min(ICsignal))/max((ICsignal-min(ICsignal))))+2,'k');
hold on;
plot(smooth((ACsignal-min(ACsignal))/max((ACsignal-min(ACsignal))))+1,'k');
plot(smooth((VCsignal-min(VCsignal))/max((VCsignal-min(VCsignal)))),'k');
set(gcf, 'Renderer', 'Painters');

figure;
plot(smooth((ICsignal-min(ICsignal))));
hold on;
plot(smooth((ACsignal-min(ACsignal))));

%%dfOF
figure;
plot(ICsignal+2,'k');
hold on;
plot(ACsignal+1,'k');
plot(VCsignal,'k');
set(gcf, 'Renderer', 'Painters');







% low = 0;
% hi = 1;
% figure(8);
% m = size(x,1);
% for i = 1:m
%     subplot(m,1,i);
%     %axesHand = axes;
%     imagesc(corrmatstore(10:end,10:end,i));
%     box off; axis off;
%     colormap(parula);
%     caxis([low hi]);
% end
% figure(9);
% meanImg = imgaussfilt(mean(norm_crop,3));
% imagesc(meanImg(10:end,10:end));
% box off; axis off;
% colormap(gfb);
% caxis([0.02 .14]);
%% Get all the averages
[fname, dname] = uigetfile('M:\Bergles Lab Data\Projects\In vivo imaging\*.tif','Multiselect','on');
cd(dname);
list = dir('*_corrdfof.mat');
m = size(list,1);
corrx_tot =[];
corr_brain = [];
lag_tot = [];
figure;
for i=1:m
    load(list(i).name);
    ACavg(:,i) = mean(ACpeaks,2);
    VCavg(:,i) = mean(VCpeaks,2);
    ICavg(:,i) = mean(ICpeaks,2);
    SCavg(:,i) = mean(SCpeaks,2);
end

figure; plot(mean(ICavg,2)); hold on; plot(mean(ACavg,2)); 
plot(mean(VCavg,2)); plot(mean(SCavg,2)); 