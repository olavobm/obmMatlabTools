function initAxesAspectRatio(xlims, ylims, aspecrto)
% initAxesAspectRatio(xlims, ylims, aspecrto)
%
%   inputs:
%       -
%       -
%       - aspecrto (optional): length by height. If not specified, the
%                              option axis equal is set.
%
% Function INITAXESFREEZEASPECTRATIO written to create axes with a certain
% aspect ratio, which is necessary when plotting a vector field (see
% function plotArrows.m).
%
% There might be some small (hopefully small) uncertainties due to small
% differences in the aspect ratio of the figure and of the axes.
%
% Possibly include zlims in the future for 3D plots (the input format can
% be much simplified if all the limits come in one input array -- you can
% then know if it is 2D or 3D plot by the number of rows/columns).
%
% Olavo Badaro Marques, 12/Dec/2016.


%%
if length(xlims)~=2 || length(ylims)~=2
    error('Specified axes limits have more than 2 elements')
end


%%

figure     % change this later, for
    axes   % example, to allow subplots
    
    % If there is no input for the aspect ratio, set axis equal:
    if ~exist('aspecrto', 'var') || isempty(aspecrto)
        axis equal
        
	% Otherwise, set input-specified aspect ratio:
    else
        pbaspect([aspecrto 1 1])
    end
    
    axis([xlims, ylims])
    
% setFigSize(lenhgt, units)   % most likely not necessary...