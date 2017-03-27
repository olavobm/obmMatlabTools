function haxs = plot2DdataStats(x, y, z, dimstats, lnewplt)
% haxs = PLOT2DDATASTATS(x, y, z, dimstats, lnewplt)
%
%   inputs:
%       - x:
%       - y:
%       - z:
%       - dimstats (optional): default is 2.
%       - lnewplt (optional):
%
%   outputs:
%       - x:
%
% Olavo Badaro Marques, 27/Mar/2017.


%%
    
if ~exist('dimstats', 'var')
    dimstats = 2;
end 

if ~exist('lnewplt', 'var')
    lnewplt = true;
end 


%%

axsPos = NaN(3, 4);

if dimstats==1
    
%     zpltH = 
   
elseif dimstats==2
    
    zpltL = 0.45;
    statspltL = 0.15;
    dumarg = 0.2;
    lenspac = 0.05;
    lmarg = 0.1;
    
    axsPos(1, :) = [lmarg, dumarg, zpltL, 1-(2*dumarg)];
    axsPos(2, :) = [lmarg+zpltL+lenspac, dumarg, statspltL, 1-(2*dumarg)];
    axsPos(3, :) = [lmarg+zpltL+lenspac+statspltL+lenspac, dumarg, statspltL, 1-(2*dumarg)];
    
else
    
    error('dimstats should be either 1 or 2')
    
end


%%

    
%%

%
if lnewplt
    figure
else
    allAxes = findall(gcf, 'Type', 'axes');
    if ~isempty(allAxes)
        error('Current figure already has objects on it.')
    end
end

%
haxs = gobjects(1, 3);

%
    haxs(1) = axes('Position', axsPos(1, :));
        pcolor(x, y, z)
        shading flat
        axis ij
        colorbar
        
	haxs(2) = axes('Position', axsPos(2, :));
        plot(nanmean(z, 2), y, '.-')
        axis ij
        grid on
        set(gca, 'YTickLabel', [])
        title('Mean')
        
	haxs(3) = axes('Position', axsPos(3, :));
        plot(nanvar(z'), y, '.-')
        axis ij
        grid on
        set(gca, 'YTickLabel', [])
        title('Variance')
        
    apply2allaxes(gcf, {'FontSize', 14})

    linkallaxes('y')