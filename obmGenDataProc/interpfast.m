function [y0, ind4interp] = interpfast(x, y, x0)
% [y0, ind4interp] = INTERPFAST(x, y, x0)
%
%   inputs:
%       - x:
%       - y:
%       - x0:
%
%   outputs:
%       - yinterp:
%       - ind4interp:
%
% Olavo Badaro Marques, 24/Jul/2014.


%%

N = size(y, 2);

nr = size(y, 1);


%%
lsame = (y == x0);
lsmall = (y < x0);
lbig = (y > x0);


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
        
        y0(i) = x(ithlsame);
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

y0(lOK) = x(ind1(lOK)) + (x0 - y(ind1(lOK))) .* ...
          ((x(ind2(lOK)) - x(ind1(lOK))) ./ (y(ind2(lOK)) - y(ind1(lOK))));


%%

ind4interp = [ind0; ind1];

