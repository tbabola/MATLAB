
[optimizer, metric] = imregconfig('multimodal');

tic;
parfor i=1:size(img,3)
    reg(:,:,i) = imregister(img(:,:,i),img(:,:,1),'translation',optimizer,metric);
  
        disp(num2str(i));
    
end
toc;

implay(reg);
