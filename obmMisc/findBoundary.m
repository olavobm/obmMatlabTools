function indbdry = findBoundary(x)
% indbdry = FINDBOUNDARY(x)
%
%   inputs:
%       - x: logical array.
%
%   outputs:
%       - indbdry:
%
%
% Olavo Badaro Marques, 18/Feb/2017.

dNaN = double(x);

[nr, nc] = size(dNaN);

daux = [false(1, nc); dNaN; false(1, nc)];

daux2 = [false(nr+2, 1), daux, false(nr+2, 1)];

coldiff = daux2(:, 2:end) - daux2(:, 1:end-1);
rowdiff = daux2(2:end, :) - daux2(1:end-1, :);

%%
indleft = find(coldiff == 1);

indright = find(coldiff == -1);

indup = find(rowdiff == 1);

indbottom = find(rowdiff == -1);

%%

sizevec = size(daux2);

[leftr, leftc] = ind2sub(sizevec - [0 1], indleft);
[rightr, rightc] = ind2sub(sizevec - [0 1], indright);
[upr, upc] = ind2sub(sizevec - [1 0], indup);
[bottomr, bottomc] = ind2sub(sizevec - [1 0], indbottom);

upr = upr + 1;
leftc = leftc + 1;


%% Put in output format:
allrowinds = [leftr(:); rightr(:); upr(:); bottomr(:)];
allcolinds = [leftc(:); rightc(:); upc(:); bottomc(:)];

indbdry = [allrowinds, allcolinds];


%% Reference to the original size:
indbdry = indbdry - 1;

% Remove repeated indices:
indbdry = unique(indbdry, 'rows');







