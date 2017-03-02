function hplt = overlayline(vorh, a, varargin)
% OVERLAYLINE(x, vorh, varargin)
%
%   inputs:
%       - vorch: either 'v' or 'h', for vertical or horizontal.
%       - a: vector of x (for 'v') or y (for 'h') locations of where
%            you want to draw vertical or horizontal lines.
%       - varargin (optional): parameters-value pairs that c
%
%   outputs:
%       - hplt: name-value pair arguments acceptable by the function plot.
%
% Simple little function to plot horizontal or vertical line(s).
% A vertical (horizontal) line spans the entire y (x) range.
%
% Olavo Badaro Marques, 02/Mar/2017.


%% Check size of a and transform it in a 2xlength(a) array:

if isvector(a)
    
    if iscolumn(a)
        a = a';
    end
    
else
    error('Input a is a matrix. It must be a vector.')
end

n = size(a, 2);

% Replicate a to create a 2xlength(a) array:
a = [a; a];


%% Create x and y arrays of size 2xlength(a) with the
% x and y coordinates of the end points of the line(s).
% Each column is a different line:

if strcmp(vorh, 'v')
    
    x = a;
    
    y = ylim;
    y = y(:);
    y = repmat(y, 1, n);
    
elseif strcmp(vorh, 'h')
   
    x = xlim;
    x = x(:);
    x = repmat(x, 1, n);
    
    y = a;
else
    
    error('not allowed!')
    
end


%% Plot the lines:

hold on

hplt = plot(x, y, varargin{:});
