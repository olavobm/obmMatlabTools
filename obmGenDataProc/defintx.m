function xint = defintx(t, x, dt, tlims, tmaxgap, idim)
% xint = DEFINTX(t, x, dt, tlims, tmaxgap, idim)
%
%   inputs
%       - t:
%       - x:
%       - dt:
%       - tlims:
%       - tmaxgap (optional):
%       - idim (optional):
%
%   outputs
%       - xint:
%
% Calculate the integral of x (function of t) between the
% limits tlims. This is calculated by first interpolating
% x over a regular grid with spacing dt.
%
% The integral is taken along the dimension idim (following
% Matlab's convention). The default value is 1 (across rows).
%
%
% TO DO:
%       - Actually, my function interp1overnans doesn't work
%         for higher dimensions.
%
% Olavo Badaro Marques, 03/Aug/2018.


%%

tgrid = tlims(1) : dt : tlims(2);


%%

xgrid = interp1overnans(t, x, tgrid, tmaxgap);


%%

xint = nansum(xgrid, 1) .* dt;




