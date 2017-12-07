function [cmap] = callCbrewer(colorscheme, haxs, n)
% [cmap] = CALLCBREWER(clrschm, haxs, n)
%
%   inputs
%       - colorscheme: string
%       - haxs:
%       - n: number of colors (later change this function such that
%            the number of colors is equal to a user specified resolution
%            and data range).
%
%   outputs
%       - cmap:
%
% CALLCBREWER.m creates a colormap with the brewermap function
% (https://github.com/DrosteEffect/BrewerMap).
%
% The default color scheme is the divergent red/blue.
% The color schemes provided by brewermap are gorgeous.
% 
% Olavo Badaro Marques, 07/Dec/2017.


%%

listEZColorSchemes = {'divRB', 'seqOR', ...
                      'YlGnBu', 'Blues'};

listCBColorSchemes = {'*RdBu', 'OrRd', ...
                      'YlGnBu', 'Blues'};


%% Map color schemes

mapColors = containers.Map(listEZColorSchemes, listCBColorSchemes);


%%

if nargin==1 && strcmp(colorscheme, 'options')
    
    sprintf('Optional schemes with easy names are: \n')
    disp(listEZColorSchemes)
    return
end


%%

if ~exist('colorscheme', 'var') || isempty(colorscheme)
    colorscheme = '*RdBu';    % * reverses colormap (red for higher values)
else
    if any(strcmp(listEZColorSchemes, colorscheme))
        colorscheme = mapColors(colorscheme);
    else
        % in this case, colorscheme must be a valid color
        % scheme code that is accepted by brewermap
    end
end


%%

if ~exist('haxs', 'var')
    haxs = gcf;
end

if ~exist('n', 'var')
    n = 64;
end


%% Creates the colormap:

cmap = brewermap(n, colorscheme);


%% Only update the colormap if the output was
% NOT specified. Otherwise just return the output:
if nargout == 0
    for i = 1:length(haxs)
        colormap(haxs(i), cmap)
    end
end