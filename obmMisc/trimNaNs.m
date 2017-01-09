function StructVar = trimNaNs(StructVar, DimsTrim, StructFields)
% StructVar = TRIMNANS(StructVar, DimsTrim, StructFields)
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
%
% Function TRIMNANS
% The variables must have the same size,
%                    such that rows/columns are only trimmed if they have
%                    NaNs only for all the variables
%
% Olavo Badaro Marques, 06/Jan/2017.


%%

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


%% If optional input was not specified,
% look at all fields of StructVar:

if ~exist('StructFields', 'var')
    StructFields = fieldnames(StructVar);        
end


%%

indloop = 1:length(StructFields);

lmat = ~structfun(@isvector, StructVar);

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


%% Loop through dimensions to trim and variables
% to get the rows and columns to be kept (in the
% updated logical array lgoodarray):

%
dimacton = DimsTrim;
dimacton(DimsTrim==1) = 2;
dimacton(DimsTrim==2) = 1;

% Pre-allocate:
lgoodarray = {true(nrows, 1), true(1, ncols)};


% Loop through dimensions to trim:
for i1 = 1:length(DimsTrim)
    
    lgood = lgoodarray{DimsTrim(i1)};
    
    % Loop through all variables:
%     for i2 = 1:length(StructFields)
    for i2 = 1:length(indloop)
        
        % Logical array, where true is for the row/columns
        % of field StructFields{i2} that have at least one
        % non-NaN data points:
        laux = any(~isnan(StructVar.(StructFields{indloop(i2)})), dimacton(i1));
        
        % Update lgood:
        lgood = lgood & laux; 
    end
    
    lgoodarray{DimsTrim(i1)} = lgood;

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

