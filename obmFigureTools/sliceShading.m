function sliceShading(ts, clrs)
% TIMESERIESSHADING(x, ts, clrs)
%
%   inputs:
%       - ts: Nx2, 
%       - clrs: Nx3, N colors.
%
% Function TIMESERIESSHADING adds shading to the current time series plot.
%
% Suggestions for the future:
%   - Later on, implements color choosing by the piece
%     of code inside stackedSahding.m
%   - Would also be nice to include labels for each shaded area.
%
% Olavo Badaro Marques, 08/Dec/2016.


%%

ylimsplt = ylim;
ylimsplt = [ylimsplt(1); ylimsplt(1); ylimsplt(2); ylimsplt(2)];


%% Create a 4xN array, where each column 

tsaux = ts';
tsplt = [tsaux; flipud(tsaux)];


%%

hold on

for i = 1:size(ts, 1)
    
    hfaux = fill(tsplt(:, i), ylimsplt, clrs(i, :));
    
    hfaux.EdgeColor = clrs(i, :);
    hfaux.FaceAlpha = 0.5;
    
end


