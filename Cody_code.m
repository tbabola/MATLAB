clear all;
[fn path] = uigetfile();
pathData = loadPathData([path fn]);
myelinPercent = calculatePaths(pathData)









