function X = load_tif(fname,classname)
info = imfinfo(fname);
T = length(info);
m = info(1).Height; n = info(1).Width;

if exist('classname','var')
X = zeros(m,n,T,classname);
else X = zeros(m,n,T);
end

for i = 1:T
X(:,:,i) = imread(fname,i);
end
