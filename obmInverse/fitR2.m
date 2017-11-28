function fitR2 = fitR2(x, y)
% fitR2 = fitR2(x, y)
%
%   inputs
%       - x: vector or matrix.
%       - y: array with same size as x.
%
%   outputs
%       - fitR2: 
%
% Olavo Badaro Marques, 20/Mar/2017.


%%

xc = size(x, 2);

SStot = nansum((x - repmat(nanmean(x, 2), 1, xc)).^2, 2);
SSres = nansum((y - x).^2, 2);


%%

fitR2 = (1 - (SSres ./ SStot));
