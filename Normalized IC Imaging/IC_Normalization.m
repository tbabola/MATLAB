%% load image
[fname, dname] = uigetfile('M:\Bergles Lab Data\Projects\In vivo imaging\*.tif','Multiselect','on');
X = loadTif([dname fname],16);
[m,n,t] = size(X);

%% get 10th percentiles
Xreshape = reshape(X,m*n,t)';
Fo = prctile(Xreshape,10,1);
X25 = reshape(Fo',m,n);

%%get Fo and display it

%% Fav - Fo ./Fo
[LICmask, RICmask, ctxmask] = getROImasks(X);
dFoF = double(X - X25) ./ double(X25);
LICsignal = dFoF.*LICmask;
LICsignal(LICsignal == 0) = NaN;
LICsignal = squeeze(mean(mean(LICsignal,2,'omitnan'),'omitnan'));

RICsignal = dFoF.*RICmask;
RICsignal(RICsignal == 0) = NaN;
RICsignal = squeeze(mean(mean(RICsignal,2,'omitnan'),'omitnan'));

ctxsignal = dFoF.*ctxmask;
ctxsignal(ctxsignal == 0) = NaN;
ctxsignal = squeeze(mean(mean(ctxsignal,2,'omitnan'),'omitnan'));

LICint = double(X25).*LICmask;
LICint(LICint == 0) = NaN;
LICint = mean(mean(LICint,2,'omitnan'),'omitnan');
RICint = double(X25).*RICmask;
RICint(RICint == 0) = NaN;
RICint = mean(mean(RICint,2,'omitnan'),'omitnan');
%%
[stats, pkData] = findICpeaksdFoF([LICsignal RICsignal ctxsignal],dname,'dFoF',1)
save([dname '\dFoFvars.mat'], 'LICint', 'RICint', 'X25');
