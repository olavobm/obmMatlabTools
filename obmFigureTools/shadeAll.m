function shadeAll(h2shd, strtype)
% SHADEALL(h2shd, strtype)
%
%   inputs
%       - h2shd:
%       - strtype:
%
%
%
%
% Olavo Badaro Marques, 07/Feb/2019.


%%

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
    
    
else
    
    
    
end