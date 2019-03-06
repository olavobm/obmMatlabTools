function shadeAll(h2shd, strtype)
% SHADEALL(h2shd, strtype)
%
%   inputs
%       - h2shd (optional): figure OR axes handles (vector) to shade
%                           (do NOT mix figure and axes handle together).
%       - strtype (optional): string setting the shading option.
%
%
% So far, this only does shading flat and works with no inputs.
%
% Olavo Badaro Marques, 07/Feb/2019.


%%

%
if nargin == 0
    
    %
	hfig = get(gcf);
    
    %
    hs_children = hfig.Children;
    N = length(hs_children);
    
    %
    for i = 1:N
        if isa(hs_children(i), 'matlab.graphics.axis.Axes')
            shading(hs_children(i), 'flat')
        end
    end
    
%
else
    
	%
    if isa(h2shd(1), 'matlab.graphics.axis.Axes')
        
        %
        Naxs = length(h2shd);
        haxs2shd = h2shd;
        
	%
    elseif isa(h2shd(1), 'matlab.ui.Figure')
        % NOT DONE!!!!
        %
        allhaxs_cell = cell(1, length(h2shd));
        
        %
        for i = 1:length(h2shd)
            allhaxs_cell{i} = h2shd(i).Children;
        end
        
        % Now I need to concatenate all
        % allhaxs_cell into an array
        
	%
    else
        error('Not allowed.')
    end
    
    %
    for i = 1:Naxs
        shading(haxs2shd(i), 'flat')
    end
    
    
end