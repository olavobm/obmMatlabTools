function sliceShading(ts, clrs, tjoin)
% SLICESHADING(x, ts, clrs)
%
%   inputs:
%       - ts: Nx2, 
%       - clrs: Nx3, N colors.
%
% Function TIMESERIESSHADING adds shading to the current time series plot.
%
% Include tjoin (the time limit which would join two time intervals
% in one shading if the intervals are separated at most by tjoin).
%
% Suggestions for the future:
%   - Later on, implements color choosing by the piece
%     of code inside stackedSahding.m
%   - Would also be nice to include labels for each shaded area.
%   - I can eventually extend this for some fancy 3D application.
%   - control alpha/transparency from input.
%
% Olavo Badaro Marques, 08/Dec/2016.


%% Create vector of the y coordinates of the 

ylimsplt = ylim;
ylimsplt = [ylimsplt(1); ylimsplt(1); ylimsplt(2); ylimsplt(2)];


%% Create a 4xN array, where each column are the x
% coordinate of the vertices to be shaded:

tsaux = ts';
tsplt = [tsaux; flipud(tsaux)];


%% Loop through the columns of tsplt and shaded each slice:

hold on

for i = 1:size(ts, 1)
    
    hfaux = fill(tsplt(:, i), ylimsplt, clrs(i, :));
    
    hfaux.EdgeColor = 'none';  % because there is no transparency for the edge
    hfaux.FaceAlpha = 0.5;
    
%     set(hdpaux, 'LineStyle', 'none')
    
end


