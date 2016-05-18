function [dF,dFoF] = deltaFoverF(base_img, window)
%create F image with moving average
    if ~exist('window','var')
        window = 200; 
    end
    
    filter = ones(1,1,window)/window;
    %filter = ones(1,1,2*window)/(window);
    %filter(1,1,(window+1):(2*window))= 0;
    fbar = imfilter(base_img,filter);
    
    %correct for delay of convolution
    for i=1:window
        fbar(:,:,i) = fbar(:,:,window+1);
        fbar(:,:,size(base_img,3)-(i-1)) = fbar(:,:,size(base_img,3)-window);
    end
    
    dF = zeros(size(base_img));
    dF = int16(base_img) - int16(fbar);
    
    dFoF = zeros(size(base_img));
    for i=1:size(base_img,3)
        dFoF(:,:,i) = single(dF(:,:,i))./single(fbar(:,:,i));
    end
end