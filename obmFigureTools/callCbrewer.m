function [cmap] = callCbrewer(n, haxs)
% [cmap] = CALLCBREWER(n, haxs)
%
%   inputs
%       - n: number of colors (later change this function such that
%            the number of colors is equal to a user specified resolution
%            and data range).
%       - haxs (optional):
%
%   outputs
%       - cmap:
%
% CALLCBREWER.m creates a colormap with the brewermap function
% (https://github.com/DrosteEffect/BrewerMap). The standard color scheme
% is the divergent red/blue.
% The color schemes provided by BrewerMap are gorgeous.
% 
% Olavo Badaro Marques, 07/Dec/2017.


%%

if ~exist('haxs', 'var')
    haxs = gcf;
end


%%
% Define color scheme:
colorscheme = '*RdBu';     % * reverses colormap (red for higher values)

% Creates the colormap:
cmap = brewermap(n, colorscheme);

% Only update the colormap if the output was NOT specified.
% Otherwise just return the output:
if nargout == 0
    for i = 1:length(haxs)
        colormap(haxs(i), cmap)
    end
end