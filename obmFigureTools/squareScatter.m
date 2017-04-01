function squareScatter(x, y, margfac, lcut)
% SQUARESCATTER(x, y, margfac, lcut)
%
%   inputs:
%       - x: array of real numbers.
%       - y: same as above
%       - margfac (optional): percentage to extend the axes limits.
%       - lcut (optional): NOT implemented
%
% Plots a scatter plot with a 1 to 1 aspect ration, which is
% often desirable when x and y have the same dimensions. The
% axes limits are determined by the value in x or y of largest
% magnitude and an extra (or smaller margin) defined by margfac.
% 
% lcut ????? for quadrants
%
% Dependencies: initSquarePlot.m
%
%
%
% Olavo Badaro Marques, 16/Mar/2017.


%% Deal with inputs:

% Reshape to column vectors:
x = x(:);
y = y(:);

% Use default value if input margfac is not given:
if ~exist('margfac', 'var')
    margfac = 0.1;
end


%% Define axes limits:

maxaxs = max([max(abs(x)), max(abs(y))]);

vecaxslims = [-1 1 -1 1] .* maxaxs * (1+margfac);


%% lcut???


%% Plot scatter plot:

% Open figure (with a another function that
% sets a few plot appearance properties):
initSquarePlot(vecaxslims(1:2), vecaxslims(3:4))

    plot(x, y, '.', 'MarkerSize', 24)
