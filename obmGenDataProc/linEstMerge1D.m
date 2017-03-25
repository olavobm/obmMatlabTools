function y = linEstMerge1D(tx, x, decorScale, xnoise, ty)
% y = LINESTMERGE1D(tx, x, decorScale, xnoise, ty)
%
%   inputs:
%       - tx: cell array of data locations.
%       - x: cell array of data.
%       - decorScale:
%       - xnoise: cell array of noise.
%       - ty:
%
%   outputs:
%       - y:
%
% DO FOR EVERY COLUMN OF THE DATA!!! NUMBER OF COLUMNS MUST
% BE THE SAME (unless it is a vector)!
%
% Olavo Badaro Marques, 23/Mar/2017.


%% Check inputs:

% -----------------------------------------------------------------
% Transform ....... Transpose elements of x that are row vectors:
lisrow = cellfun(@isrow, x);
x(lisrow) = cellfun(@transpose, x(lisrow), 'UniformOutput', false);

% BUT I MAY WANT TO MERGE DATA FROM BOTH A MATRIX AND A VECTOR!!!!
% -----------------------------------------------------------------

%
% ncall = cellfun(@(x) size(x, 2), x, 'UniformOutput', false);
xsizeall = cellfun(@size, x, 'UniformOutput', false);
ncall = cellfun(@(x) x(2), xsizeall);
nc = ncall(1);


% lsamenc = cellfun( @(x) x==nc, ncall);
lsamenc = (ncall==nc);

if ~all(lsamenc)
	error(['Data inputs do not have consistent size. If they are ' ...
           'matrices they must have the same number of columns.'])
end


%% Concatenate arrays tx and x such that we can use all data from
% multiple sources (elements of x) to interpolate at the ty grid:

xaux = cellfun(@transpose, x, 'UniformOutput', false);
% ??????????????????????????????????????????????????????
% xaux = cellfun(@transpose, xaux, 'UniformOutput', false);

%
xaux = [xaux{:}];

xaux = xaux.';

% SHOULD I MAKE IT SUCH THAT TX CAN BE A
% MATRIX OR VECTOR (WHEN DATA IS A VECTOR)????????
liscol = cellfun(@iscolumn, tx);
tx(liscol) = cellfun(@transpose, tx(liscol), 'UniformOutput', false);
txaux = [tx{:}];
txaux = txaux.';


%% Create array of noise of consistent size with data arrays x:

%
% if ~exist('xnoise', 'var') || isempty(xnoise)
%     xnoise = {0.1};    
% end

% I'm assuming the noise is constant. One could implement a variable
% noise (for example, in the case of ADCP data, one might have noise
% that changes as a function of along-beam distance).

nrall = cellfun(@(x) x(1), xsizeall);
xnoiseaux = cell(1, length(xnoise));
for i = 1:length(xnoise)
    xnoiseaux{i} = repmat(xnoise{i}, 1, nrall(i));
end

xnoiseaux = [xnoiseaux{:}];


%% Subset only the data that is within a certain range of the
% grid. If data is far away, it is uncorrelated with estimated
% data on the grid and the calculation is slow......
% makes the calculation slower by
% adding insignicant information:

rangeScale = 3;

% Fast:
lclose = (ty >= (min(ty) - rangeScale*decorScale)) & ...
         (ty <= (max(ty) + rangeScale*decorScale));
  
% Very slow (not sure if is better than above in any situation):
% [b1, b2] = meshgrid(txaux, ty);
% lclose = any(abs(b1 - b2) < rangeScale*decorScale, 1);

%
txaux = txaux(lclose);
xaux = xaux(lclose, :);
xnoiseaux = xnoiseaux(lclose);


%% Loop over columns and estimate data on grid ty:

y = NaN(length(ty), nc);

for i = 1:nc

    lok = ~isnan(xaux(:, i));

    if any(lok)
        
        aaux = txaux(lok);
        baux = xaux(lok, i);
        caux = xnoiseaux(lok);
        
        y(:, i) = linGaussEst(aaux, baux, decorScale, caux, ty);
        
    end
    
end




