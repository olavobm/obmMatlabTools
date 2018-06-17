function [y, mfit] = mismatch2pol(t, x, pord, lplot)
% [y, mfit] = MISMATCH2POL(t, x, pord, lplot)
%
%   inputs
%       - t: vector.
%       - x: vector.
%       - pord:
%       - lplot (optional):
%
%   outputs
%       - y:
%       - mfit:
%
% mfit output is not functional!!!
%
% Olavo Badaro Marques, 17/Jun/2018.


%%

if ~exist('lplot', 'var')
	lplot = false;
end


%%

if isvector(x)
    x = x(:); 
end


%%

%
[rx, cx] = size(x);

%
% % [rt, ct] = size(t);


%%

y = NaN(rx, cx);


%%

%
imf.power = 0:pord;


%%

for i = 1:cx
    
	%
    [xfit, mfit] = myleastsqrs(t, x(:, i), imf);
    
    %
    try
    y(:, i) = xfit - x(:, i);
    catch
        keyboard
    end
end



%%

if lplot
    
    if isvector(x)
        figure
            plot(t, x, 'LineWidth', 3)
            hold on
            plot(t, xfit, 'LineWidth', 3)

            %
            grid on
    else
        warning('No plot because input is not a vector.')
    end
end

