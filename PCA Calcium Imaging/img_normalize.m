function [Xn,Xnormalizer] = img_normalize(X,plt_flag)
if ~exist('plt_flag','var')
    plt_flag = false;
end
T = size(X,3);
muX = mean(X,3);
th = 10;
muX(muX<th) = th;
muXs = smooth2(muX,31,'g',11);
Xnormalizer = normmat(muXs)*1.5+1;
Xn = X./repmat(Xnormalizer,[1 1 T]);
muXn = nanmean(Xn,3);
if plt_flag
subplot(3,1,1); imagesc(mean(X,3)); axis image; title('raw')
subplot(3,1,2); imagesc(muXs); axis image; title('lowpass mask')
subplot(3,1,3); imagesc(muXn); axis image; title('normalized image')
end