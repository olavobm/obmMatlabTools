function setFigSize(lenhgt, units)
% SETFIGURESIZE(lenhgt, units)
%
%   inputs:
%       - lenhgt: length-height vector. lenhgt(1)/lenhgt(2) is the
%                 length/height of the figure.
%       - units (optional): figure size units. The default is centimeters.
%                           The options are: 'inches'; 'centimeters';
%                           'characters'; 'normalized'; 'points'; 'pixels'.
%
% The resizing of Matlab's figure window as it appear on the screen is a
% copy of the function wysiwyg.m, created by Dan(K) Braithwaite and
% available on the web.
%
% Suggestions: include figure handle in the input
%
% Olavo Badaro Marques, 09/Dec/2016.


%% Get current figure handle:

hFig = gcf;


%% Check whether units input was specified:

if ~exist('units', 'var') || isempty(units)
    units = 'centimeters';
end


%% Make sure input lenhgt was specified appropriately:

if length(lenhgt)~=2
    error('Input lenhgt must have 2 elements only.')
else
    if iscolumn(lenhgt)
        lenhgt = lenhgt';
    end
end


%%

set(hFig, 'Units', units)
set(hFig, 'PaperSize', lenhgt)
set(hFig, 'PaperPosition', [0 0 lenhgt])


%% Resize Matlab's figure window function 
wysiwyg

%     unis = get(gcf,'units');
%     ppos = get(gcf,'paperposition');
%     set(gcf,'units',get(gcf,'paperunits'));
%     pos = get(gcf,'position');
%     pos(3:4) = ppos(3:4);
%     set(gcf,'position',pos);
%     set(gcf,'units',unis);