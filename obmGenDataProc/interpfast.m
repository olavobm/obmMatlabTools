function [y0, ind4interp] = interpfast(x, y, x0)
% [y0, ind4interp] = INTERPFAST(x, y, x0)
%
%   inputs
%       - x: independent variable associated with the rows of y.
%       - y: variable to interpolate.
%       - x0: 1 value in the x-dimension.
%
%   outputs
%       - yinterp: vector of y interpolated on x0.
%       - ind4interp: row indices used in the interpolation.
%
%
%
% Olavo Badaro Marques, 24/Jul/2014.


%%

N = size(y, 2);

nr = size(y, 1);


%%
lsame = (x == x0);
lsmall = (x < x0);
lbig = (x > x0);


%%
ind0 = NaN(1, N);

ind1 = NaN(1, N);
% ind2 = NaN(1, N);

y0 = NaN(1, N);

% --------------------------------------------------------------------
% I can get the lsame outside of the loop, but that
% probably won't increase efficiency by much.
% --------------------------------------------------------------------

%
for i = 1:N
    
    ithlsame = lsame(:, i);
    ithlsmall = lsmall(:, i);
    ithlbig = lbig(:, i);
    
    if any(ithlsame)
        
        y0(i) = y(ithlsame);
        ind0(i) = find(ithlsame);
        
    else
        
        %
        if any(ithlsmall) && any(ithlbig)
            ind1(i) = find(ithlsmall, 1, 'last') + nr*(i-1);
        end
                
    end
    
end

ind2 = ind1 + 1;


%%

%
lOK = ~isnan(ind1);

y0(lOK) = y(ind1(lOK)) + (x0 - x(ind1(lOK))) .* ...
          ((y(ind2(lOK)) - y(ind1(lOK))) ./ (x(ind2(lOK)) - x(ind1(lOK))));


%%

ind4interp = [ind0; ind1];

