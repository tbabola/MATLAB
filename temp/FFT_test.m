carrier = 5;
Fs = 40000;
T = 1/Fs
L = Fs * 5; % 5 seconds
t = (1:1:L)*T;
mphoneSens = .1; %V/Pa
signal = .1*cos(2*pi*carrier*t);
signal(end-Fs:end) = 0;
dBgain = 30;

signalAmp = signal*10^(dBgain/20);
figure;
plot(t,signal)
hold on;
plot(t,signalAmp);

%% FFT

Y = fft(signalAmp);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
figure;
plot(f,P1)
hold on;
plot(f,20*log10((P1/10^(dBgain/20))/mphoneSens/2e-5))

%% chirp signal

Fs = 40000;
T = 1/Fs
L = Fs * 10; % 5 seconds
t = (1:1:L)*T;
signal = .1*chirp(t,100,10,10000);
% signal = .1*cos(2*pi*carrier*t);
% signal(1:4*Fs) = 0;
% signal(end-4*Fs:end) = 0;
% mphoneSens = .1; %V/Pa

dBgain = 30;



figure; plot(signal);
signalAmp = signal*10^(dBgain/20);
mphoneSens = .1; %V/Pa
signalAmp = signalAmp(1000:4000);
L = size(signalAmp,2);
Y = fft(signalAmp);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
figure;
plot(f,P1)
hold on;
plot(f,20*log10((P1/10^(dBgain/20))/mphoneSens/2e-5))





