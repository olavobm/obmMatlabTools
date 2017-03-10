function segscell = splitContinousSegs(inds)
% segscell = SPLITCONTINOUSSEGS(inds)
%
%   inputs:
%       - inds:
%
%   outputs:
%       - segscell:
%
%
% Olavo Badaro Marques, 10/Mar/2017.


%%

diffinds = diff(inds);

indsplit = find(diffinds > 1);


%%

n = length(indsplit) + 1;

segscell = cell(1, n);

indauxstart = 1;
indauxend = indsplit(1);

segscell{1} = inds(indauxstart:indauxend);


for i = 1:(n-1)

    indauxstart = indsplit(i) + 1;
    
    if i~=(n-1)
        indauxend = indsplit(i + 1);
    else
        indauxend = length(inds);
    end
    
    segscell{i+1} = inds(indauxstart:indauxend);
    
    keyboard
    
end

