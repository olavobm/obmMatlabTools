function [colsets, rnansets] = sepColsNanPos(x)
%
%   inputs:
%       - x: matrix
%
%   outputs:
%       - colsets: cell array with the column indices of each set....
%
% Function SEPCOLSNANPOS
%
% I COULD ALSO TRY TO GET ALL THE RNANSETS AND THEN COMPARE THEM, BUT I'M
% SKEPTICAL OF THAT, BUT I SHOULD TEST THIS FOR SURE, BECAUSE THIS MIGHT BE
% THE THING!!! THERE IS FOR SURE A WAY TO FIX IT.
%
% Olavo Badaro Marques, 21/Nov/2016.


%%
allcols = 1:size(x, 2);

indnan = find(isnan(x));
            
[rnan, cnan] = ind2sub(size(x), indnan);
             

cnanUniq = unique(cnan);

cnanUniqCopy = cnanUniq;


%%
% Pre-allocate (likely extra) space:
colsets = cell(1, length(cnanUniq));
rnansets = cell(1, length(cnanUniq));

indfill = 1;

while length(cnanUniqCopy)>1
    
    caux = cnanUniqCopy(1);
    raux = rnan(cnan==caux);
    
    % This change increases only a tiny little bit of efficiency...
    
%     colsets{indfill} = [colsets{indfill}, caux];    
    colsets_aux = cell(1, length(cnanUniqCopy));
    colsets_aux{1} = caux;
    
    for i = 2:length(cnanUniqCopy)
        
        if isequal(raux, rnan(cnan==cnanUniqCopy(i)))
            
%             colsets{indfill} = [colsets{indfill}, cnanUniqCopy(i)];
            
            colsets_aux{i} = cnanUniqCopy(i);
        end
    end
    
    colsets{indfill} = [colsets_aux{:}];
    rnansets{indfill} = raux;
    
    cnanUniqCopy = setdiff(cnanUniqCopy, colsets{indfill});
    indfill = indfill + 1;
    
    % Print message to the screen:
%     disp(['There are ' num2str(length(cnanUniqCopy)) ' columns remaining'])
    
end

if length(cnanUniqCopy)==1
    colsets{indfill} = [colsets{indfill}, cnanUniqCopy];
    indfill = indfill + 1;
end


%% Get rid of empty columns at the end:
colsets_aux = colsets(1:(indfill-1));

rnansets = rnansets(1:(indfill-1));

% should work the same as colsets = colsets(~ismepty(colsets))
if ~isequal(colsets_aux, colsets(~cellfun(@isempty, colsets)))
    error('Function sepColsNanPos has unexpected error.')
end

colsets = colsets_aux;


%% Add column indices of the columns with no NaNs (if all
% columns have NaNs, it adds an empty vector, which does
% not change colsets):

% mus also change rnansets!!!

colsets = [setdiff(allcols, cnanUniq), colsets];
