function pwspec = spectrarows(x, dt, np, indrows, ovrlap)
% pwspec = SPECTRAROWS(x, dt, rowstep)
%
%   inputs:
%       - x:
%       - dt:
%       - np:
%       - indrows (optional): indices of the rows to operate
%                             on. Default is all rows.
%       - ovrlap (optional):
%
%   outputs:
%       - pwspec:
%
% Function SPECTRAROWS computes power spectra, one for every
% row of x, using the function obmPSpec.m.
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


%%

for i = 1:length(indrows)
    
    pwspec = obmPSpec(x(indrows(i), :), dt, np);
    
end
