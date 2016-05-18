coreDir = 'C:\Documents and Settings\CAP\My Documents\ExpData\';
capNames = {
'hwf-2006_06_16-CAP\CAP_analysis_p22_26';
'hwf-2006_06_16-CAP\CAP_analysis_p27_32';
};

N = length(capNames);

mn = zeros(N,1);
stdev = zeros(N,1);

startDir = pwd;

for n = 1:N
    [pathstr,name,ext] = fileparts([coreDir capNames{n}]);
    eval(['cd ''' pathstr '''']);
    eval(['x = ' name ';']);
    mn(n) = mean(x.ABRmag(:,3));
    stdev(n) = std(x.ABRmag(:,3));
end

eval(['cd ''' startDir '''']);