function indy = findwithinbound(x, y, r)
% indy = FINDWITHINBOUND(x, y, r)
%
%   inputs:
%       - x: vector.
%       - y: vector.
%       - r: number greater than 0.
%
%   outputs:
%       - indy: indices of the elements of y that are
%               either equal or in between the elements
%               of x. In the second case, keep indices
%               only if the adjacent values of x to y
%               are separated by, at most, a distance r.
%
% Function FINDWITHINBOUND does what the description of
% the output above says. I wrote this function so I could
% interpolate over small gaps, but not large gaps (small
% and large relative to r). Look at my other function
% interp1overnans where FINDWITHINBOUND is implemented.
%
% Olavo Badaro Marques, 19/Jan/2017.


%% Deal separately with elements of
% y that are found or not in x:

lydiffx = ~ismember(y, x);

indysamex = find(~lydiffx);
indydiffx = find(lydiffx);

ydiffx = y(lydiffx);


%% Get indices of the bins of x that
% are shorther or equal than r:

xdists = (x(2:end) - x(1:end-1));

indclosedists = find(xdists<=r);


%% Get indices of the bins of x where
% each elements of y is found:

[~, indywhichbin] = histc(ydiffx, x);


%% Get indices of y that are in bins shorter or equal than r:

indywithin = indydiffx(ismember(indywhichbin, indclosedists));


%% Concatenate the array of indices and sort in ascending order:

indy = [indysamex, indywithin];
indy = sort(indy);
