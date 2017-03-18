function initSquarePlot(xlims, ylims)
% INITSQUAREPLOT(xlims, ylims)
%
%   inputs:
%       - xlims: limits of the x axis.
%       - ylims: limits of the y axis.
%
% Create a plot background if the limits xlims and ylims
% and axis equals. The tick marks on both axis are set
% to be the same. If ylims is not given, then use xlims
% for ylims as well.
%
% Olavo Badaro Marques, 17/Mar/2017.


%% If second input is not given, make it the same as xlims:

if ~exist('ylims', 'var')
    ylims = xlims;
end


%% Create plot background:

figure
    hold on
    axis equal
    grid on, box on
    xlim(xlims)
    ylim(ylims)
       
% Make ticks on both axes to be the same:
    xtickslen = length(get(gca, 'XTick'));
    ytickslen = length(get(gca, 'YTick'));
    
    if xtickslen > ytickslen
        
        set(gca, 'YTick', get(gca, 'XTick'))
        
    elseif xtickslen < ytickslen
        set(gca, 'XTick', get(gca, 'YTick'))
    end