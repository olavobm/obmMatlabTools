function htxt = textFig(x0, y0, s, varargin)
% htxt = TEXTFIG(x0, y0, s, varargin)
%
%   inputs:
%       - x0: x position of the text on the figure (from 0 to 1).
%       - y0: y position.
%       - s: string to be written on the figure.
%       - varargin (optional): any parameter/value that can
%                              go into the text.m function.
%
%   outputs:
%       - htxt: text handle.
%
%
% Olavo Badaro Marques, 18/Jul/2017


%%

haxs = axes('Position', [0 0 1 1], 'Visible', 'off');

% axes(haxs)    % it already is the current axes

%
htxt = text(x0, y0, s, varargin{:});