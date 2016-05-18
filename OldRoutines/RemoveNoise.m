function y = RemoveNoise(~)
fname = 'C:\Users\Travis\Desktop\test.tif';
info = imfinfo(fname);
imageStack = [];
numberOfImages = length(info);

% 
for k = 1:numberOfImages
    currentImage = imread(fname, k, 'Info', info);
    imageStack(:,:,k) = currentImage;
end 

revImageStack = imageStack; %revised image stack
sizeX=size(imageStack,2);
sizeY=size(imageStack,1);
sizeZ=size(imageStack,3);



%for pixel dwell being 2 seconds
% for z = 1:sizez
%     for x = 1:sizex
%         for y = 1:sizey
%             pxValue = imageStack(y,x,z);
%             %set previous and next pixel values
%             if z==1
%                 prevPxValue = 0;
%                 nextPxValue = imageStack(y,x,z+1);
%             elseif z ==sizez
%                 prevPxValue = imageStack(y,x,z-1);
%                 nextPxValue = 0;
%             else
%                 prevPxValue = imageStack(y,x,z-1);
%                 nextPxValue = imageStack(y,x,z+1);
%             end
%             
%             %revalue, if target pixel is 255 and surrounded by zeros,
%             %change to zero
%             if (pxValue == 255) && (prevPxValue == 0) && (nextPxValue == 0)
%                 revImageStack(y,x,z) = 0;
%             end
%         end
%     end
% end
%test = imageStack([1 2],[3 4],1);
%for pixel dwell being 3 seconds
for z = 1:sizeZ
    for x = 1:sizeX
        for y = 1:sizeY
            pxValue = imageStack(y,x,z);
            %set previous and next pixel values
            if z==1
                prev2PxValue = 0;
                prevPxValue = 0;
                nextPxValue = imageStack(y,x,z+1);
                next2PxValue = imageStack(y,x,z+2);
            elseif z == 2
                prev2PxValue = 0;
                prevPxValue = imageStack(y,x,z-1);;
                nextPxValue = imageStack(y,x,z+1);
                next2PxValue = imageStack(y,x,z+2);
            elseif z == sizeZ-1
                prev2PxValue = imageStack(y,x,z-2);
                prevPxValue = imageStack(y,x,z-1);
                nextPxValue = imageStack(y,x,z+1);
                next2PxValue = 0;
            elseif z == sizeZ
                prev2PxValue = imageStack(y,x,z-2);
                prevPxValue = imageStack(y,x,z-1);
                nextPxValue = 0;
                next2PxValue = 0;
            else
                prev2PxValue = imageStack(y,x,z-2);
                prevPxValue = imageStack(y,x,z-1);
                nextPxValue = imageStack(y,x,z+1);
                next2PxValue = imageStack(y,x,z+2);
            end
            
            %revalue, if target pixel is 255 and surrounded by zeros,
            %change to zero
            if (pxValue == 255) && (prevPxValue == 255) && (nextPxValue == 255);
            elseif (pxValue == 255) && (prevPxValue == 255) && (prev2PxValue == 255);
            elseif (pxValue == 255) && (nextPxValue == 255) && (next2PxValue == 255);
            else
                revImageStack(y,x,z) = 0;
            end
        end
    end
end

for z = 1:sizeZ
    imgConv = conv2(revImageStack(:,:,z),[1 1 1;1 0 1;1 1 1],'same');
    for x = 1:sizeX
        for y = 1:sizeY
            if imgConv(y,x) == 0;
                revImageStack(y,x,z) = 0;
            end
        end
    end
end

outputFileName = 'C:\Users\Travis\My Documents\revTest8.tif';
for k = 1:length(revImageStack(1, 1, :))
    imwrite(revImageStack(:, :, k), outputFileName, 'WriteMode', 'append',  'Compression','none');
end
end

function adj(img,x,y,z)
    sizeX = size(img, 2);
    sizeY = size(img, 1);
    sizeZ = size(img, 3);
  
    
end
