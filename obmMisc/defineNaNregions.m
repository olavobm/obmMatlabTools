function regionsNaN = defineNaNregions(lNaN)
% = DEFINENANREGIONS(lNaN)
%
%   inputs:
%       - lNaN:
%
%   outputs:
%       - regionsNaN: sets of regions.
%       - boundary of regions.
%
% or indNaN should probably be a logical matrix!
%
% Olavo Badaro Marques, 16/Feb/2017.


%%

matrixSize = size(lNaN);

%%

yvec = 1:matrixSize(1);
xvec = 1:matrixSize(2);

[xg, yg] = meshgrid(xvec, yvec);


%%

indNaN = find(lNaN);

[irowsNaN, jcolsNaN] = ind2sub(matrixSize, indNaN);

subNaN = [irowsNaN, jcolsNaN];

indRowsUniq = sort(unique(irowsNaN));
indColsUniq = sort(unique(jcolsNaN));


%% Pre-allocate space:


%%

n = length(indNaN);

regionsNaN = cell(1, n);
indNextRegion = 1;

activeRegionsLims = NaN(4, 10);  % can be a 4xN array / IT COULD PROBABLE BE 2XN ONLY (BECAUSE I PROBABLY ONLY NEED THE COLUMN INDICES HERE)
activeRegions = cell(1, 10);
nActiveR = 0;


%% Loop over all rows with NaNs:

for i1 = 1:length(indRowsUniq)
    
    
    rowi1 = indRowsUniq(i1);
    
    if i1>1
        previouRow = indRowsUniq(i1 - 1);
    else
        previouRow = rowi1;
    end
    
    
    % ----------------------------------------------------------------
    % if i1 jumps more than 1, then I have closed active regions
    % ----------------------------------------------------------------

    %% Get all column indices of NaNs on row rowi1:
    alli1NaNcols = subNaN(subNaN(:, 1) == indRowsUniq(i1), 2);

    alli1NaNcols = sort(alli1NaNcols);

    colsDiff = diff(alli1NaNcols);

%     seti1thRow = cell(1, length(xvec)/2);

%     % In the case of only one NaN:
%     if isempty(colsDiff)
%         colsDiff = 1;   % just so it matches (for sure the if case below)
%     end

    %% Check whether there is a continuous sequence or
    % multiple sets of NaNs on this row:
    
    if isempty(colsDiff)

            seti1thRow = {[rowi1, alli1NaNcols(1)]};
        
    else
        if all(colsDiff==1)

            % they belong to the same set

            thisset = [rowi1, alli1NaNcols(1) ; ...
                       rowi1, alli1NaNcols(end)];
            seti1thRow = {thisset};

        else


            inddiffset = find(colsDiff > 1);
            nSetsOnRowi1 = length(inddiffset) + 1;

            seti1thRow = cell(1, nSetsOnRowi1);

            indstart = 1;

            for i2 = 1:(nSetsOnRowi1-1)

                indRowAux = repmat(rowi1, length(alli1NaNcols(indstart:inddiffset(i2))), 1);

                seti1thRow{i2} = [indRowAux, alli1NaNcols(indstart:inddiffset(i2))];
                % or I could use ([indstart, inddiffset(i2)]), which
                % is what I really want

                indstart = inddiffset(i2) + 1;
            end

            % Add the last set, which is not handled by the loop above:
            indRowAux = repmat(rowi1, length(alli1NaNcols(indstart:end)), 1);
            seti1thRow{i2 + 1} = [indRowAux, alli1NaNcols(indstart:end)];

            % Remove unwated empty elements of the cell array:
            seti1thRow = seti1thRow(~cellfun(@isempty, seti1thRow));

        end
    end
    
    
    %% If the rowi1 is not immediately below previouRow, it means
    % all the current activeRegions should be terminated
    
    if (rowi1 - previouRow) > 1
        
        % Set all to false:
        checkActive(1:nActiveR) = false;
        lTerminate = ~checkActive(1:nActiveR);
        
        indNextRegion_last = indNextRegion + sum(lTerminate) - 1;

        % Assign to output array:
        regionsNaN(indNextRegion : indNextRegion_last) = ...
                                           activeRegions(lTerminate);

        % Initialize new activeRegions and activeRegionsLims arrays:
        activeRegions = cell(1, 10);
        activeRegionsLims = NaN(4, 10);
        
        nActiveR = 0;

        % Update index:
        indNextRegion = indNextRegion_last + 1;
        
    end

    %% Check NaN sets on row rowi1 with current activeRegions

    % not only ==1, but also if we should start a new active region!
    if isempty(activeRegions{1})

        activeRegions(1:length(seti1thRow)) = seti1thRow;

        for i2 = 1:length(seti1thRow)

            % Coordinates of the LEFT limit of the i2th row set:
            activeRegionsLims(1, i2) = activeRegions{i2}(1, 1);
            activeRegionsLims(2, i2) = activeRegions{i2}(1, 2);

            % Coordinates of the RIGHT limit of the i2th row set:
            activeRegionsLims(3, i2) = activeRegions{i2}(end, 1);
            activeRegionsLims(4, i2) = activeRegions{i2}(end, 2);
        end

        nActiveR = length(seti1thRow);

        checkActive(1:nActiveR) = true;

    else
        %% Loop over all NaNs sets and check
        % whether they belong to activeRegions:
        checkActive = false(1, length(~isnan(activeRegionsLims(2, :))));

        for i2 = 1:length(seti1thRow)

            % sameSet is true when the largest column is greater than min
            % and smallest is less than max:
            sameSet = seti1thRow{i2}(end, 2) >= (activeRegionsLims(2, :)-1) & ...
                      seti1thRow{i2}(1, 2) <= (activeRegionsLims(4, :)+1);


            nMatch = length(sameSet(sameSet));

%             keyboard
            % Does not match with any of the active -- create new active
            if nMatch == 0

                nActiveR = nActiveR + 1;

                activeRegions(nActiveR) = seti1thRow(i2);

                activeRegionsLims(1, nActiveR) = seti1thRow{i2}(1, 1);
                activeRegionsLims(2, nActiveR) = seti1thRow{i2}(1, 2);
                activeRegionsLims(3, nActiveR) = seti1thRow{i2}(end, 1);
                activeRegionsLims(4, nActiveR) = seti1thRow{i2}(end, 2);

                % except that I do not need to compare the next sets
                % on this row with this newly activeRegion

%                 keyboard

            % Matches with one active region, simple concatenation
            elseif nMatch == 1

%                 keyboard
                activeRegions{sameSet} = [activeRegions{sameSet}; ...
                                          seti1thRow{i2}];                      

%                 activeRegionsLims(1, sameSet) = min(activeRegions{sameSet}(:, 1));
                activeRegionsLims(2, sameSet) = min(activeRegions{sameSet}(:, 2));
%                 activeRegionsLims(3, sameSet) = min(activeRegions{sameSet}(:, 1));
                activeRegionsLims(4, sameSet) = max(activeRegions{sameSet}(:, 2));                   

                % Says it is still active
                checkActive(sameSet) = true;

                keyboard

            % Matches with more than one, concatenate and merge regions:
            else

                checkActive(sameSet) = true;

                indsSame = find(sameSet);
                indMerge = indsSame(1);
                indErase = indsSame(2:end);

                keyboard
                
                mergeaux = activeRegions(sameSet);
                mergeaux = mergeaux(:);

                keyboard
                
                mergeaux = [mergeaux{:}];

                keyboard
                
                activeRegions{indMerge} = mergeaux;
                activeRegions(indErase) = cell(1, length(indErase));

                keyboard
                activeRegions{sameSet} = [activeRegions{sameSet}; ...
                                          seti1thRow{i2}];

                % Update column indices:
                activeRegionsLims(2, sameSet) = min(activeRegions{sameSet}(:, 2));
                activeRegionsLims(4, sameSet) = max(activeRegions{sameSet}(:, 2)); 

                % Decrease number of active regions because of the merge:
                nActiveR = nActiveR - (nMatch - 1);


                % HOW ABOUT IF THE MERGING IS IN SAW TOOTH??? LIKE
                %
                %  -   NAN  NAN  -   -
                % NAN  NAN   -  NAN NAN
                %
                % I ONLY HAVE ONE SET ABOVE, BUT THE SECOND SET ON ITH ROW
                % WILL ONLY BE IDENTIFIED LATER AS PARTE OF THE BIG SET

            end
        end

    end
    

    
    %% Check whether there are activeRegions with no matching NaNs
    % In this case, terminate its "activity" and pass to final output:


    if i1<length(indRowsUniq)

        lTerminate = ~checkActive(1:nActiveR);

%             indTerminate = find(~checkActive(1:nActiveR));

    else  % last iteration over i1 -- pass all activeRegions to output

        lTerminate = checkActive(1:nActiveR);

    end

    if any(lTerminate)

        indNextRegion_last = indNextRegion + sum(lTerminate) - 1;

        % Assign to output array:
        regionsNaN(indNextRegion : indNextRegion_last) = ...
                                           activeRegions(lTerminate);

        % Remove terminated active regions - THIS SCREWS UP THE PRE-ALLOCATION!:
        activeRegions = activeRegions(~lTerminate);
        activeRegionsLims = activeRegionsLims(:, ~lTerminate);

        nActiveR = length(activeRegions);

        % Update index:
        indNextRegion = indNextRegion_last + 1;

    end

    % lterminate = ~checkActive (EXCEPT I HAVE TO BE
    % CAREFUL WITH THE RESIZING)
    
    
    % --------------------------------------------
    % remove activeRegions that are not active anymore.
    
    % 1 - loop through the sets in seti1thRow
    % 2 - loop through the existing sets in the previous row
    % 3 - match the indices
    % 4 - merge sets if necessary.
    
end


%% Remove empty elements of the output cell:

regionsNaN = regionsNaN(~cellfun(@isempty, regionsNaN));




