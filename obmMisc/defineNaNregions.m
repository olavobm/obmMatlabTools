function regionsNaN = defineNaNregions(lNaN)
% regionsNaN = DEFINENANREGIONS(lNaN)
%
%   inputs:
%       - lNaN: logical array, where true represents locations with NaNs.
%
%   outputs:
%       - regionsNaN: sets of regions.
%
% DEFINENANREGIONS
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
    

    %% Get all column indices of NaNs on row rowi1:
    alli1NaNcols = subNaN(subNaN(:, 1) == indRowsUniq(i1), 2);

    alli1NaNcols = sort(alli1NaNcols);

    colsDiff = diff(alli1NaNcols);

%     seti1thRow = cell(1, length(xvec)/2);   % pre-allocation???


    %% Check whether there is a continuous sequence or
    % multiple sets of NaNs on this row:
    
    
    if isempty(colsDiff)
        % Only 1 NaN in rowi1:
        seti1thRow = {[rowi1, alli1NaNcols(1)]};
        
    else
        if all(colsDiff==1)

            % they belong to the same set

            % % THIS IS DIFFERENT THAN THE ELSE BELOW. THE ELSE BELOW GETS
            % % ALL THE POINTS, WHEREAS HERE I TAKE ONLY THE LIMITS!!!!
%             thisset = [rowi1, alli1NaNcols(1) ; ...
%                        rowi1, alli1NaNcols(end)];
                   
            % Same as else below:
            thisset = [repmat(rowi1, length(alli1NaNcols), 1), alli1NaNcols];
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
                % is what I really want. The question is whether keeping
                % all the points is a big problem or if I can easily
                % reconstruct the region from the boundaries.

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

        % I'm pretty sure this i2 will also be wrong...
        
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
        
%         checkActive = [checkActive(checkActive), false(1, length(~isnan(activeRegionsLims(2, :))))];
        checkActive = false(1, length(~isnan(activeRegionsLims(2, :))));

%         if rowi1==5
%             keyboard
%         end
        
        for i2 = 1:length(seti1thRow)

            % sameSet is true when the largest column is greater than min
            % and smallest is less than max:
            sameSet = seti1thRow{i2}(end, 2) >= (activeRegionsLims(2, :)-1) & ...
                      seti1thRow{i2}(1, 2) <= (activeRegionsLims(4, :)+1);

            % ------------------------------------
            
            % ------------------------------------
                  
            % I HAVE TO DO THE COMPARISON ABOVE FOR SUBSEQUENT
            % ROWS!!! EXCEPT THAT activeRegionsLims ONLY KEEPS THE LIMITS
            % WHAT CAN I DO ????????????? I WOULD HAVE TO LOOP OVER
            % SETI0THROW SORT OF THING...
                  
            nMatch = length(sameSet(sameSet));

%             if rowi1==5
%                 keyboard
%             end
            
            % Does not match with any of the active -- create new active
            if nMatch == 0

                nActiveR = nActiveR + 1;

                activeRegions(nActiveR) = seti1thRow(i2);

                activeRegionsLims(1, nActiveR) = seti1thRow{i2}(1, 1);
                activeRegionsLims(2, nActiveR) = seti1thRow{i2}(1, 2);
                activeRegionsLims(3, nActiveR) = seti1thRow{i2}(end, 1);
                activeRegionsLims(4, nActiveR) = seti1thRow{i2}(end, 2);

                checkActive(nActiveR) = true;
                
                % EXCEPT THAT I DO NOT NEED TO COMPARE THE NEXT SETS
                % ON THIS ROW WITH THIS NEWLY ACTIVEREGION. THIS IS
                % SOMETHING THAT I MAY WANT TO OPTIMIZE, BUT PROBABLY NOT
                % VERY IMPORANT FOR MY APPLICATIONS.

%                 keyboard
            % Matches with one active region, simple concatenation
            elseif nMatch == 1

                activeRegions{sameSet} = [activeRegions{sameSet}; ...
                                          seti1thRow{i2}];                      

% %                 activeRegionsLims(1, sameSet) = min(activeRegions{sameSet}(:, 1));
%                 activeRegionsLims(2, sameSet) = min(activeRegions{sameSet}(:, 2));
% %                 activeRegionsLims(3, sameSet) = min(activeRegions{sameSet}(:, 1));
%                 activeRegionsLims(4, sameSet) = max(activeRegions{sameSet}(:, 2));

%                 activeRegionsLims(2, sameSet) = min(activeRegions{sameSet}(:, 2));
%                 activeRegionsLims(4, sameSet) = max(activeRegions{sameSet}(:, 2));
                
                % Says it is still active
                checkActive(sameSet) = true;
%                 if rowi1==5
%                     keyboard
%                 end

            % Matches with more than one, concatenate and merge regions:
            % I SHOULD MERGE AT THE THE END, NOT WITHIN THIS LOOP!
            else

                checkActive(sameSet) = true;

                indsSame = find(sameSet);
                indMerge = indsSame(1);
                indErase = indsSame(2:end);
                
                mergeaux = activeRegions(sameSet);
                mergeaux = mergeaux(:);
                
                mergeaux = cat(1, mergeaux{:});

                
                activeRegions{indMerge} = mergeaux;
                activeRegions(indErase) = cell(1, length(indErase));

                activeRegions{indMerge} = [activeRegions{sameSet}; ...
                                           seti1thRow{i2}];

                %
                activeRegionsLims(:, indErase) = NaN;
                
                % Update column indices:
                activeRegionsLims(2, indMerge) = min(activeRegions{indMerge}(:, 2));
                activeRegionsLims(4, indMerge) = max(activeRegions{indMerge}(:, 2)); 

                % Decrease number of active regions because of the merge:
                nActiveR = nActiveR - (nMatch - 1);

                keyboard
                % HOW ABOUT IF THE MERGING IS IN SAW TOOTH??? LIKE
                %
                %  -   NAN  NAN  -   -
                % NAN  NAN   -  NAN NAN
                %
                % I ONLY HAVE ONE SET ABOVE, BUT THE SECOND SET ON ITH ROW
                % WILL ONLY BE IDENTIFIED LATER AS PARTE OF THE BIG SET

            end
            
        end

        % create new NxN by array 
        
    end
    
    
    %% Update activeRegionsLims only where checkActive is true:
      
%     lcurrentRow = activeRegions{1} == max(activeRegions{1}(:, 1));
    
    % THIS DOES NOT WORK THOUGH .... I MUST USE ALL
    % COLUMN INDICES RATHER THAN JUST MIN AND MAX!!

    for i2 = 1:nActiveR
        
        if checkActive(i2)
                        
            lrowi1 = (activeRegions{i2}(:, 1) == rowi1);
        
            activeRegionsLims(2, i2) = min(activeRegions{i2}(lrowi1, 2));
            activeRegionsLims(4, i2) = max(activeRegions{i2}(lrowi1, 2));
            
        end
    end

 
    %% Check whether there are activeRegions with no matching NaNs
    % In this case, terminate its "activity" and pass to final output:


    if i1<length(indRowsUniq)

%         keyboard
        lTerminate = ~checkActive(1:nActiveR);

%             indTerminate = find(~checkActive(1:nActiveR));

    else  % last iteration over i1 -- pass all activeRegions to output

%         lTerminate = checkActive(1:nActiveR);
        lTerminate = true(1, nActiveR);

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

    
end


%% Remove empty elements of the output cell:

regionsNaN = regionsNaN(~cellfun(@isempty, regionsNaN));




