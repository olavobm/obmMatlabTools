function psout = pwSpecStruct(n)
% psout = PWSPECSTRUCT(n)
%
%   inputs:
%       - n: length of the structure array output:
%
%   outputs:
%       - psout: structure array, where the fields are  with field
%
% Create structure array of length n, where the fields are those that
% my code for calculating power spectrum creates.
%
% See also: obmPSpec.m, createEmptyStruct.m.
%
% Olavo Badaro Marques, 26/Jun/2017.

% List of fields:
listfields = {'freq', 'allpsd', 'psd', 'fcoed', 'dof', 'err'};

% Call my function that creates empty structure array:
psout = createEmptyStruct(listfields, n);