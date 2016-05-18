
function b = makeband(sr,lc,uc,type)

%function will generate a octave-spaced notch in broadband noise using
%       MATLAB FIRCLS function
%
%CALL AS:   makeband(sr,cf,oct)
%INPUTS:    sr = TDT sampling rate
%           lc - lower cutoff
%           uc - upper cutoff
%           type - 'reject' or 'pass' band
%
%RETURNS:   b - FIR coefficients

nyquist = floor(sr/2);

edge(1) = 0;
edge(2) = min(lc/nyquist,.9);
edge(3) = min(uc/nyquist,.95);
edge(4) = 1;

switch type
    case 'reject'
        a = [1 0 1];
        up = [1.02 0.02 1.02];
        lo = [0.098 -0.02 0.98];
    case 'pass'
        a = [0 1 0];
        up = [0.02 1.02 0.02];
        lo = [-0.02 0.98 -0.02];
end

b = fircls(700,edge,a,up,lo);
% add a 0 at the end to make the coef even
b = [b 0];
%b = firls(699, [edge(1:2) edge(2)+0.001 edge(3)-0.001 edge(3:4)], [1 1 0 0 1 1],'h');
% shuffle coef to optimize performance of FIR2
b = reshape( [b(1:length(b)/2); b(length(b)/2+1:end)], 1, length(b) );
return

% end of makeband
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



