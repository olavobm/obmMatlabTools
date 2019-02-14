function [htxt, hbox] = labelfig(haxs, textstr, fracmarg, lbox, varargin)
% [htxt, hbox] = LABELFIG(haxs, textstr, fracmarg, lbox, varargin)
%
%   inputs
%       - haxs:
%       - textstr:
%       - fracmarg: scalar or 1x2 vector with
%                   the fractional margin spacing.
%       - fracmarg:
%       - lbox:
%       - varargin:
%
%   outputs
%       - htxt:
%       - hbox:
%
%
% TO DO:
%   - MAKE IT WORK!
%
%
%   - should make margin optional and dependent on fontsize
%   - WATCH FOR REVERSED Y AXIS.
%
% Olavo Badaro Marques, 14/Feb/2019.


%%

if length(fracmarg)==1
    fracmarg = [fracmarg, fracmarg];
elseif length(fracmarg)==2
    % do nothing
else
    error('Not possible')
end


%%

for i = 1:length(haxs)
    
    %
    axslims_aux = axis(haxs(i));
    xrange_aux = axslims_aux(2) - axslims_aux(1);
    yrange_aux = axslims_aux(4) - axslims_aux(3);
    
    %
    poslims_aux = get(haxs(i), 'Position');
    
    %
    xposrange_aux = poslims_aux(2) - poslims_aux(1);
    yposrange_aux = poslims_aux(4) - poslims_aux(3);
    
    %
    xloc = poslims_aux(1) + xposrange_aux .* fracmarg(1);
    yloc = poslims_aux(3) + yposrange_aux .* fracmarg(2);
    
    % Now scale location to the axes scales
    xloc_plt = xloc + (xrange_aux ./ (xrange_aux));
    yloc_plt = yloc + (yrange_aux ./ (yrange_aux));
    
    %
    htxt = text(xloc_plt, yloc_plt, textstr);

end

