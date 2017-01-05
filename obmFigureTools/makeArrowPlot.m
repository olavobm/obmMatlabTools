function makeArrowPlot(s, x, y, u, v, xylims, xyaxes, varargin)
% MAKEARROWPLOT(s, x, y, u, v, xylims, xyaxes, varargin)
%
%   inputs:
%       - s:
%       - x:
%       - y:
%       - u:
%       - v:
%       - xylims:
%       - xyaxes:
%       -
%
% MAKEARROWPLOT calls the functions initAxesAspectRatio and plotArrows
% to plot arrows on a figure, whose axes have a fixed aspect ratio
% (derived from xyaxes) and have limits given by xylims.
%
% Olavo Badaro Marques, 14/Dec/2016.


%% Create new plot with fixed axes aspext ratio:

aspecrto = xyaxes(1) / xyaxes(2);

initAxesAspectRatio(xylims(1:2), xylims(3:4), aspecrto)


%%



% uv is a 2xN array, first (second) row is u (v):
uv = [u'; v'];


%%

uplt = uv(1, :);
vplt = uv(2, :);

plotArrows(s, x, y, uplt, vplt)

% % % % arrowPlotTransform  % this must be called inside plotArrows