function y0 = interpfastFromInd(x, y, x0, ind4interp)
% y0 = INTERPFASTFROMIND(x, y, x0, ind4interp)
%
%   inputs:
%       -
%       -
%       -
%       -
%
%   outputs:
%       -
%
%
%
% Olavo Badaro Marques, 24/Jul/2017.



lOK = ~isnan(ind1);

y0(lOK) = x(ind1(lOK)) + (x0 - y(ind1(lOK))) .* ...
          ((x(ind2(lOK)) - x(ind1(lOK))) ./ (y(ind2(lOK)) - y(ind1(lOK))));