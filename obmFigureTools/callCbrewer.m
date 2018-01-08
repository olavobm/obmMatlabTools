function [cmap] = callCbrewer(colorscheme, haxs, n)
% [cmap] = CALLCBREWER(colorscheme, haxs, n)
%
%   inputs
%       - colorscheme: string specifying a color scheme. It can be
%                      either a string from the ones that I have
%                      defined or from brewermap.m (read below).
%       - haxs: array of axes or figure handles to
%               apply the colormap onto.
%       - n: number of colors (later change this function such that
%            the number of colors is equal to a user specified
%            resolution and data range).
%
%   outputs
%       - cmap: colormap array (with the 3 columns, correspondent to RGB).
%
% CALLCBREWER.m creates a colormap with the brewermap function
% (https://github.com/DrosteEffect/BrewerMap).
%
% Type callCbrewer('options') to see the strings that I have
% defined to call the color schemes from brewermap that I
% usually use. Type help brewermap to see all the color schemes
% provided by this function.
%
% The default color scheme is the divergent blue/red.
% The color schemes provided by brewermap are gorgeous.
% 
% Olavo Badaro Marques, 07/Dec/2017.


%% If "haxs" and "n" inputs are not
% given, choose default values:

if ~exist('haxs', 'var')
    haxs = gcf;
end

if ~exist('n', 'var')
    n = 64;
end


%% Define an array of "easy names" of colormaps,
% which can be called and are mapped to the actual
% names of colormaps in brewermap:

listEZColorSchemes = {'divRB', 'seqOR', ...
                      'YlGnBu', 'Blues'};

listCBColorSchemes = {'*RdBu', 'OrRd', ...
                      'YlGnBu', 'Blues'};


%% Map color scheme names

mapColors = containers.Map(listEZColorSchemes, listCBColorSchemes);


%% If the only input is the string 'options',
% then print to the screen the easy names
% available to use

if nargin==1 && strcmp(colorscheme, 'options')
    
    sprintf('Optional schemes with easy names are: \n')
    disp(listEZColorSchemes)
    return
end


%% Define the colorscheme (with a string accepted
% by brewermap) that will define the colormap created:

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


%% Creates the colormap:

cmap = brewermap(n, colorscheme);


%% Only update the colormap if the output was
% NOT specified. Otherwise just return the output:
if nargout == 0
    for i = 1:length(haxs)
        colormap(haxs(i), cmap)
    end
end