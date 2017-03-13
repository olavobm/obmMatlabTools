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


%%

if ~exist('lrm', 'var')
    lrm = false;
end


%%

if length(indvarcell) ~= size(indvarlims, 1)
    error('')
else
    nindvar = length(indvarcell);
end

varsize = size(structvar.(varcell{1}));
varnumel = prod(varsize);    % same as numel(structvar.(varcell{1}))

% WHAT ABOUT ROW/COLUMN VECTORS??? BOTH ARE 1D.....

lsubset = true(varnumel, 1);

subsetdimslen = ones(1, length(varsize));

structout = structvar;

for i = 1:nindvar
    
    % this should be a vector...
    lauxsubset = structvar.(indvarcell{i}) >= indvarlims(i, 1) & ...
                 structvar.(indvarcell{i}) <= indvarlims(i, 2);
                      
	subsetdimslen(i) = sum(lauxsubset);
         
    % necessary for 2D or higher dimensions..
    if numel(lauxsubset)~=varnumel
        
        
        
    end
    
    
    %
    structout.(indvarcell{i}) = structvar.(indvarcell{i})(lauxsubset);
    
    %
    lsubset = (lsubset & lauxsubset(:));
                 
end


%%

for i = 1:length(varcell)
    
    structout.(varcell{i}) = structvar.(varcell{i})(lsubset);

    structout.(varcell{i}) = reshape(structout.(varcell{i}), subsetdimslen);
end


%%

if lrm
    
    allstructfields = fieldnames(structout);
    
    for i = 1:length(allstructfields)
        
        if ~(ismember(allstructfields{i}, indvarcell) || ismember(allstructfields{i}, varcell))
            
            structout = rmfield(structout, allstructfields{i});
        end
        
    end
    
    
    
    
    
end

