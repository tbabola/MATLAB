function [regMov] = registerMovie(movie)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[m,n,T] = size(movie);
dataType = whos('movie');
regMov = zeros(m,n,T,dataType.class);

Xreshape = reshape(movie,m*n,T)';
Fo = prctile(Xreshape,10,1);
percentImg = reshape(Fo',m,n);
avgImg = squeeze(mean(movie,3));
stdImg = squeeze(std(single(movie),0,3));
thrImg = avgImg + 10 * stdImg;
[optimizer, metric] = imregconfig('monomodal');

fixed = movie(:,:,round(T/2));
tic;
parfor i=1:T
    moving = movie(:,:,i);
    thrMoving = moving;
    thrMoving(moving > thrImg) = percentImg(moving > thrImg);
    tform = imregtform(thrMoving,fixed,'translation',optimizer,metric);
    regMov(:,:,i) = imwarp(moving,tform);
end
toc;
end

