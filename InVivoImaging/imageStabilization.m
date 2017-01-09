cd 'C:\Users\Bergles Lab\Desktop'
[fn, path] = uigetfile();
test = loadTif([path fn],8);
test = test(:,:,1:500);

%preallocation
regTest = zeros(size(test));
regTest(:,:,1) = test(:,:,1);

optimizer = registration.optimizer.RegularStepGradientDescent; % here you can modify the default properties of the optimizer to suit your need/to adjust the parameters of registration.

[optimizer, metric]  = imregconfig('monomodal'); % for optical microscopy you need the 'monomodal' configuration.
tic;
parfor p = 2:size(regTest,3)

   moving = test(:,:,p); % the image you want to register
   fixed = test(:,:,p-1); % the image you are registering with

   %movingONE = rgb2gray(moving(:,:,:)); % imregtform needs grayscale images
   %fixedONE = rgb2gray(fixed(:,:,:));

   tform = imregtform(moving,fixed,'similarity',optimizer,metric,'DisplayOptimization',false);                   
   tform = affine2d(tform.T);

   regTest(:,:,p) = imwarp(moving,tform,'OutputView',imref2d(size(fixed))); % 

   if mod(p,20)==0
       p
   end
   
end
toc;