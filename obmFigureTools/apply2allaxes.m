function apply2allaxes(hfig, applycell)
% APPLY2ALLAXES(hfig, applycell)
%
%   inputs:
%       - hfig: vector of figure handles or numbers.
%       - applycell: cell array with axes properties name-value pairs.
%
% Set values of axes properties for all the axes in figure(s) hfig.
%
% Olavo Badaro Marques, 01/Feb/2017.


%% Should check the inputs:


%% Loop over figure handles:

for i = 1:length(hfig)
    
    
    %% Find all

    allAxes = findall(hfig(i), 'Type', 'axes');

    onlyAxes = allAxes(~ismember(get(allAxes, 'Tag'), {'legend', 'Colobar'}));

    % if there are other objects in allAxes that are not axes, legend or
    % Colorbar, than I might have problems. I could add a check.

    N = length(onlyAxes);


    %%

    lencell = length(applycell);

    ncustom = lencell/2;

    pars = applycell(1:2:end-1);
    vals = applycell(2:2:end);

    for i1 = 1:N

        for i2 = 1:ncustom

            onlyAxes(i1).(pars{i2}) = vals{i2};

        end

    end
    
    
    
    
end

