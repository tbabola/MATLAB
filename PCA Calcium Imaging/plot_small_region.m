function plot_small_region(t,F_rec,B_rec,F_rec2,imgs,m)
%%
mn = size(F_rec,2);
n = mn/m;
T = length(t);

wx = [-3:3]; wy = [-3:3];
% wx = -10:10; wy = -10:10;
% clf; imagesc(muX); axis image; axis off
img_mean = reshape(mean(F_rec2',2),m,n);
imagesc(img_mean,[0 max(img_mean(:))]); axis image

pp = round(ginput(1));
zz = zeros(m,n); zz(pp(:,2)+wy,pp(:,1)+wx) = 1; % imagesc(zz); pause
zz = reshape(zz,m*n,1);

subplot(2,1,1)
plot(t,imgs*zz,'k'); hold on
plot(t,(B_rec+F_rec)*zz,'r','linewidth',1)
plot(t,(B_rec)*zz,'k','linewidth',2); hold off

subplot(2,1,2)
plot(t([1 T]),[0 0],'k:'); hold on
plot(t,F_rec*zz./(B_rec*zz),'r')
plot(t,(imgs-B_rec)*zz./(B_rec*zz),'k')
plot(t,F_rec2*zz/max(max(F_rec2*zz))/2,'b'); hold off