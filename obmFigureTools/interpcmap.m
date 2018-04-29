function cmaptatxi = interpcmap(xlimits, xi, cmap)
% cmaptatxi = INTERPCMAP(xlimits, xi, cmap)
%
%   inputs
%       - xlimits: 2-element vector associated with colormap limits.
%       - xi: vector of length M.
%       - cmap: Nx3 array of numbers between 0-1 (RGB values).
%
%   outputs
%       - cmaptatxi: Mx3 array of the RGB values associated with xi.
%
% INTERPCMAP outputs the interpolated RGB colors of the
% colormap "cmap" onto "xi", where the lower and upper
% limits are given by "xlimits".
%
% Olavo Badaro Marques, 26/Apr/2018


% Take the number of colors in the colormap input
lencmap = size(cmap, 1);

% From xlimits, create a vector of x-values
% associated with the colormap
xevenly = linspace(xlimits(1), xlimits(2), lencmap);

% Interpolate the colormap onto xi
cmaptatxi = interp1(xevenly, cmap, xi);