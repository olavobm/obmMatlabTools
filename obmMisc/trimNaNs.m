function [StructVar, lgoodarray] = trimNaNs(StructVar, DimsTrim, StructFields)
% [StructVar, lgoodarray] = TRIMNANS(StructVar, DimsTrim, StructFields)
%
%   inputs:
%       - StructVar: structure variable, whose fields are the
%                    matrices (and vectors) to be trimmed. It
%                    can also be only one variable of class
%                    double, in which case, the output is of
%                    the same class.
%       - DimsTrim: row vector of dimensions to trim:
%                         1 for rows, 2 for columns.
%       - StructFields (optional): cell array with the names of the
%                                  fields of StructVar to consider,
%                                  neglecting all the others.
%
%   outputs:
%       - StructVar: StructVar with trimmed variable fields.
%       - lgoodarray: 1x2 logical cell array, where lgoodarray{1}
%                     (lgoodarray{2}) indicates the rows (columns)
%                     that have been kept.
%
% Function TRIMNANS removes NaN-only rows and/or columns from variables
% specified by StructVar. For a multiple variables given by the fields
% of StructVar, the rows/columns that are removed are the ones that are
% NaN-only for all the variables.
% 
%
% Olavo Badaro Marques, 06/Jan/2017.


%% If StructVar is a simple double variable, transform
% it into a structure. Also create a switch to transform
% the output back to a double variable:

if isa(StructVar, 'double')
    
    % Turn off warning for overiding a double variable
    % by creating a struct variable with the same name:
    warning('off', 'MATLAB:warn_r14_stucture_assignment')
    
    % Assign variable to a structure:
    StructVar.auxname = StructVar;
    
    % Logical switch to return double variable in the output:
    ldoubleoutput = true;
    
else
    ldoubleoutput = false;
end


%% If optional input was not specified, look at all fields
% of StructVar. Create "lmat", a logical array with true
% for the StructFields that are matrices:

if ~exist('StructFields', 'var')
    StructFields = fieldnames(StructVar);
    
    lmat = ~structfun(@isvector, StructVar);
else
    
    lmat = false(1, length(StructFields));
    for i = 1:length(StructFields)
        if ~isvector(StructVar.(StructFields{i}))
            lmat(i) = true;
        end  
    end

end


%% If StructFields has both vectors and matrices, then
% we will loop through the matrices only. If instead
% they are all vectors, we loop through the vectors:

indloop = 1:length(StructFields);

% If there are matrices (the most common case),
% subset their correspondend indices:
if any(lmat)
    indloop = indloop(lmat);
end


%% Should check if size of all StructVar.(StructFields{indloop})
% are the same:

[nrows, ncols] = size(StructVar.(StructFields{indloop(1)}));

for i = 2:length(indloop)
    
    [nraux, ncaux] = size(StructVar.(StructFields{indloop(i)}));
    
    if nraux~=nrows || ncaux~=ncols
        error('Size of trimmed variables are different!')
    end
    
end


%% Loop through dimensions to trim and variables to get the rows
% and columns to be kept (in the updated logical array lgoodarray):

%
dimacton = DimsTrim;
dimacton(DimsTrim==1) = 2;
dimacton(DimsTrim==2) = 1;

% Pre-allocate:
% lgoodarray = {true(nrows, 1), true(1, ncols)}; % restrictuve
lgoodarray = {false(nrows, 1), false(1, ncols)};   % relaxed

% Loop through dimensions to trim:
for i1 = 1:length(DimsTrim)
    
    lgood = lgoodarray{DimsTrim(i1)};
    
    % Loop through all variables:
    for i2 = 1:length(indloop)
        
        % Logical array, where true is for the row/columns
        % of field StructFields{i2} that have at least one
        % non-NaN data points:
        laux = any(~isnan(StructVar.(StructFields{indloop(i2)})), dimacton(i1));
               
        % Update lgood:
%         lgood = lgood & laux;   % restrictive
        lgood = lgood | laux;   % relaxed
    end
    
    lgoodarray{DimsTrim(i1)} = lgood;

end


%% 

if length(DimsTrim)~=2
    if DimsTrim==1
        lgoodarray{2} = true(1, ncols);
    else  % DimsTrim==2
        lgoodarray{1} = true(nrows, 1);
    end
end


%% Loop through the variables and trim them:

for i = 1:length(StructFields)

    if isrow(StructVar.(StructFields{i}))
        
        StructVar.(StructFields{i}) = ...
        StructVar.(StructFields{i})(:, lgoodarray{2});
        
    elseif iscolumn(StructVar.(StructFields{i}))
        
        StructVar.(StructFields{i}) = ...
        StructVar.(StructFields{i})(lgoodarray{1}, :);
        
    else
        StructVar.(StructFields{i}) = ...
        StructVar.(StructFields{i})(lgoodarray{1}, lgoodarray{2});
    end
   
end


%% If input was a double variable,
% then output in the same class:
  
if ldoubleoutput
    StructVar = StructVar.auxname;
end

