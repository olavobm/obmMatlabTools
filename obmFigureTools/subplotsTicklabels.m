function rmTickLabels(rmlabel, hfig)
% RMTICKLABELS(rmlabel, hfig)
% 
%   inputs
%       - rmlabel (optional): 'x', 'y' or 'xy' (which is the default).
%       - hfig (optional): vector of figure handles
%                          or numbers (default is gcf).
%
% For a set of figure handles with a grid of subplots, remove
% the tick labels in the "inner side" of the grid (which may
% improve readability).
%
% Olavo Badaro Marques, 04/May/2017.


%% Choose default values

if nargin==0
    rmlabel = 'xy';
end

nAxs = 0;
posind = NaN(1, 2);
sortind = NaN(1, 2);
workOn = cell(1, 2);

if ~isempty(strfind(rmlabel, 'x'))
    nAxs = nAxs + 1;
    
    posind(nAxs) = 1;
    sortind(nAxs) = 2;
    workOn{nAxs} = 'XTickLabel';
end

if ~isempty(strfind(rmlabel, 'y'))
    nAxs = nAxs + 1;
    
    posind(nAxs) = 2;
    sortind(nAxs) = 1;
    workOn{nAxs} = 'YTickLabel';
end

posind = posind(1:nAxs);
sortind = sortind(1:nAxs);
workOn = workOn(1:nAxs);


%% If there is no input, assign current figure handle by default:

if ~exist('hfig', 'var')
    hfig = gcf;
end


%% Loop over figure handles:

for i = 1:length(hfig)
    
    
    %% Find all axes handles:

    allAxes = findall(hfig(i), 'Type', 'axes');

    onlyAxes = allAxes(~ismember(get(allAxes, 'Tag'), {'legend', 'Colobar'}));

    % if there are other objects in allAxes that are not axes, legend or
    % Colorbar, than I might have problems.
    %
    % I might want to look at the class name of the variables
    % matlab.graphics.axis.Axes
    
    N = length(onlyAxes);

    
    %%
    
    allPos = [onlyAxes.Position];
    
    allPos = reshape(allPos, 4, N);
    
    allPos = allPos';
    
    indPos2Axes = 1:N;
    % (if containes.Map was more flexible -- with different kinds
    % of objects -- than I could write something better):

    
    %%
    
    % Loop over the type of axis to work on (x and/or y):
    for i2 = 1:nAxs
    
        % Pre-allocate (longer vector than the longest possible):
        axsAligned = cell(N, 2);
        
        aux_allPos = allPos;
        aux_allInds = indPos2Axes;
        
        rAligned = 0;
        
        % Split all axes into sets, such that for each set, all
        % axes are aligned by posind(i2). Since we don't know
        % a priori how many sets there are, use a while loop:
        while ~isempty(aux_allPos)
            
            lmatch = (aux_allPos(:, posind(i2)) == aux_allPos(1, posind(i2)));
            
            if length(find(lmatch))>1
                
                rAligned = rAligned + 1;
            
                axsAligned{rAligned, 1} = aux_allPos(lmatch, :);
                axsAligned{rAligned, 2} = aux_allInds(lmatch);
            end
            
            aux_allPos = aux_allPos(~lmatch, :);
            aux_allInds = aux_allInds(~lmatch);
        end
        
        % Remove empty elements (the unnecessary
        % elements created when pre-allocating):
        axsAligned = axsAligned(~cellfun(@isempty, axsAligned(:, 1)), :);
        
        % Loop over the sets of aligned axes:
        for i3 = 1:size(axsAligned, 1)
            
            aux_axsAligned = axsAligned{i3, 1};
            aux_axsInds = axsAligned{i3, 2};
            
            [~, indSorted] = sort(aux_axsAligned(:, sortind(i2)));
            
            % Loop over axes in the "interior" and remove Tick Labels:
            for i4 = 2:length(indSorted)
                onlyAxes(aux_axsInds(indSorted(i4))).(workOn{i2}) = [];
            end
            
        end
        
    end
    
    
end

