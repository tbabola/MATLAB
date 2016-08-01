function Crenations_2()
    disp('Crenations');
    [fn dname] = uigetfile();
    mkdir(dname,'figProcessed');

    %load image from file
    loadedImg = loadImg([dname,fn]);
    disp('Loaded');

    %do image subtraction
    subtImg = subt(loadedImg);
    clearvars 'loadedImg'; %housekeeping, for memory
    disp('Subtract');

    %threshold image
    thrImg = thr(subtImg);
    disp('Threshold');
    %outputFileName = char(strcat(direct,'Processed\',fname,'_thr.',ext));
    %writeImg(thrImg, outputFileName);
    clearvars 'subtImg'; %housekeeping, for memory

    %filter images
    %alt2FiltImg = alt2Filt(thrImg);
    alt2FiltImg = alt3Filt(thrImg);
    %filtImg = filt(thrImg);
    outputFileName = char(strcat(dname,'figProcessed\','filt_',fn));
    writeImg(alt2FiltImg, outputFileName);
    intens = zeros(600,1); %holds intensity data

    sq = squeeze(mean(mean(alt2FiltImg,1)));
    intens(1:size(sq,1),1) = sq;
    assignin('base','intens_tot',intens);
        
    
    intens(intens == 0) = NaN; 
    save('rawIntensities.mat','intens');
    time = zeros(1,size(intens(:),1));
    time = (1:1:size(intens(:),1));
    time = reshape(time,[size(intens,1),size(intens,2)]);
    blSubt = blSubtract(time, intens);
    save('blIntensities.mat','blSubt');
    plot(time,blSubt);
    savefig('Crenations.fig');
    
end

function files = getFiles(ndir)
    cd(ndir);
    files = dir('*.tif'); 
end

function loadedImg = loadImg(fname)
    infoImage=imfinfo(fname);
    mImage=infoImage(1).Width;
    nImage=infoImage(1).Height;
    numberImages=length(infoImage);
    loadedImg=zeros(nImage,mImage,numberImages,'uint8');
    t = Tiff(fname,'r');
    
    for i=1:numberImages
         t.setDirectory(i);
         loadedImg(:,:,i) = t.read();
    end
    
    t.close();
end

function subtImg = subt(img)
    sizeZ = size(img,3);
	offset = 5;
	s0 = 1;
	e0 = sizeZ - offset;
	s1 = s0 + offset;
	e1 = e0 + offset;
	
    subtImg = img(:,:,s1:e1) - img(:,:,s0:e0);
end

function thrImg = thr(img)
    stdThr = 4;
    imgMean = mean(img(:));
    imgStd = std(double(img(:)));
    
    thrImg = img;
    thrImg(img > (imgMean - stdThr*imgStd)) = 0;
    thrImg(img <= (imgMean - stdThr*imgStd)) = 255;
    
    thrImg(img >= (imgMean + stdThr*imgStd)) = 255;
    thrImg(img < (imgMean + stdThr*imgStd)) = 0;
end

function alt3FiltImg = alt3Filt(img)
    z = size(img,3);
    %convulution pattern
    b = [1];
    b = repmat(b,1,1,3);
    img(img ~= 0) = 1;
    c = convn(img,b,'same');
    clearvars 'img'; %housekeeping, for memory
    
     c(c < 3) = 0;
     result = c;
     clearvars 'c'; %housekeeping, for memory
     result(:,:,1:z-1)=result(:,:,1:z-1)+result(:,:,2:z);
     result(:,:,2:z)=result(:,:,1:z-1)+result(:,:,2:z);
     result(result ~= 0) = 1;
     
     alt3FiltImg = 255*uint8(result);
     for ii=1:size(alt3FiltImg,3);
        alt3FiltImg(:,:,ii) = medfilt2(alt3FiltImg(:,:,ii),[3 3]);
     end
     
     
     %for ii=1:size(alt3FiltImg,3);
     %   alt3FiltImg(:,:,ii) = bwareaopen(alt3FiltImg(:,:,ii),25);
     %end
    
     %alt3FiltImg = alt3FiltImg*255;
end

function alt2FiltImg = alt2Filt(img)
    z = size(img,3);
    %convulution pattern
    b = [1];
    b = repmat(b,1,1,3);
    img(img ~= 0) = 1;
    c = convn(img,b,'same');
    clearvars 'img'; %housekeeping, for memory
    
     c(c < 3) = 0;
     result = c;
     clearvars 'c'; %housekeeping, for memory
     result(:,:,1:z-1)=result(:,:,1:z-1)+result(:,:,2:z);
     result(:,:,2:z)=result(:,:,1:z-1)+result(:,:,2:z);
     result(result ~= 0) = 1;
     
     alt2FiltImg = 255*uint8(result);

     imgConv = convn(alt2FiltImg,[1 1 1;1 0 1;1 1 1],'same');
     d = (imgConv ~=0);
     alt2FiltImg = alt2FiltImg.*uint8(d);
end



function altFiltImg = altFilt(img)
    sizeX=size(img,2);
    sizeY=size(img,1);
    sizeZ=size(img,3);
    
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
        altFiltImg(:,:,z) = img(:,:,z).*uint8(c);
    end

     imgConv = convn(altFiltImg,[1 1 1;1 0 1;1 1 1],'same');
     d = (imgConv ~= 0);
     altFiltImg = altFiltImg.*uint8(d);
end

function filtImg = filt(img)
    sizeX=size(img,2);
    sizeY=size(img,1);
    sizeZ=size(img,3);
    
    for z = 1:sizeZ
    for x = 1:sizeX
        for y = 1:sizeY
            pxArray = zeros(1,5);
            pxArray(1,3)=img(y,x,z);
            %set previous and next pixel values
            if z==1
                pxArray(1,4) = img(y,x,z+1);
                pxArray(1,5) = img(y,x,z+2);
            elseif z == 2
                prev2PxValue = 0;
                pxArray(1,2) = img(y,x,z-1);
                pxArray(1,4) = img(y,x,z+1);
                pxArray(1,5) = img(y,x,z+2);
            elseif z == sizeZ-1
                pxArray(1,1) = img(y,x,z-2);
                pxArray(1,2) = img(y,x,z-1);
                pxArray(1,4) = img(y,x,z+1);
            elseif z == sizeZ
                pxArray(1,1) = img(y,x,z-2);
                pxArray(1,2) = img(y,x,z-1);
            else
                pxArray(1,1) = img(y,x,z-2);
                pxArray(1,2) = img(y,x,z-1);
                pxArray(1,4) = img(y,x,z+1);
                pxArray(1,5) = img(y,x,z+2);
            end
            
            %convulution pattern
            b = [1 1 1];
            target = 765;
            conPattern = ismember(target, conv(pxArray,b,'same'));
            %revalue, if target pixel is 255 and surrounded by zeros,
            %change to zero
            if ~any(conPattern)
                img(y,x,z) = 0;
            end
        end
    end
end

for z = 1:sizeZ
    imgConv = conv2(img(:,:,z),[1 1 1;1 0 1;1 1 1],'same');
    for x = 1:sizeX
        for y = 1:sizeY
            if imgConv(y,x) == 0;
               img(y,x,z) = 0;
            end
        end
    end
end

filtImg = img;

end

function writeImg(img, fname)
    t = Tiff(fname,'w');
    numImages = size(img,3);
    
    %intial directory
    tagstruct.ImageLength = size(img,1);
    tagstruct.ImageWidth = size(img,2);
    tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
    tagstruct.BitsPerSample = 8;
    tagstruct.SamplesPerPixel = 1;
    tagstruct.RowsPerStrip = size(img,1);
    tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
    tagstruct.Software = 'MATLAB';
    tagstruct.Compression = 1;
    t.setTag(tagstruct)
    
    for i = 1:numImages
        t.setTag(tagstruct);
        t.write(img(:,:,i));
        t.writeDirectory();
    end
    
    t.close();
end

function blSubt = blSubtract(time, signal)
%blSubtract This fxn subtracts out the baseline using msbackadj

blSubt=msbackadj(time,signal,'WINDOWSIZE',50,'STEPSIZE',50);

end