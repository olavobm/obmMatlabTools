function y0 = interpfastFromInd(x, y, x0, ind4interp)
% y0 = INTERPFASTFROMIND(x, y, x0, ind4interp)
%
%   inputs:
%       - x:
%       - y:
%       - x0:
%       - ind4interp:
%
%   outputs:
%       - y0:
%
%
%
% Olavo Badaro Marques, 24/Jul/2017.


%%

y0 = NaN(1, size(y, 2));

%
lok = ~isnan(ind4interp(1, :));
y0(ind4interp(1, lok)) = y(ind4interp(1, lok));

%
ind1 = ind4interp(2, :);
ind2 = ind1 + 1;
lok = ~isnan(ind1);

y0(lok) = y(ind1(lok)) + (x0 - x(ind1(lok))) .* ...
                    ((y(ind2(lok)) - y(ind1(lok))) ./ ...
                     (x(ind2(lok)) - x(ind1(lok))));
                 