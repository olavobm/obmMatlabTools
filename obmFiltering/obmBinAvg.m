function [xout, xstd, nbins] = obmBinAvg(t, x, binlen, tbin, wndhandle)
% [xout, xstd, nbins] = OBMBINAVG(t, x, binlen, tbin, wndhandle)
%
%   input:
%       - t: independent variable
%       - x: vector or matrix. In the second case, bin averaging is
%            done for each row independently.
%       - binlen: window length in units of t.
%       - tbin (optional): t values for the center of the bins to take
%                          the average of (default is to use t).
%       - wndhandle (optional): default is @rectwin (box car). 
%
%   output:
%       - xout:
%       - xstd:
%       - xn:
%
% TO DO: - do not compute weights when box car window is chosen (because
%          we already know the weights and computing it is unecessary).
%        - allow t to be a matrix?
%
% Olavo Badaro Marques, 20/Mar/2017.


%%

if ~exist('wndhandle', 'var')
    wndhandle = @rectwin;
end


%%

if ~exist('tbin', 'var') || isempty(tbin)
    tbin = t;
end

tbin = tbin(:);

%
if iscolumn(x)
    x = reshape(x, 1, length(x));
end


%%

% Pre-allocate space for outputs:
nr = size(x, 1);
nc = length(tbin);

xout = NaN(nr, nc);
xstd = NaN(size(xout));
nbins = zeros(nr, nc);

%
tbinlims = [tbin - (binlen/2), tbin + (binlen/2)];

%
for i1 = 1:nr
    for i2 = 1:length(tbin)

        linbin = (t >= tbinlims(i2, 1)) & ...
                 (t <= tbinlims(i2, 2));

        %
        if any(linbin)
            
            %
            avgWeights = windowatt(wndhandle, tbinlims(i2, :), t(linbin), 15*length(t(linbin)));
            avgWeights = avgWeights(:)';    % make it a row vector
            
            xout(i1, i2) = nansum(x(i1, linbin) .* avgWeights) ./ sum(avgWeights);
            
            %
            xstd(i1, i2) = nanstd(x(i1, linbin));
            
            nbins(i1, i2) = sum(linbin);
            
        end

    end
end


