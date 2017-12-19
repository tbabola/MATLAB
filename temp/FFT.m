carrier = 2;
Fs = 40000;
t = (1:1:Fs*5)/Fs;
signal = 100*cos(carrier*t)

figure;
plot(t,signal)