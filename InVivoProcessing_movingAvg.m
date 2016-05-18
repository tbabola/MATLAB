%input should be bleach corrected in imagej first
% filename = 'C:\Users\Travis\Desktop\DUP_Experiment-352.tif';
% [filepath,name,ext] = fileparts(filename); 
% filepathPro = [filepath,'\',name,'_processed\'];
% if ~exist(filepathPro,'dir')
%     mkdir(filepath,[name,'_processed'])
% end
% base_img = loadTif(filename,16);
% 
% gauss = imgaussfilt3(base_img,2);
[dF,dFoF] = deltaFoverF(gauss);
writeTif(dF,[filepathPro,name,'_df',ext],16);
writeTif(single(dFoF(:,:,1:3000)),[filepathPro,name,'_dfof',ext],32);
writeTif(single(dFoF(:,:,3001:size(dFoF,3))),[filepathPro,name,'_dfof2',ext],32);




