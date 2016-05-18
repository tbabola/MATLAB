function [miniburst_thr, burst_thr] = SGNgaussianfit(ISIs)
%UNTITLED2 Summary of this function goes here
%   This functions fits 3 guassians to the ISI data and returns the
%   threshold points for mini-burst and burst ISIs

    %data needs to be taken out of log scale to compute guassian
    ISIs_log = log10(ISIs);
    GMModel = fitgmdist(ISIs_log,3,'Options',statset('MaxIter',1500));

    xs = [0:0.00001:5];
    xs_up10 = 10.^xs;

    %order components
    mu = GMModel.mu;
    sigma = squeeze(GMModel.Sigma);
    sort_mu = sort(mu);
    low = find(mu == sort_mu(1));
    mid = find(mu == sort_mu(2));
    high = find(mu == sort_mu(3));
    
    %extract and model the three individual Gaussians
    c1 = GMModel.ComponentProportion(low)*normpdf(xs,GMModel.mu(low),sqrt(sigma(low)));
    c2 = GMModel.ComponentProportion(mid)*normpdf(xs,GMModel.mu(mid),sqrt(sigma(mid)));
    c3 = GMModel.ComponentProportion(high)*normpdf(xs,GMModel.mu(high),sqrt(sigma(high)));
    c_tot = (c1+c2+c3);
    
    %find miniburst threshold; minimum between c1 and c2
    zero_xing = sign(diff(c_tot));
    i = 1;
    while zero_xing(i) == 1
        zero_xing(i) = -1; % looking for second crossing
        i = i + 1;
    end
    min_index = find(zero_xing == 1,1);
    miniburst_thr = xs_up10(min_index);
    
    %find burst threshold;
    zero_xing2 = sign(c3-c2);
    min_index2 = find(zero_xing2 == 1,1);
    burst_thr = xs_up10(min_index2);
    

end

