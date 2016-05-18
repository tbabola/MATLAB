function Y = normmat(X)
% Y = normmat(X)
%
% normalize to a minimum of 0 and a maxium of 1

Y = (X-min(X(:))) / (max(X(:))-min(X(:)));
