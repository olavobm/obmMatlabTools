function structout = subsetStruct(indvarcell, indvarlims, structvar, varcell, lrm)
% structout = SUBSETSTRUCT(indvarcell, indvarlims, structvar, varcell)
%
%   inputs:
%       - indvarcell: cell array with independent variable names.
%       - indvarlims: Nx2 array with limits of the independent variables.
%       - structvar: structure
%       - varcell: cell array with dependent variables to subset.
%       - lrm (optional): logical variable (default is false). If true,
%                         remove all fields not specified in either
%                         indvarcell or varcell.
%
%   outputs:
%       - structout: subsetted structure variable.
%
%
%
% Olavo Badaro Marques, 13/Mar/2017.


%% If lrm is not given as input, choose default value:

if ~exist('lrm', 'var')
    lrm = false;
end


%% Check if first 2 inputs are consistent (among each other)
% and determine which dimensions are subsetted (this is not
% quite true for variables, which are 1D but can be either
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


%% Subset independent variables and create an
% appropriate logical vector (lsubset) to
% subset the dependent variables:

varsize = size(structvar.(varcell{1}));
varnumel = prod(varsize);    % same as numel(structvar.(varcell{1}))

lsubset = true(varnumel, 1);

subsetdimslen = ones(1, length(varsize));

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

