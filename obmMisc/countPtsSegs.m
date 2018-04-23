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
% Olavo Badaro Marques, 23/Apr/2018.


%%



%%


%%

nptsperseg = createEmptyStruct({'meanbin', 'npts', 'nptsok'});


%%

nptsperseg.meanbin = mean(tlims, 2);


%%

nr = size(x, 1);
nsegs = NaN;


%%

%
nptsperseg.npts = NaN(nr, nsegs);
nptsperseg.nptsok = NaN(nr, nsegs);

%
for i1 = 1:nr
    
    for i2 = 1:nsegs
        
        %
        linseg = (t(i1, :) >= tlims(i1, 1)) & ...
                 (t(i1, :) <  tlims(i1, 2));
        
        %
        nptsperseg.npts(i1, i2) = length(find(linseg));
             
        %
        lnoNaN = ~isnan(x(i1, linseg));
        nptsperseg.nptsok(i1, i2) = length(find(lnoNaN));
        
    end
    
end


