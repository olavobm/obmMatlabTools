function structout = subsetStruct(indvarcell, indvarlims, structvar, varcell, lrm)
% structout = SUBSETSTRUCT(indvarcell, indvarlims, structvar, varcell, lrm)
%
%   inputs
%       - indvarcell: cell array with independent variable names.
%       - indvarlims: Nx2 array with limits of the independent variables.
%       - structvar: structure with (at least) the independent variables
%                    (indvarcell) and the dependent variables (varcell)
%                    to subset.
%       - varcell: cell array with dependent variables to subset.
%       - lrm (optional): logical variable (default is false). If true,
%                         remove all fields not specified in either
%                         indvarcell or varcell.
%
%   outputs
%       - structout: subsetted structure variable.
%
% SUBSETSTRUCT subsets multiple fields of structvar. Suppose you have
% lots of variables (fields of the structure structvar) that are
% functions of time and you want to subset them between two specific
% dates. The name of the time variable should go in indvarcell, the
% date limits in indvarlims and the dependent variable names in varcell.
%
%
% TO DO:
%   - for a square matrix, I need to specify both independent variables
%     because of my solution to subset vectors that are row or column
%     I should fix this.
%   - Maybe my idea previous does not exist anymore, and iloop
%     shouldn't exist.
%   - when I flipped the independent variable order in the input,
%     having a matrix and vectors, nothing was subsetted and there
%     was no error/warning message.
%
% Olavo Badaro Marques, 13/Mar/2017.


%% If first variable is a string, turn it into a cell array

if ~exist('indvarcell', 'var')
    indvarcell = {indvarcell};
end


%% If lrm is not given as input, choose default value

if ~exist('lrm', 'var')
    lrm = false;
end


%% If input varcell is not given, then assign all fieldnames
% of structvar to it, except those in indvarcell. All fields
% with dimensions consistent with indvarcell will be subsetted

if ~exist('varcell', 'var')
    
    varcell = fieldnames(structvar);
    varcell = setdiff(varcell, indvarcell);

end


%% Check if first 2 inputs are consistent (among each other)
% and determine which dimensions are subsetted (this is not
% quite true for vectors, which are 1D but can be either
% row or column vectors)

if length(indvarcell) ~= size(indvarlims, 1)
    error('')
else
    
    if sum(~cellfun(@isempty, indvarcell))~=sum(~isnan(sum(indvarlims, 2)))
        error('')
        
    else
        
        indsubsetdims = find(~cellfun(@isempty, indvarcell));
        nindvar = length(indsubsetdims);   % not used
        
    end
    
    
end


%% Remove from varcell the fields that do not have any dimension
% of same length as one of the independent variables in indvarcell
%
% maybe I should only run if varcell is not given in input

% Create logical variable (which is updated in the loop below) where
% true indicates the subset of variables that will be subsetted:
Nfields = length(varcell);
lkeepvar = false(1, Nfields);

% Loop over dimensions to subset:
for i1 = 1:nindvar
        
    % Logical array to see if the Nfields variables have a
    % dimension consistent with the i1'th independent variable:
    lkeepvaraux = false(1, Nfields);
    
    % 
    iloop = indsubsetdims(i1);
    
    % Length of the i1'th independent variable to subset:
    lenindvar = length(structvar.(indvarcell{iloop}));
    
    % Loop over elements of varcell:
    for i2 = 1:Nfields
        
        % Size of the variable named varcell(i2):
        i2thvarsize = size(structvar.(varcell{i2}));
        
        %
        if ismember(lenindvar, i2thvarsize)
            lkeepvaraux(i2) = true;
        end
        % -----------------------------------------------------------------
        % Instead of the above (ismember), maybe it should match the length
        % at the a single dimension. But maybe not
        % -----------------------------------------------------------------
    end
    
    %
    lkeepvar = (lkeepvar | lkeepvaraux);

end

% Keep only variables with at least one dimension
% consistent with dimensions to be subsetted:
varcell = varcell(lkeepvar);


%% Create logical array (lsubsetcell) with the
% subset regions for all independent variables

% Pre-allocate space:
lsubsetcell = cell(1, length(indvarcell));

subsetdimslen = NaN(1, nindvar);

structout = structvar;

% Loop over independent variables:
for i1 = 1:nindvar
    
    indloop = indsubsetdims(i1);
    
    % this should be a vector...
    lauxsubset = structvar.(indvarcell{indloop}) >= indvarlims(indloop, 1) & ...
                 structvar.(indvarcell{indloop}) <= indvarlims(indloop, 2);
    
	%
    structout.(indvarcell{indloop}) = structvar.(indvarcell{indloop})(lauxsubset);
             
	%
	lsubsetcell{indloop} = lauxsubset;

    %
    subsetdimslen(indloop) = sum(lauxsubset);
    
end


%% Subset dependent variables one at a time

% Loop over variables to be subsetted:
for i1 = 1:length(varcell)
    
    varsize = size(structvar.(varcell{i1}));
    varnumel = prod(varsize);    % same as numel(structvar.(varcell{1}))

    lsubset = true(varnumel, 1);
    
    %
    subsettedsize = varsize;
    
    % Loop over independent variables, such that we can see in which
    % of those we need to subset the i1'th dependent variable:
    for i2 = 1:nindvar
    
        %
        if length(indvarcell)==1
            
            indloop = 1;
            
%             lmatchlen = (indsubsetdims(i1) == varsize);

            lmatchlen = (length(structvar.(indvarcell{1})) == varsize);
            
            if ~any(lmatchlen)
                error('.')   % maybe this can never happen
            else
                
                if sum(lmatchlen)>1
                    error('At least 2 dimensions have the same length.')
                else
                    
                    % Number of the dimension to subset:
                    dimsubset = find(lmatchlen);
                end
                
            end
            
        else
            
            indloop = indsubsetdims(i2);
            
            dimsubset = indloop;
            
        end

        %
        if length(indvarcell)>1 && length(lsubsetcell{indloop})~=varsize(dimsubset)
            

            continue    % not great to use this, just because it does
                        % not look good, in terms of syntax.
            
        end
        
        %
        subsettedsize(dimsubset) = subsetdimslen(indloop);
        
        %
        lauxsubset = lsubsetcell{indloop};
        
        %
        dimvec = ones(1, length(varsize));
        dimvec(dimsubset) = length(lauxsubset);


        lauxsubset = reshape(lauxsubset, dimvec);

        %
        repsize = varsize;
        repsize(dimsubset) = 1;

        lauxsubset = repmat(lauxsubset, repsize);

        
        lsubset = (lsubset & lauxsubset(:));
        
    end
    
    %% Finally subset the i1'th dependent variable
    
    % Subset dependent variable:
	structout.(varcell{i1}) = structvar.(varcell{i1})(lsubset);

    % Put the variable back to its original size:
    structout.(varcell{i1}) = reshape(structout.(varcell{i1}), subsettedsize);
        
end


%% If lrm is true, remove fields that are not subsetted

if lrm
    
    allstructfields = fieldnames(structout);
    
    for i = 1:length(allstructfields)
        
        if ~(ismember(allstructfields{i}, indvarcell) || ismember(allstructfields{i}, varcell))
            
            structout = rmfield(structout, allstructfields{i});
        end
        
    end
    
end

