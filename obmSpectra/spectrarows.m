function pwspec = spectrarows(x, dt, np, indrows, ovrlap)
% pwspec = SPECTRAROWS(x, dt, np, indrows, ovrlap)
%
%   inputs
%       - x: matrix for which we will compute power spectra of its rows.
%            As a reminder, the columns must represent uniform spacing.
%       - dt: sampling period (distance between columns).
%       - np: number of points 
%       - indrows (optional): indices of the rows to operate
%                             on. Default is all rows.
%       - ovrlap (optional): overlap between chuncks (number
%                            between 0-1, default is 0.5).
%
%   outputs
%       - pwspec: structure array, in the format of obmPSpec.m. Each
%                 element of the array corresponds to the spectrum for
%                 each row of x.
%
% Function SPECTRAROWS computes power spectra, one for every
% row of x, using the function obmPSpec.m.
%
% This function also calls createEmptyStruct.m to organize
% the output into a structure array.
%
% See also: obmPSpec.m.
%
% Olavo Badaro Marques, 19/Jan/2017.


%% Check if indrows optional input was specified. Since
% one may give ovrlap but specify indrows as an empty
% array, also use default value for this case:

if ~exist('indrows', 'var')
    indrows = 1:size(x, 1);
else
    if isempty(indrows)
        indrows = 1:size(x, 1);
    end
end


%% Check if ovrlap input exists. If not, assign default value:

if ~exist('ovrlap', 'var')
    ovrlap = 0.5;
end


%% Take the power spectrum for each indrows(i)
% row of x. The if inside the loop organizes
% the output into a structure array:

% Number of rows where power spectrum is taken:
nrows = length(indrows);

% Loop over rows:
for i = 1:nrows
    
    % Compute power spectrum:
	pwspecaux = obmPSpec(x(indrows(i), :), dt, np, ovrlap);
    
    % If the it is the first iteration, get the field names
    % of the output of obmPSpec to create an empty struct
    % array (to be filled at each iteration):
    if i==1
        
        % Create empty structure and assign power spectrum
        % structure to the first entry in the array:
        pwspec = createEmptyStruct(fieldnames(pwspecaux), nrows);
        
        pwspec(1) = pwspecaux;
        
    else
        
        % Assign power spectrum structure to the output array:
        pwspec(i) = pwspecaux;
        
    end
    
end
