function y = wrapPhase(limang, x)
% y = WRAPPHASE(limang, x)
%
%   inputs:
%       - limang:
%       - x:
%
%   outputs:
%       - y: x wrapped between limang.
%
%
% Olavo Badaro Marques, 22/Mar/2013.


angrange = limang(2) - limang(1);

y = NaN(size(x));

linlim = (x >= limang(1) & x <= limang(2));
y(linlim) = x(linlim);

lbig = (x > limang(2));
y(lbig) = mod(x(lbig) - limang(2), angrange) + limang(1);

lsmall = (x < limang(1));
y(lsmall) = mod(x(lsmall) - limang(1), angrange) + limang(1);

