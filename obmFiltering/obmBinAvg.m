function [xout, xstd, nbins] = obmBinAvg(t, x, binlen, tbin)
% [xout, xstd, nbins] = OBMBINAVG(t, x, binlen, tbin)
%
%   input:
%       - t:
%       - x: vector or matrix, regularly spaced across the rows (the
%            dimension where the running mean is applied).
%       - binlen: window length in units of t.
%       - tbin (optional): t values for the center of the bins to take the
%                          average of.
%
%   output:
%       - xout:
%       - xstd:
%       - xn:
%
% Olavo Badaro Marques, 20/Mar/2017.


%%

if ~exist('tbin', 'var')
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
            
            xout(i1, i2) = nanmean(x(i1, linbin));
            xstd(i1, i2) = nanstd(x(i1, linbin));
            
            nbins(i1, i2) = sum(linbin);
            
        end

    end
end


