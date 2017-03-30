function structoutvars = addEmptyFields2matchStructs(structvar1, structvar2)
% structoutvars = ADDEMPTYFIELDS2MATCHSTRUCTS(structvar1, structvar2)
%
%   inputs:
%       - structvar1:
%       - structvar2:
%
%   outputs:
%       - structoutvars:
%
%
%
% Olavo Badaro Marques, 30/Mar/2017.


fields1 = fieldnames(structvar1);
fields2 = fieldnames(structvar2);

fieldsNotin1 = setdiff(fields2, fields1);
fieldsNotin2 = setdiff(fields1, fields2);


for i = 1:length(fieldsNotin1)
    
    structvar1.(fieldsNotin1{i}) = [];
    
end

for i = 1:length(fieldsNotin2)
    
    structvar2.(fieldsNotin2{i}) = [];
end


%%

% ...
% This is not necessary for the concatenation below
% (as of Matlab 2015a), but looks as good coding practice:
structvar2 = orderfields(structvar2, fieldnames(structvar1));

% Assign output
structoutvars = [structvar1, structvar2];


