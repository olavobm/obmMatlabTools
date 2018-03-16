function apply2allaxes(hfig, applycell)
% APPLY2ALLAXES(hfig, applycell)
%
%   inputs
%       - hfig: vector of figure OR axes handles (or figure numbers).
%       - applycell: cell array with axes properties name-value pairs.
%
% Use APPLY2ALLAXES if you want all of your axes (subplots)
% in a figure(s) to have the same property values. Input
% hfig can also be just a vector of the axes handles you
% to format.
%
% Example:
%   Let's say want to set fontsize and axis limits to be
%   the same for all axes in the current figure. Just do
%       APPLY2ALLAXES(gcf, {'FontSize', 14, 'XLim', [0, 100]})
%
% Olavo Badaro Marques, 01/Feb/2017.


%%

if isa(hfig(1), 'matlab.ui.Figure')
    
    Nhfigs = length(hfig);
    lhfig = true;
    
elseif isa(hfig(1), 'matlab.graphics.axis.Axes')
    
    Nhaxs = length(hfig);
    lhfig = false;
else
    
end


%% Parse input applycell

%
pars = applycell(1:2:end-1);
vals = applycell(2:2:end);

%
lencell = length(applycell);
ncustom = lencell/2;


%% Now format the appropriate axes:

% If input is figure handle(s)
if lhfig

    % Loop over figures
    for i = 1:Nhfigs
        %% Find all axes handles in figure hfig(i)

        allAxes = findall(hfig(i), 'Type', 'axes');

        onlyAxes = allAxes(~ismember(get(allAxes, 'Tag'), {'legend', 'Colobar'}));

        % if there are other objects in allAxes that are not axes, legend or
        % Colorbar, then I might have problems. I could check for that.
        %
        % I might want to look at the class name of the variables
        % matlab.graphics.axis.Axes

        N = length(onlyAxes);


        %% Set axes properties

        % Loop over axes
        for i1 = 1:N
            % Loop over axes properties to set
            for i2 = 1:ncustom
                onlyAxes(i1).(pars{i2}) = vals{i2};
            end
        end

    end
    
% If input is axes handle(s)
else
        %% Set axes properties

        % Loop over axes
        for i1 = 1:Nhaxs
            % Loop over axes properties to set
            for i2 = 1:ncustom
                hfig(i1).(pars{i2}) = vals{i2};
            end
        end

end