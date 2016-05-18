%guassianblur test

%input should be bleach corrected in imagej first
filename = 'C:\Users\Travis\Desktop\DUP_Experiment-342.tif';
[filepath,name,ext] = fileparts(filename);
filepathPro = [filepath,'\',name,'_processed\'];
if ~exist(filepathPro,'dir')
    mkdir(filepath,[name,'_processed'])
end
%base_img = loadTif(filename,16);

blurSigma = [2,3,4,5];

for i=1:size(blurSigma,2)
    gauss = imgaussfilt3(base_img,blurSigma(i));
    dF = deltaF(gauss);
    writeTif(int16(dF),[filepathPro,name,'_',num2str(blurSigma(i)),'gauss',ext],16);
end

