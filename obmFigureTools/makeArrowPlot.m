function makeArrowPlot(s, x, y, u, v, xylims, xyaxes, varargin)
% MAKEARROWPLOT(s, x, y, u, v, xylims, xyaxes, varargin)
%
%   inputs:
%       - s: scale number (increase s to shorten arrows).
%       - x: x position of arrow tails (column vector!!!).
%       - y: y    "
%       - u: x component
%       - v: y    "
%       - xylims: 1x4 vector with the axes limits.
%       - xyaxes: 1x2 vector with th length/height of the axes (in fact,
%                 the only relevant quantity is the aspect ratio.
%       - haxs:
%       - varargin: Parameter-value pairs to customize arrows appearance.
%
% MAKEARROWPLOT calls the functions initAxesAspectRatio and plotArrows
% to plot arrows on a figure, whose axes have a fixed aspect ratio
% (derived from xyaxes) and have limits given by xylims.
%
% Olavo Badaro Marques, 14/Dec/2016.


%%

%
if ~isempty(varargin)
    lmatchProp = strcmp(varargin(1:2:end), 'Axes');
    if any(lmatchProp)
        indAxesProp = find(lmatchProp);
        haxs = varargin{2*indAxesProp};
    else
        haxs = [];
    end
else
    haxs = [];
end


%% Create new plot on a new figure or change
% existing axes to a fixed axes aspect ratio:

aspecrto = xyaxes(1) / xyaxes(2);

initAxesAspectRatio(xylims(1:2), xylims(3:4), aspecrto, haxs);


%%

% uv is a 2xN array, first (second) row is u (v):
uv = [u'; v'];


%%

uplt = uv(1, :);
vplt = uv(2, :);

hp = plotArrows(s, x, y, uplt, vplt, varargin);

% % % % arrowPlotTransform  % this must be called inside plotArrows