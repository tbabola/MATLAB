function [d_int,time_int] = integrateISCs(d,time)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
   d_int = cumtrapz(time,d);
   d_int = d_int(~mod(time,1));
   d_int = d_int*-1;
   time_int = time(~mod(time,1));
   plot(time_int,d_int);
end