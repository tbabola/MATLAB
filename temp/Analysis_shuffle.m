%input = WT_NBQX_170910_Image19(1:500,:);
input = VG3KO_170914_Image15(1:420,:);
[t,n] = size(input);

Vt_WT = mean(input,2);

%shuffle data;
R = randi(t,n,1);
input_shuf = zeros(t,n);
for i = 1:n
    input_shuf(:,i) = [input(R(i):end,i); input(1:R(i)-1,i)];   
end
Vt_WTshuf = mean(input_shuf,2);

time = [1:t]';
sig = trapz(time,Vt_WT.^2)/time(end) - (trapz(time,Vt_WT)/time(end)).^2;
sigSing = trapz(time,input.^2)/time(end) - (trapz(time,input)/time(end)).^2;
sigSing = mean(sigSing);
chi2 = sig/sigSing;
chi = sqrt(chi2)

sigShuf = trapz(time,Vt_WTshuf.^2)/time(end) - (trapz(time,Vt_WTshuf)/time(end)).^2;
sigSingShuf = trapz(time,input_shuf.^2)/time(end) - (trapz(time,input_shuf)/time(end)).^2;
sigSingShuf = mean(sigSingShuf);
chi2shuf = sigShuf/sigSingShuf;
chiShuf = sqrt(chi2shuf)

figure; plot(Vt_WT);


