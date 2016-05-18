function altFiltImg = ImgFilter(img)
    sizeX=size(img,2);
    sizeY=size(img,1);
    sizeZ=size(img,3);
    filtImg = img;
    
    for z = 1:sizeZ
         pxArray = zeros(sizeY,sizeX,5);
        if z == 1
            pxArray(:,:,3:5) = img(:,:,1:3);    
        elseif z == 2
            pxArray(:,:,2:5) = img(:,:,1:4);
        elseif z == sizeZ-1
            pxArray(:,:,1:4) = img(:,:,z-2:z+1);
        elseif z == sizeZ
            pxArray(:,:,1:3) = img(:,:,z-2:z);
        else
            pxArray(:,:,1:5) = img(:,:,z-2:z+2);
        end
        
        %convulution pattern
        b = [1];
        b = repmat(b,1,1,3);
        target = 765;
        conpattern = convn(pxArray,b,'same');
        maxConP = max(conpattern,[],3);
        c = (maxConP == target);
        filtImg(:,:,z) = img(:,:,z).*c;
    end
    
    altconvImg = altconv(img);
    disp(isequal(filtImg,altconvImg));
    
    imgConv = convn(filtImg,[1 1 1;1 0 1;1 1 1],'same');
    d = (imgConv ~= 0);
    filtImg = filtImg.*d;

end

function altconvImg = altconv(img)
    b = [1];
    b = repmat(b,1,1,3);
    conp = convn(img,b,'same');
    b(:,:,2)=0;
    conp2 = convn(img,b,'same');
    altconImg = (conp2 >= 3).*img;
end