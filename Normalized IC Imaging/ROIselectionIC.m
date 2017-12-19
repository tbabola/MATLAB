function [LICmask, RICmask, ctxmask] = ROIselectionIC(X, dim)
    switch nargin
        case 1
            dim = [800 250];
    end
        
    Xmean = mean(X,3);
    [m,n] = size(Xmean);
    
    h = figure('Position',[250 250 dim]);
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
    
    ctxmask = zeros(m,n);
    ctxmask(1:20,:) = 1;
    
    %imagesc(ctxmask);
end