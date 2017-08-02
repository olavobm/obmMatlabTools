function y = wrapPhase(phalims, x)
% y = WRAPPHASE(phalims, x)
%
%   inputs
%       - phalims: 1x2 array, with min/max phase limits.
%       - x: phase (in the same units as phalims).
%
%   outputs
%       - y: x wrapped (bounded) between phalims.
%
% Wraps phase values (x) between the limits given by phalims.
% Matlab has functions for specific limits, such as wrapTo2Pi.m.
%
% Olavo Badaro Marques, 22/Mar/2017.


%% Phase limits range

angrange = phalims(2) - phalims(1);


%% Wrap the phase

% Pre-allocate
y = NaN(size(x));

% Phases that already are within phalims
linlim = (x >= phalims(1) & x <= phalims(2));
y(linlim) = x(linlim);

% Values larger than upper limit
lbig = (x > phalims(2));
y(lbig) = mod(x(lbig) - phalims(2), angrange) + phalims(1);

% Values smaller than lower limit
lsmall = (x < phalims(1));
y(lsmall) = mod(x(lsmall) - phalims(1), angrange) + phalims(1);

