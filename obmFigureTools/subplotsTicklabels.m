function subplotsTicklabels(rmlabel, hfig)
% SUBPLOTSTICKLABELS(rmlabel, hfig)
%
%   inputs:
%       - hfig: vector of figure handles or numbers.
%
% Olavo Badaro Marques, 04/May/2017.


%%

if nargin==0
    rmlabel = 'xy';
end

nAxs = 0;
posind = NaN(1, 2);

if ~isempty(strfind(rmlabel, 'x'))
    nAxs = nAxs + 1;
    posind(nAxs) = 1;
end

if ~isempty(strfind(rmlabel, 'y'))
    nAxs = nAxs + 1;
    posind(nAxs) = 2;
end

posind = posind(~isnan(posind));


%% If there is no input, assign current figure handle by default:

if ~exist('hfig', 'var')
    hfig = gcf;
end


%% Loop over figure handles:

for i = 1:length(hfig)
    
    
    %% Find all

    allAxes = findall(hfig(i), 'Type', 'axes');

    onlyAxes = allAxes(~ismember(get(allAxes, 'Tag'), {'legend', 'Colobar'}));

    % if there are other objects in allAxes that are not axes, legend or
    % Colorbar, than I might have problems. I could add a check.
    %
    % I might want to look at the class name of the variables
    % matlab.graphics.axis.Axes
    
    N = length(onlyAxes);

    %%
    allPos = [onlyAxes.Position];
    
    allPos = reshape(allPos, 4, N);
    
    allPos = allPos';
    
    
    
    %%
    for i2 = 1:nAxs
    
        axsAligned = cell(N, 1);
        
        aux_allPos = allPos;
        
        rAligned = 0;
         
        while ~isempty(aux_allPos)
            
            lmatch = (aux_allPos(:, posind(i2)) == aux_allPos(1, posind(i2)));
            
            if length(find(lmatch))>1
                
                rAligned = rAligned + 1;
            
                axsAligned{rAligned} = aux_allPos(lmatch, :);
            end
            
            aux_allPos = aux_allPos(~lmatch, :);
            
        end
        
        keyboard
        
        
        
    end
    
    
    
    
end

