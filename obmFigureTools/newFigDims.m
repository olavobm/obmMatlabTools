function hfig = newFigDims(lenhei, lnew)
% hfig = NEWFIGDIMS(lenhei)
%
%   inputs:
%       - lenhei: vector with 2 elements, length and height, in this order.
%       - lnew (optional): logical variable, true for creating new figure
%                          (default) or false for acting on the current
%                          figure.
%
%   outputs:
%       - hfig: figure handle.
%
% Units are inches, (but should implement giving input for different units).
%
% Note that this function set the figure dimensions. In general, the
% aspect ratio of the axes of a plot in the figure will be different
% than the aspect ratio of the figure itself.
% 
% The last part of this function was copied from
% wysiwyg.m, available on the internet.
%
% TO DO:
%   - There are some unnecessary things at the end of this code.
%
% Olavo Badaro Marques, 13/Feb/2017.


%%

if nargin==0

    %
    originalUnits = get(gcf, 'Units');
    set(gcf, 'Units', get(gcf, 'PaperUnits'));
    
    %
    figposaux = get(gcf, 'Position');
    disp(figposaux(3:4));
    
    set(gcf, 'Units', originalUnits);
    
    % End function
    return
end


%%

if ~exist('lnew', 'var')
    lnew = true;
end

% Check whether lnew is a logical array. At least in Matlab2015a,
% if lnew is a char array, it will work as true when doing "if lnew":
if ~isa(lnew, 'logical')
    error('Input lnew is not a logical array. It must be.')
end


%% Depending on lnew variable, open a new figure:

if lnew
    figure
end

% Assign output (only assign if output is required)
if nargout==1
    hfig = gcf;
end


%% Set figure paper dimensions (i.e. the
% dimensions of a file saved with print):

set(gcf, 'Units', 'centimeters')

set(gcf, 'PaperSize', lenhei)

set(gcf, 'PaperPosition',[0 0 lenhei])
    

%% Set figure window dimensions the same as the paper dimensions,
% so that the dimensions of what you see on the screen are the
% same as the printed figures:

originalUnits = get(gcf, 'Units');

set(gcf, 'Units', get(gcf, 'PaperUnits'));
pos = get(gcf, 'Position');
pos(3:4) = lenhei;

set(gcf, 'Position', pos);
set(gcf, 'Units', originalUnits);
 
    