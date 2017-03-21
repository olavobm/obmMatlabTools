function skill = skillpar(x, y)
% skill = SKILLPAR(x, y)
%
%   inputs:
%       - x: vector or matrix.
%       - y: array with same size as x.
%
%   outputs:
%       - skill: 
%
% Olavo Badaro Marques, 20/Mar/2017.


%%

varx = nanmean(x.^2, 2);
mse = nanmean((y - x).^2, 2);

skill = 100 .* (1 - (mse ./ varx));

