%%Compare IC activity to SC activity (integral)
%%
[fn dname] = uigetfile();
[pathstr, name, ext] = fileparts([dname fn]);
switch ext
    case '.czi'
        bf = bfopen([dname fn]);
        tic;
        [m,n] = size(bf{1}{1});
        t = size(bf{1},1);
        img = zeros(m,n,t,'int16');
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
disp('Masks created.');


%This is much faster than multiplying dFoF by ROImasks due to memory
%constraints
LIC = [];
RIC = [];
LSC = [];
RSC = [];
ctx = [];
rctx = [];
lctx = [];

[m,n] = size(dFoF(:,:,1));
ctxsidemask = logical(zeros(m,n));
ctxsidemask(:,1:round(n/2)) = 1;

for i=1:size(dFoF,3)
    singimg = dFoF(:,:,i);
    LICind = find(LICmask);
    LIC(i) = mean(singimg(LICind));
    
    RICind = find(RICmask);
    RIC(i) = mean(singimg(RICind));
    
    RSCind = find(RSCmask);
    RSC(i) = mean(singimg(RSCind));
    
    LSCind = find(LSCmask);
    LSC(i) = mean(singimg(LSCind));
    
    ctxind = find(ctxmask);
    ctx(i) = mean(singimg(ctxind));
    
    rctxind = find(ctxmask .* ctxsidemask);
    rctx(i) = mean(singimg(rctxind));
    
    lctxind = find(ctxmask .* fliplr(ctxsidemask));
    lctx(i) = mean(singimg(lctxind));
    
end

LIC = LIC';
RIC = RIC';
LSC = LSC';
RSC = RSC';
ctx = ctx';
rctx = rctx';
lctx = lctx';

[stats, pkData] = findICpeaksdFoF(double([LIC RIC ctx]), dname , 'activitycorr', 1);

time = [1:1:size(LIC,1)];
time = (time/10)';
LSC_bl = msbackadj(time,LSC);
RSC_bl = msbackadj(time,RSC);
LIC_bl = msbackadj(time,LIC);
RIC_bl = msbackadj(time,RIC);
ctx_bl = msbackadj(time,ctx);
rctx_bl = msbackadj(time,rctx);
lctx_bl = msbackadj(time,lctx);

disp('Ctx Integral')     
ctx_int = trapz(ctx_bl)
rctx_int = trapz(rctx_bl)
lctx_int = trapz(lctx_bl)
LIC_int = trapz(LIC_bl)
RIC_int = trapz(RIC_bl)
RSC_int = trapz(RSC_bl)
LSC_int = trapz(LSC_bl)
ICfreq = stats{1,7};

stats(1,7)
tbl_stats = table(ctx_int, lctx_int, rctx_int, LIC_int, RIC_int, RSC_int, LSC_int, ICfreq);
[fn, dname] = uigetfile('M:\Bergles Lab Data\Projects\In vivo imaging\');
save([dname 'integrals.mat'],'tbl_stats','ctx','RIC','LIC','LSC','RSC','lctx','rctx');

figure;
subplot(3,1,1);
plot(LIC);
hold on;
plot(RIC);
subplot(3,1,2);
plot(LSC);
hold on;
plot(RSC);
subplot(3,1,3);
plot(ctx);
hold on;
plot(rctx+0.5);
plot(lctx+0.5);

groupWT = [groupWT; trapz(ctx_bl) trapz(LIC_bl) trapz(RIC_bl) trapz(RSC_bl) trapz(LSC_bl) trapz(stats{1,7})];


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
    
    ctxmask = roipoly();
end


