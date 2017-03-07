function coloredScatter(t, x, z, bins, tlims, lnewplt)
% COLOREDSCATTER(t, x, z, bins, tlims, lnewplt)
%
%   inputs:
%       - t: 1xN vector.
%       - x:  "    "
%       - z:  "    "
%       - bins: 1xN vector defining N-1 bins of z to color code x.
%       - tlims (optional): 1x2 vector with limits of t to subset
%                           x and plot.
%       - lnewplt (optional): logical variable. True for opening a
%                             new figure for the plot. False for
%                             plotting on the current axes (default
%                             is true).
%
% COLOREDSCATTER makes a scatter plot of x as a function of t,
% coloring the dots for different ranges (bins) in z.
%
% The plot is done with the function plot, rather than scatter.
% Therefore, the colors are chosen automatically by Matlab
% and there is no quantitative shading (I might want to change
% that in the future).
%
% Olavo Badaro Marques, 07/Mar/2017.


%% Check if optional inputs are given:

if ~exist('lnewplt', 'var') || isempty(tlims)
    tlims = [-Inf, +Inf];
end


if ~exist('lnewplt', 'var')
    lnewplt = true;
end


%% Subset the variables:

lint = (t >= tlims(1)) & (t <= tlims(2));

t = t(lint);
x = x(lint);
z = z(lint);


%% Pre-allocate space for a matrix identifying
% in which bins the values of x belong:

nplot = length(t);
nbins = length(bins) - 1;

l_bins = false(nbins, nplot);

for i = 1:nbins
    l_bins(i, :) = (z >= bins(i) & z <  bins(i+1));
end


%% Plot the figure:

% Maybe open a new figure:
if lnewplt
    figure
end

% Actual plot:
    hold on
    for i = 1:nbins
        plot(t(l_bins(i, :)), x(l_bins(i, :)), '.', 'MarkerSize', 22)
    end
    grid on, box on
    
    