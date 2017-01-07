function [zpts, xygpts, xypts] = subsetfrom2Dplot(axishandle, surfacehandle)
% [zpts, xygpts, xypts] = SUBSETFROM2DPLOT(axishandle, surfacehandle)
%
%   inputs:
%       - axishandle: axes handle of the figure you want to subset.
%       - surfacehandle (optional):
%
%   outputs:
%       - zpts: subsetted values of input z.
%       - xygpts: values of (x, y) associated with zpts,
%                 i.e. the closest (x, y) to xypts.
%
% SUBSETFROM2DPLOT lets you click as many times as you want inside the
% axes (with handle axishandle) and gets the value of the plotted
% variable in the nearest locations where the variable is defined.
%
% When SUBSETFROM2DPLOT is called, a loop is opened. To complete the
% execution, click on the figure outside the axes limits.
%
% Olavo Badaro Marques, 04/Jan/2017.


%% Bring forward the window of the
% figure that cointains axishandle:

axes(axishandle)


%% Get limits of the axes:

xaxislims = get(axishandle, 'XLim');
yaxislims = get(axishandle, 'YLim');


%% Open a while loop to select points on the plot. Terminate
% the loop by clicking outside the axes limits:

linwhile = true;

xypts = [];

while linwhile
    
    xyptaux = ginput(1);
    
    linxlim = xyptaux(1)>=xaxislims(1) && xyptaux(1)<=xaxislims(2);
    linylim = xyptaux(2)>=yaxislims(1) && xyptaux(2)<=yaxislims(2);
    
    % If xyptaux is within axes limits, concatenate to xypts array:
    if linxlim && linylim
        
        xypts = [xypts; xyptaux];    %#ok<AGROW>
        % the comment above supresses the warning
        % message on Matlab's text editor
        
	% Otherwise, terminates while loop:
    else
        linwhile = false;
    end
    
end


%% Get x, y, z values from the children of
% the axes and subset acording to xpts:

if ~exist('surfacehandle', 'var')
    plthandle = get(axishandle, 'Children');
else
    plthandle = surfacehandle;
end


[zpts, xygpts] = subsetin2D(xypts, ...
                            plthandle.XData, plthandle.YData, plthandle.CData);


