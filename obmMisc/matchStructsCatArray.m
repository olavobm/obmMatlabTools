function outstructarray = matchStructsCatArray(structarray, newstruct)
% outstructarray = MATCHSTRUCTSCATARRAY(structarray, newstruct)
%
%   inputs:
%       - structarray: 1xN structure array (must be row vector).
%       - newstruct: (scalar) structure.
%
%   outputs:
%       - outstructarray: 1x(N+1) structure array with newstruct
%                         concatenated to the input array.
%
% MATCHSTRUCTSCATARRAY calls addEmptyFields2matchStructs.m to
% concatenate a structure newstruct to the array structarray,
% where newstruct has a different set of fields than the array
% structarray.
%
% Olavo Badaro Marques, 30/Mar/2017.



%%

structoutvars = addEmptyFields2matchStructs(structarray(end), newstruct);


%%

%
allfieldnames = fieldnames(structoutvars);

%
nnew = length(structarray) + 1;


%
if length(structarray)>1
    
    outstructarray = emptyStructArray(allfieldnames, nnew);
    
    arrayfieldnames = fieldnames(structarray(1));


    if ~isequal(sort(arrayfieldnames), sort(allfieldnames))
        
        
        for i = 1:(nnew-2)
            
            structaux = addEmptyFields2matchStructs(structarray(i), structoutvars(1));
            
            outstructarray(i) = structaux(1);

        end
        
    else
        
        structarray = orderfields(structarray, allfieldnames);
        
        outstructarray(1:(nnew-2)) = structarray(1:(nnew-2));
        
        
    end

    outstructarray(nnew-1:end) = structoutvars;
    
else
    
    outstructarray = structoutvars;
    
    
end

