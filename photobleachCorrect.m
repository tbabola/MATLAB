Xavg = squeeze(mean(mean(X,2),1));
time = [0:.1:(size(Xavg)-1)/10]';
Xavg = Xavg(1000:end);
time = time(1000:end);

f = fit(time,Xavg,'exp1');
figure; plot(f,time,Xavg);

   