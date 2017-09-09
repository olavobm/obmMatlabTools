function apply2allaxes(hfig, applycell)
% APPLY2ALLAXES(hfig, applycell)
%
%   inputs
%       - hfig: vector of figure handles (or figure numbers).
%       - applycell: cell array with axes properties name-value pairs.
%
% Use APPLY2ALLAXES if you want all of your axes (subplots)
% in a figure(s) to have the same property values.
%
% Example:
%   Let's say want to set fontsize and axis limits to be
%   the same for all axes in the current figure. Just do
%       APPLY2ALLAXES(gcf, {'FontSize', 14, 'XLim', [0, 100]})
%
% Olavo Badaro Marques, 01/Feb/2017.


%% Loop over figure handles and set axes properties:

for i = 1:length(hfig)
    
    
    %% Find all axes handles in figure hfig(i)

    allAxes = findall(hfig(i), 'Type', 'axes');

    onlyAxes = allAxes(~ismember(get(allAxes, 'Tag'), {'legend', 'Colobar'}));

    % if there are other objects in allAxes that are not axes, legend or
    % Colorbar, than I might have problems. I could add a check.
    %
    % I might want to look at the class name of the variables
    % matlab.graphics.axis.Axes
    
    N = length(onlyAxes);


    %% Set axes properties

    % Pare input applycell
    pars = applycell(1:2:end-1);
    vals = applycell(2:2:end);
    
    %
    lencell = length(applycell);
    ncustom = lencell/2;

    % Loop over axes
    for i1 = 1:N

        % Loop over axes properties to set
        for i2 = 1:ncustom

            onlyAxes(i1).(pars{i2}) = vals{i2};

        end

    end
     
end

