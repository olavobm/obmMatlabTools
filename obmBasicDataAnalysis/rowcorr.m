function outcorr = rowcorr(x, y, lall, minpts)
% outcorr = ROWCORR(x, y, minpts)
%
%   inputs
%       - x: vector or matrix, where different samples span
%            the columns of x and rows are different locations
%            where samples are taken.
%       - y: same format as x.
%       - lall (optional): logical value for combination
%                          of rows (default is false).
%       - minpts (optional):
%
%   outputs
%       - outcorr: correlation matrix between samples of x and y.
%
% ROWCORR computes the correlation between the rows of x and y.
% There are two possibilities (ONLY THE FIRST IMPLEMENTED SO FAR).
% If lall is false (default), then the correlations are compute
% row-wise and x and y should have the same number of rows -- the
% result being a column vector. On the other hand, if lall is true,
% then the correlation is taken for all combination of rows.
%
%
% TO DO: 
%       - minimum number of points to compute correlation
%       - DO OPERATIONS OF ONE ROW OF X WITH ALL FROM Y.
%       - output CI and NaN correlations that are not
%         significant (for this CI)
%
% Olavo Badaro Marques, 14/Aug/2017.


%% Define default values of optional inputs

%
N = size(x, 1);

%
outcorr = NaN(N, 1);

%
if ~exist('lall', 'var') || isempty(lall)
    lall = false;
end

if ~exist('minpts', 'var')
    minpts = 450;
end



%% Compute correlations using the rows of x and y

% Loop over rows
for i = 1:N
    
    %
    xaux = x(i, :);
    yaux = y(i, :);
    
    %
    if length(isnan(xaux)) < minpts || length(isnan(yaux)) < minpts
        corr_aux = NaN;
    else
        corr_aux = corr(xaux(:), yaux(:), 'rows', 'complete');
    end
    
    %
    if ~isnan(corr_aux)
        outcorr(i) = corr_aux;
    end
    
end
