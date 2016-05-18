filename = 'C:\Users\Travis\Desktop\Experiment-336_ds.tif';

base_img = loadTif(filename);

%create F image with moving average
window = 200;
fbar = zeros(size(base_img));

for i=1:size(base_img,3)
    if i <= window
      fbar(:,:,i) = mean(bl_img(:,:,1:window),3);
    else
      fbar(:,:,i) = mean(bl_img(:,:,i-window:i),3); 
    end
end

dF = zeros(size(base_img));
dF = base_img - fbar;
implay(dF);


