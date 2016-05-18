function [d , time] = loadPclampData(datafile)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [d,si,h]=abfload(datafile);
    samplingRateus = si;
    samplingRateHz = 1/(samplingRateus*10^-6);
    time = (0:1:h.dataPts-1);
    time = time*samplingRateus*10^-6;
    time = time';
    assignin('base','d',d);
    assignin('base','time',time);
end

