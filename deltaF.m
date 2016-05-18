function [dF] = deltaF(base_img, window)
%create F image with moving average
    if ~exist('window','var')
        window = 200; 
    end
    
    filter = ones(1,1,window)/window;
    fbar = imfilter(base_img,filter);
    
    %correct for delay of convolution
    for i=1:window
        fbar(:,:,i) = fbar(:,:,window+1);
        fbar(:,:,size(base_img,3)-(i-1)) = fbar(:,:,size(base_img,3)-window);
    end
    
    dF = zeros(size(base_img));
    dF = int16(base_img) - int16(fbar);
    
end