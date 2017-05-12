function [regMov] = registerMovie(movie)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[m,n,T] = size(movie);
dataType = whos('movie');
regMov = zeros(m,n,T,dataType.class);

[optimizer, metric] = imregconfig('monomodal');
optimizer.RelaxationFactor = 0.25;

fixed = movie(:,:,round(T/2));

parfor i=1:T
   moving = movie(:,:,i);
   regMov(:,:,i) = imregister(moving,fixed,'translation',optimizer,metric);
end

end




