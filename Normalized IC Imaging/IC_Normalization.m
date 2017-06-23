%% load image
[fname, dname] = uigetfile('M:\Bergles Lab Data\Projects\In vivo imaging\*.tif','Multiselect','on');
X = loadTif([dname fname],16);
[m,n,t] = size(X);

%% get 10th percentiles
 [dFoF, Fo, img] = normalizeImg(X, 20, 1);
 %get Fo and display it

%% Fav - Fo ./Fo
[LICmask, RICmask, ctxmask] = getROImasks(X);
LICsignal = dFoF.*LICmask;
LICsignal(LICsignal == 0) = NaN;
LICsignal = squeeze(mean(mean(LICsignal,2,'omitnan'),'omitnan'));

RICsignal = dFoF.*RICmask;
RICsignal(RICsignal == 0) = NaN;
RICsignal = squeeze(mean(mean(RICsignal,2,'omitnan'),'omitnan'));

ctxsignal = dFoF.*ctxmask;
ctxsignal(ctxsignal == 0) = NaN;
ctxsignal = squeeze(mean(mean(ctxsignal,2,'omitnan'),'omitnan'));

LICint = double(Fo).*LICmask;
LICint(LICint == 0) = NaN;
LICint = mean(mean(LICint,2,'omitnan'),'omitnan');
RICint = double(Fo).*RICmask;
RICint(RICint == 0) = NaN;
RICint = mean(mean(RICint,2,'omitnan'),'omitnan');
%%
[stats, pkData] = findICpeaksdFoF(double([LICsignal RICsignal ctxsignal]),dname,'dFoF',1)
save([dname '\dFoFvars.mat'], 'LICint', 'RICint', 'Fo');
