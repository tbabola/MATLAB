function [XR, shiftR] = regImages(X,imgT,shiftR)
% [XR,shiftR] = REGIMAGES(X,imgT)
%
% REGIMAGES uses dftregistration to calculate shifts and register images.

just_shift = false;
T = size(X,3);

if ~exist('imgT','var') | isempty(imgT), imgT = X(:,:,1); end
if exist('shiftR','var'), just_shift = true; else     shiftR = zeros(T,2); end

plt = 0;
XR = X;
%%
if ~just_shift
    imgTfft = fft2(imgT);
    shiftR = zeros(T,2);
    for i = 1:T
        img2 = X(:,:,i);
        [y1] = dftregistration((imgTfft),fft2((img2)),1);
        % alternative image registration code at bottom of file
        shiftR(i,:) = y1(1,[4 3]);
    end
     shiftR(abs(shiftR)<1) = 0; % ignore small shifts
end

for i = 1:T
    if any(shiftR(i,:))
        img2 = X(:,:,i);
        XR(:,:,i) = imtranslate(img2,shiftR(i,:),'FillValues',NaN);
    end
end
%%
muXR = nanmedian(XR,3);

r = nanmean(XR(:)) / nanmean(imgT(:));
% ii = isnan(muXR);
% muXR(ii) = imgT(ii)*r;

% muXR(isnan(muXR)) = imgT(isnan(muXR)); % workaround for missing pixels

for i = 1:T
    XRtemp = XR(:,:,i);
    [ii] = find(isnan(XRtemp));
%     XRtemp(ii) = muXR(ii);
    XRtemp(ii) = imgT(ii)*r;
    XR(:,:,i) = XRtemp;
end



if plt
%%
for i = 1:T
    subplot(2,1,1)
imagesc(X(:,:,i),[100 3000]); axis square
subplot(2,1,2)
imagesc(XR(:,:,i),[100 3000]); axis square; pause(.001)
end
end

% %%
% Xr = zeros(size(X));
% R_reg = [];
% shift_temp = zeros(T,2);
% [optimizer,metric] = imregconfig('monomodal');
% optimizer.MaximumIterations = 5; %100
% optimizer.GradientMagnitudeTolerance = 1e-4; %1e-4
% optimizer.MinimumStepLength = 1e-2; %1e-5
% optimizer.MaximumStepLength = .0625; %.0625
% optimizer.RelaxationFactor = 0.25; %0.5
% tic
% for j = 1:T
% % [Xr(:,:,j),R_reg{j}] = imregister(X(:,:,j),imgT,'translation',optimizer,metric);
% [R_reg] = imregtform(X(:,:,j),imgT,'translation',optimizer,metric);
% shift_temp(j,:) = R_reg.T(3,1:2);
% end
% toc
% %%
% shift_temp(abs(shift_temp)<1) = 0;
% shift_temp = round(shift_temp);
% Xr = regImages(X,imgT,shift_temp);