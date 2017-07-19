function htxt = textFig(x0, y0, s, varargin)
% htxt = TEXTFIG(x0, y0, s, varargin)
%
%   inputs:
%       - x0:
%       - y0:
%       - s:
%       - varargin (optional):
%
%   outputs:
%       - htxt:
%
%
% Olavo Badaro Marques, 18/Jul/2017


haxs = axes('Position', [0 0 1 1], 'Visible', 'off');

% axes(haxs)    % it already is the current axes

%
htxt = text(x0, y0, s, varargin);