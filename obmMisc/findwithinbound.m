function indy = findwithinbound(x, y, r)
% indy = FINDWITHINBOUND(x, y, r)
%
%   inputs:
%       - x:
%       - y:
%       - r:
%
%   outputs:
%       - indy:
%
% Function FINDWITHINBOUND .......
%
% Olavo Badaro Marques, 19/Jan/2017.


%%

lydiffx = ~ismember(y, x);

ydiffx = y(lydiffx);

indy = find(~lydiffx);

indydiffx = find(lydiffx);


%% Get indices of the bins of x that
% are shorther or equal than r:

xdists = (x(2:end) - x(1:end-1));

indclosedists = find(xdists<=r);


%% Get indices of the bins of x where
% each elements of y is found:

[~, indywhichbin] = histc(ydiffx, x);


%% Get indices of y that are in bins shorter or equal than r:

% indywithin = find(ismember(indywhichbin, indclosedists));
indywithin = indydiffx(ismember(indywhichbin, indclosedists));


%%

indy = [indy, indywithin];

indy = sort(indy);
