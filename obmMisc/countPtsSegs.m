function [nptsperseg] = countPtsSegs(tlims, t, x)
% [nptsperseg] = COUNTPTSSEGS(tlims, t, x)
%
%   inputs
%       - tlims: limits of the windows in t to count the number of x.
%       - t: independent variable associated with x (vector or matrix).
%       - x: array that is a function of t. In the case where x is a
%            a matrix, then the function does the count for each
%            row of x.
%
%   outputs
%       - nptsperseg: struct array with two fields (npts and nptsok).
%                     Each of these has the same number of rows of x
%                     while the number of columns is the same as the
%                     the number of windows defined by tlims.
%
% This function is very similar to histc, but it counts the non-NaN in x.
%
% Output: number, mean tlim, (in seg and in seg no-NaN)
%
% TO DO:
%   - I can optimize the last loop depending on the case.
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

    % use makeSegs.m
end


%% Make sure that if t and x are vectors, they are row vectors

if iscolumn(t)
	t = t.';
end


if iscolumn(x)
	x = x.';
end


%% Create an empty structure for the output variable

nptsperseg = createEmptyStruct({'meanbin', 'npts', 'nptsok'});


%% Take the mean position of the bins

nptsperseg.meanbin = mean(binlims, 2);


%% Take the parameters and indices used in the next block

nr = size(x, 1);
nsegs = size(binlims, 1);

%
if nr==1
    
else
    if size(t, 1)==1
        indr4t = ones(1, nr);
    else
        indr4t = 1:nr;
    end
end


%% Now count the number of non-NaN values in each bin

%
nptsperseg.npts = NaN(nr, nsegs);
nptsperseg.nptsok = NaN(nr, nsegs);

% Loop over the rows of x
for i1 = 1:nr
    
    % Loop over the segments
    for i2 = 1:nsegs
        
        %
        linseg = (t(indr4t(i1), :) >= binlims(i2, 1)) & ...
                 (t(indr4t(i1), :) <  binlims(i2, 2));
        
        %
        nptsperseg.npts(i1, i2) = length(find(linseg));
             
        %
        lnoNaN = ~isnan(x(i1, linseg));
        nptsperseg.nptsok(i1, i2) = length(find(lnoNaN));
        
    end
    
end


