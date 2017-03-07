function coloredScatter(t, x, z, bins, lnewplt)
% COLOREDSCATTER(t, x, z, bins)
%
%   inputs:
%       - t: 1xN vector.
%       - x:  "    "
%       - z:  "    "
%       - bins: 1xN vector defining N-1 bins of z to color code x.
%       - tlims (optional): 1x2 vector with limit in t to plot.
%       - lnewplt (optional): logical variable. True for opening a
%                             new figure for the plot. False for
%                             plotting on the current axes (default
%                             is true).
%
%
% Olavo Badaro Marques, 07/Mar/2017.


%%

if ~exist('lnewplt', 'var')
    lnewplt = true;
end


%%

nplot = length(t);
nbins = length(bins) - 1;

l_bins = false(nbins, nplot);

for i = 1:nbins
    l_bins(i, :) = (z >= bins(i) & z <  bins(i+1));
end


%%

if lnewplt
    figure
end

%
    hold on
    for i = 1:nbins
        plot(t(l_bins(i, :)), x(l_bins(i, :)), '.', 'MarkerSize', 22)
    end
    grid on, box on
    
    