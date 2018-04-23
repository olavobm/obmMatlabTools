function [nptsperseg] = countPtsSegs(tlims, t, x)
% [nptsperseg] = COUNTPTSSEGS(tlims, t, x)
%
%   inputs
%       - tlims:
%       - t:
%       - x:
%
%   outputs
%       - nptsperseg:
%
%
% Output: number, mean tlim, (in seg and in seg no-NaN)
%
% See also: makeSegs.m
%
% Olavo Badaro Marques, 23/Apr/2018.


%%
%
% need to improve this/make sure that input tlims is good

if isvector(tlims)
    
    %
    binlims = NaN(length(tlims)-1, 2);
    
    binlims(:, 1) = tlims(1:end-1);
    binlims(:, 2) = tlims(2:end);
    
else
    
    
end


%%

if iscolumn(t)
	t = t.';
end


if iscolumn(x)
	x = x.';
end


%%

nptsperseg = createEmptyStruct({'meanbin', 'npts', 'nptsok'});


%%

nptsperseg.meanbin = mean(binlims, 2);


%%

nr = size(x, 1);
nsegs = size(binlims, 1);


%%

%
nptsperseg.npts = NaN(nr, nsegs);
nptsperseg.nptsok = NaN(nr, nsegs);

%
for i1 = 1:nr
    
    for i2 = 1:nsegs
        
        %
        linseg = (t(i1, :) >= binlims(i1, 1)) & ...
                 (t(i1, :) <  binlims(i1, 2));
        
        %
        nptsperseg.npts(i1, i2) = length(find(linseg));
             
        %
        lnoNaN = ~isnan(x(i1, linseg));
        nptsperseg.nptsok(i1, i2) = length(find(lnoNaN));
        
    end
    
end


