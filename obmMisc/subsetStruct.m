function structout = subsetStruct(indvarcell, indvarlims, structvar, varcell, lrm)
% structout = SUBSETSTRUCT(indvarcell, indvarlims, structvar, varcell)
%
%   inputs:
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
%   outputs:
%       - structout: subsetted structure variable.
%
% SUBSETSTRUCT subsets multiple fields of structvar. Suppose you have
% lots of variables (fields of the structure structvar) that are
% functions of time and you want to subset them between two specific
% dates. The name of the time variable should go in indvarcell, the
% date limits in indvarlims and the dependent variable names in varcell.
%
% Should explain about higher dimensions...
%
% FOR A MATRIX, DO I NEED TO SPECIFY BOTH INDEPENDENT VARIABLES??????????
% IT LOOKS THAT I DO NEED. IT SHOULDN'T BE NECESSARY, BUT IT IS TRICKY!!!
% WOULD BE TO NICE GET AROUND THIS SO WE CAN DEAL WITH ROW VECTORS.
%
% ONE THING I CAN DO (AND IT IS FAIRLY SIMPLE) IS, WHEN indvarcell HAS ONLY
% ONE ELEMENT, I CAN FOR EACH VARIABLE TO SUBSET FIND WHICH DIMENSION HAS
% THE SAME LENGTH AS THE INDEPENDENT VARIABLE (IF MORE THAN ONE DIMENSION
% HAVE THE SAME LENGTH, SHOULD GIVE A WARNING OR ERROR).
%
%
% Olavo Badaro Marques, 13/Mar/2017.


%% If lrm is not given as input, choose default value:

if ~exist('lrm', 'var')
    lrm = false;
end


%% If input varcell is not given, then assign all fieldnames
% of structvar to it, except those in indvarcell. All fields
% with dimensions consistent with indvarcell will be subsetted:

if ~exist('varcell', 'var')
    
    varcell = fieldnames(structvar);
    varcell = setdiff(varcell, indvarcell);

end


%% Check if first 2 inputs are consistent (among each other)
% and determine which dimensions are subsetted (this is not
% quite true for vectors, which are 1D but can be either
% row or column vectors):

if length(indvarcell) ~= size(indvarlims, 1)
    error('')
else
    
    if sum(~cellfun(@isempty, indvarcell))~=sum(~isnan(sum(indvarlims, 2)))
        error('')
        
    else
        
        indsubsetdims = find(~cellfun(@isempty, indvarcell));
%         nindvar = length(indsubsetdims);   % not used
        
    end
    
    
end


%% Remove from varcell the variables 

% maybe I should only run if varcell is not given in input

%
Nfields = length(varcell);
lkeepvar = false(1, Nfields);

for i = 1:length(indsubsetdims)
        
    %
    lkeepvaraux = false(1, Nfields);
    
    %
    iloop = indsubsetdims(i);
    
    for i2 = 1:Nfields
        
        %
        lenindvar = length(structvar.(indvarcell{iloop}));
        
        i2thvarsize = size(structvar.(varcell{i2}));
        
        %
        if ismember(lenindvar, i2thvarsize)
%             lkeepvar(i2) = false;
            lkeepvaraux(i2) = true;
        end
        % -----------------------------------------------------------------
        % Instead of the above (ismember), maybe it should match the length
        % at the a single dimension. need to put some thought on that
        % -----------------------------------------------------------------
    end
    
    %
    lkeepvar = (lkeepvar | lkeepvaraux);

end

%
varcell = varcell(lkeepvar);


%%


% I SHOULD CHANGE THE LOGIC OF THE SUBSETTING BELOW.
% IT SHOULD BE SOMETHING LIKE:
%           - LOOP OVER INDVARCELL
%           - FIND LOGICAL VECTOR FOR SUBSETTING ALONG THAT DIMENSION
%           - LOOP OVER DEPENDENT VARIABLES TO BE SUBSETTED.
%           - RESIZE VECTOR TO BE A N-DIMENSIONAL LOGICAL ARRAY
%             CONSISTENT WITH THE DEPENDENT VARIABLE.
%           - SUBSET AND CONTINUE FROM THE TOP.
%
% THIS IS MORE INTENSIVE THAN WHAT I PREVIOUSLY HAD, BUT WORKS
% FOR MULTIPLE VARIABLES WITH DIFFERENTE SIZES.


%%

lsubsetcell = cell(1, length(indvarcell));

subsetdimslen = NaN(1, length(indsubsetdims));

structout = structvar;

%
for i1 = 1:length(indsubsetdims)
    
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


% I SHOULD BE ABLE TO SUBSET MATRICES IN BOTH ROWS AND COLUMNS,
% BUT ONLY COLUMNS IF VARCELL{I2} IS A VECTOR!!!!!!!

for i2 = 1:length(varcell)
    
    varsize = size(structvar.(varcell{i2}));
    varnumel = prod(varsize);    % same as numel(structvar.(varcell{1}))

    lsubset = true(varnumel, 1);
    
    %
    subsettedsize = varsize;
    
    %
    for i1 = 1:length(indsubsetdims)
    
        % ---------------------------------------------------------------
        % I NEED SOMEHOW TO DEAL WITH A VARIABLE THAT IS NOT SUBSETTED IN ALL
        % DIMENSIONS THAT A MORE "COMPLETE" DEPENDENT VARIABLE IS SUBSETTED
        % ---------------------------------------------------------------
    
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
            
            indloop = indsubsetdims(i1);
            
            dimsubset = indloop;
            
        end

%         keyboard
        if length(indvarcell)>1 && length(lsubsetcell{indloop})~=varsize(dimsubset)
            
%             keyboard
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
    
    % -------------------------------------------------------
    % Subset dependent variable:
	structout.(varcell{i2}) = structvar.(varcell{i2})(lsubset);

    % Put the variable back to its original size:
    structout.(varcell{i2}) = reshape(structout.(varcell{i2}), subsettedsize);
        
end

keyboard


%% Subset independent variables and create an appropriate
% logical vector (lsubset) to subset the dependent variables:

varsize = size(structvar.(varcell{1}));   % I ASSUME SAME SIZE FOR ALL DEPENDENT VARIABLES
varnumel = prod(varsize);    % same as numel(structvar.(varcell{1}))

lsubset = true(varnumel, 1);

% subsetdimslen = ones(1, length(varsize));
subsetdimslen = varsize;

structout = structvar;

for i = 1:length(indsubsetdims)
    
    indloop = indsubsetdims(i);
    
    % this should be a vector...
    lauxsubset = structvar.(indvarcell{indloop}) >= indvarlims(indloop, 1) & ...
                 structvar.(indvarcell{indloop}) <= indvarlims(indloop, 2);
                      
	subsetdimslen(indloop) = sum(lauxsubset);
         
    %
    structout.(indvarcell{indloop}) = structvar.(indvarcell{indloop})(lauxsubset);
    
    % necessary for 2D or higher dimensions..
    if numel(lauxsubset)~=varnumel
        
        %
        dimvec = ones(1, length(varsize));
        dimvec(indloop) = length(lauxsubset);
        
        
        lauxsubset = reshape(lauxsubset, dimvec);
        
        %
        repsize = varsize;
        repsize(indloop) = 1;
        
        lauxsubset = repmat(lauxsubset, repsize);
        
    end
    
    %
    lsubset = (lsubset & lauxsubset(:));
                 
end


%% Subset dependent variables:

for i = 1:length(varcell)
    
    structout.(varcell{i}) = structvar.(varcell{i})(lsubset);
    
    structout.(varcell{i}) = reshape(structout.(varcell{i}), subsetdimslen);

end


%% If lrm is true, remove fields that are not subsetted:

if lrm
    
    allstructfields = fieldnames(structout);
    
    for i = 1:length(allstructfields)
        
        if ~(ismember(allstructfields{i}, indvarcell) || ismember(allstructfields{i}, varcell))
            
            structout = rmfield(structout, allstructfields{i});
        end
        
    end
    
end

