filename = 'C:\Users\Travis\Desktop\Experiment-336_ds.tif';

%base_img = loadTif(filename);
avg = squeeze(mean(mean(base_img,1),2));
time = [1:1:size(avg)]';
avg_reg = avg - msbackadj(time,avg);

bl_subt = zeros(size(base_img));
for i=1:size(base_img,3)
    bl_subt(:,:,i) = avg_reg(i);
end


%baseline correction
bl_img = int16(base_img) - int16(bl_subt);
fbar = mean(bl_img,3);

%create F image with moving average
window = 200;
% fbar = zeros(size(base_img));
% 
% for i=1:size(base_img,3)
%     if i <= window
%       fbar(:,:,i) = mean(bl_img(:,:,1:window),3);
%     else
%       fbar(:,:,i) = mean(bl_img(:,:,i-window:i),3); 
%     end
% end

dF = zeros(size(base_img));


