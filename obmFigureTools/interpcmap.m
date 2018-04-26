function cmaptatxi = interpcmap(xlimits, xi, cmap)
% cmaptatxi = INTERPCMAP(xlimits, xi, cmap)
%
%   inputs
%       - xlimits:
%       - xi:
%       - cmap:
%
%   outputs
%       - cmaptatxi
%
%
%
%
%
% Olavo Badaro Marques, 26/Apr/2018


%
lencmap = size(cmap, 1);

%
xevenly = linspace(xlimits(1), xlimits(2), lencmap);

%
cmaptatxi = interp1(xevenly, cmap, xi);