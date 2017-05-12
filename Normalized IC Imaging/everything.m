% load file 
  [fn dname] = uigetfile('M:\Bergles Lab Data\Projects\In vivo imaging\*.tif');
  X = loadTif([dname fn],16);
  [m,n,t] = size(X);
  
%   %register image
%   regMov = registerMovie(X);
%  h = figure('Position',[250 250 800 250]);
%  Xmean = mean(regMov,3);
%  h_im = imagesc(Xmean);
%  IC = imrect(gca,[0,0,512,150]);
%  setResizable(IC,0);
%  addNewPositionCallback(IC,@(p) title(mat2str(p,3)));
%  fcn = makeConstrainToRectFcn('imrect',get(gca,'XLim'),get(gca,'YLim'));
%  setPositionConstraintFcn(IC,fcn); 
%  wait(IC);
%  ICmask = createMask(IC, h_im);
%  
%  temp_img = zeros(150,512,'int16');
%  for i=1:t
%      curr = regMov(:,:,i);
%      temp_img(:,:,i) = reshape(curr(ICmask),150,512);
%  end
%  
temp_img = X;
 [dFoF,Fo,bcImg] = normalizeImg(temp_img,10,1);
 savedname = uigetdir();
 writeTif(bcImg,[savedname '\DUP_' fn],16);
 
%%  
 [LICmov, RICmov] = ROIselection(dFoF);
 meanLIC = squeeze(mean(LICmov,1));
 percentLIC = prctile(meanLIC,30,2);
 meanRIC = squeeze(mean(RICmov,1));
 percentRIC = prctile(meanRIC,30,2);

% %%remove background transients from signal
top = dFoF(1:20,:,:); %picks area at top of image
top = squeeze(mean(mean(top),2));
mid = dFoF(60:80,:,:);
mid = squeeze(mean(mean(mid),2));
diff = double(top - mid);
diff(diff < 0) = 0;
[pks,locs,w]=findpeaks(diff,'MinPeakHeight',0.02,'WidthReference','halfprom','MinPeakWidth',7,'Annotate','extents');


flash = zeros(size(top));
for i=1:size(w,1)
    ww = floor(w(i));
    wloc = locs(i);
    left = wloc-ww-2;
    right = wloc+ww+2;
    if left < 1
        left = 1;
    end
    if right > t
        right = t;
    end
    flash(left:right) = 1;
end

[m,n] = size(meanLIC(:,find(flash)));
percentLIC = repmat(percentLIC,1,n);
percentLIC = imnoise(percentLIC,'gaussian',0,.0001);
percentLIC = imgaussfilt(percentLIC);
meanLIC(:,find(flash)) = percentLIC;
[m,n] = size(meanRIC(:,find(flash)));
percentRIC = repmat(percentRIC,1,n);
percentRIC = imnoise(percentRIC,'gaussian',0,.0001);
percentRIC = imgaussfilt(percentRIC);
meanRIC(:,find(flash)) = percentRIC;

smLIC = double(imgaussfilt(meanLIC,3));
smRIC = double(imgaussfilt(meanRIC,3));

%%
%LIC & RIC
[peaksBinaryL] = getPeaks_dFoF(smLIC,0,0.005);
[peaksBinaryR] = getPeaks_dFoF(smRIC,1,0.005);

[peakStat, eventStats] = peakStats_dFoF(smLIC, peaksBinaryL, smRIC, peaksBinaryR);
plotTimeSeries_dFoF(smLIC, smRIC, peaksBinaryL, peaksBinaryR, peakStat);
 
dname = savedname;
savefile = '\ICmovs_peaks_dFoF_remflash.mat';
save([dname savefile],'smLIC','smRIC','peaksBinaryR','peaksBinaryL'); 
save([dname '\Fo.mat'],'X25');

%% Fav - Fo ./Fo
[LICmask, RICmask, ctxmask] = getROImasks(mean(bcImg,3));
LICsignal = dFoF.*LICmask;
LICsignal(LICsignal == 0) = NaN;
LICsignal = double(squeeze(mean(mean(LICsignal,2,'omitnan'),'omitnan')));

RICsignal = dFoF.*RICmask;
RICsignal(RICsignal == 0) = NaN;
RICsignal = double(squeeze(mean(mean(RICsignal,2,'omitnan'),'omitnan')));
  
ctxsignal = dFoF.*ctxmask;
ctxsignal(ctxsignal == 0) = NaN;
ctxsignal = double(squeeze(mean(mean(ctxsignal,2,'omitnan'),'omitnan')));

LICint = double(Fo).*LICmask;
LICint(LICint == 0) = NaN;
LICint = mean(mean(LICint,2,'omitnan'),'omitnan');
RICint = double(Fo).*RICmask;
RICint(RICint == 0) = NaN;
RICint = mean(mean(RICint,2,'omitnan'),'omitnan');
%%
[stats, pkData] = findICpeaksdFoF([LICsignal RICsignal ctxsignal],dname,'dFoF',1)
save([savedname '\dFoFvars.mat'], 'LICint', 'RICint', 'Fo');