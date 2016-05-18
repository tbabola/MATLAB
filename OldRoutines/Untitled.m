x = unnamed;
length = size(x,1);
time=0:1:length-1;
time=time';
s=std2(x);

yout=msbackadj(time,x,'WINDOWSIZE',10,'STEPSIZE',10);
filt1=sgolayfilt(yout,1,5);

[pks,locs]=findpeaks(filt1(:,3),time,'MinPeakHeight',stdev,'MinPeakWidth',3);
% plot(filt1(:,1),'r','linewidth',1);
% hold on;
% plot(filt1(:,2),'b','linewidth',1);
% hold on;
% plot(filt1(:,3),'g','linewidth',1);
% hold on;
% plot(locs,pks);
figure(1);
plot(filt1(:,2));


figure(2);
total = cat(1,filt1(:,1), NaN(50,1), filt1(:,2), NaN(50,1), filt1(:,3)); 
totaltime = 1:1:size(total,1);
plot(totaltime,total);
% Noisy ECG signal

% plot(x); title('Original ECG Waveform');
% figure;
% Filt1 = sgolayfilt(x,1,5);
% Filt10 = sgolayfilt(x,3,5);
% plot(Filt10,'r');
% hold on;
% plot(Filt1,'b','linewidth',2);
% legend('Order 10','1st Order');