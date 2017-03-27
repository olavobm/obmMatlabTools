function plot2DdataStats(x, y, z, pltcode, lnewplt, dimstats)
% PLOT2DDATASTATS(x, y, z, pltcode, lnewplt)
%
%   inputs:
%       - x:
%       - y:
%       - z:
%       - pltcode (optional): default is [1, 2, 3].
%       - lnewplt (optional): default is true.
%       - dimstats (optional): default is 2.
%
% Olavo Badaro Marques, 27/Mar/2017.


speedaux = sqrt(correctedData.RDIadcp(i).u.^2 + correctedData.RDIadcp(i).v.^2);

figure
    axes('Position', [0.08 0.2 0.6 0.6])
        pcolor(correctedData.RDIadcp(i).yday, ...
               correctedData.RDIadcp(i).z, ...
               speedaux)
        shading flat, axis ij
        caxis([0 0.3])
        colorbar
        title('T3 - Speed')

    axes('Position', [0.8 0.2 0.15 0.6])
        plot(nanvar(speedaux'), correctedData.RDIadcp(i).z, '.-')               
        axis ij
        title('Variance')
        if i==1
            xlim([0 0.01])
        else
            xlim([0 0.007])
        end

    apply2allaxes(gcf, {'FontSize', 14, 'YLim', yaxaux(i, :)})

    linkallaxes('y')