function [fftout, f] = rfft(Y,fs)
    length = size(Y,1);
    %win = hann(length);
    %dataWin = Y .* win;
    data_fft = fft(Y);
    P2 = abs(data_fft/length);
    P1d = P2(1:length/2+1);
    P1d(2:end-1) = 2*P1d(2:end-1);
    fftout = P1d;
    f = fs*(0:(length/2))/length;
end
