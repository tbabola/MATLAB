%%Compare IC activity to SC activity (integral)
% 
%[fn dname] = uigetfile();
%[pathstr, name, ext] = fileparts([dname fn]);

switch ext
    case '.czi'
        bf = bfopen([dname fn]);
        tic;
        [m,n] = size(bf{1}{1});
        t = size(bf{1},1);
        img = zeros(m,n,t);
        for i=1:t
            img(:,:,i) = bf{1}{i};
        end
        clear bf;
        img = flipud(img);
        toc;
    case '.tif'
        img = loadTif([dname fn],16);
end

disp('Normalizing movie');
 [dFoF, Fo] = normalizeImg(img,10);

[LICmask, RICmask, LSCmask, RSCmask, ctxmask] = ROIselectionICSC(img);
disp('Masks created. Normalizing image.');


LIC = dFoF.*LICmask;
LIC(LIC==0)=NaN;
LIC = squeeze(mean(mean(LIC,2,'omitnan'),'omitnan'));

RIC = dFoF.*RICmask;
RIC(RIC==0)=NaN;
RIC = squeeze(mean(mean(RIC,2,'omitnan'),'omitnan'));

LSC = dFoF.*LSCmask;
LSC(LSC==0)=NaN;
LSC = squeeze(mean(mean(LSC,2,'omitnan'),'omitnan'));

RSC = dFoF.*LSCmask;
RSC(RSC==0)=NaN;
RSC = squeeze(mean(mean(RSC,2,'omitnan'),'omitnan'));






function [LICmask, RICmask, LSCmask, RSCmask, ctxmask] = ROIselectionICSC(X)
    Xmean = mean(X,3);
    [m,n] = size(Xmean);
    
    h = figure('Position',[250 250 n*1.25 m*1.25]);
    %h.Position([50 50 800 600]);
    h_im = imagesc(Xmean);
     
    LIC = imellipse(gca,[60,35,175,100]);
    setResizable(LIC,0);
    wait(LIC);
    LICmask = createMask(LIC, h_im);
    
    RIC = imellipse(gca,[300,35,175,100]);
    setResizable(RIC,0);
    wait(RIC);
    RICmask = createMask(RIC, h_im);
    
    LSCmask = roipoly();
    
    RSCmask = roipoly();
    
    ctxmask = zeros(m,n);
    ctxmask(1:20,:) = 1;
end


