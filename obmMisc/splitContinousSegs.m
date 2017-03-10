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


for i = 1:n

    if i==1
        indauxstart = 1;
    else
        indauxstart = indsplit(i-1) + 1;
    end

    if i<n
        indauxend = indsplit(i);
    else
        indauxend = length(inds);
    end
    
    segscell{i} = inds(indauxstart:indauxend);
     
end

