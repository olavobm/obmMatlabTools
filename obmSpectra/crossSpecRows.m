function [xyCross, x_pwspec, y_pwspec] = crossSpecRows(f, x, y, dt, np, x_indrows, y_indrows)
% [xyCross, x_pwspec, y_pwspec] = CROSSSPECROWS(f, x, y, dt, np, indrows)
%
%   inputs:
%       - f: one frequency to look at in the cross-spectrum
%            (in units of the inverse of the units of dt).
%       - x: matrix for which we want spectra of its rows.
%       - y: same as above, but for y. It MUST have the same number of
%            columns as x and they must refer to the same time.
%       - dt: constant sampling period.
%       - np: number of points of each chunk to take the fft of.
%       - x_indrows (optional): row indices to subset rows of x.
%       - y_indrows (optional):  "     "    "     "     "   " y.
%
%   outputs:
%       - xyCross: struct variable with the cross-spectra of the rows of
%                  x with the ones of y, at frequency f. The two fields
%                  in this structure are Coh (coherence) and Pha (phase).
%                  Each of them is an array of size [Ny, Nx], where Ny
%                  (Nx) is the number of rows of y (x) being considered
%                  to compute spectra.
%       - x_pwspec: 1xN struct array with spectra of rows of x.
%       - y_pwspec: same as above for y.
%
% CROSSSPECROWS takes the cross-spectra (coherence and phase) of rows of
% x with rows of y. You have the option of selecting a subset of the rows
% to look at by specifying the last two inputs.
%
% The output only keeps the cross-spectra at a single frequency f.
% The output is the value from the cross-spectrum that is closest
% in frequency to the input f.
%
% Spectra are calculated using my function obmPSpec.m, which is called
% by my other function spectrarows.m. Note the cross-spectrum is then
% computed by my other function crossSpecFromStruct.m.
%
% TODO:
%   - make a comment about NaNs.
%   - maybe should return full cross-spectrum rather than magnitude
%     and argument.
%   - maybe do something different about the closest frequency to choose.
%
% Olavo Badaro Marques, 03/Mar/2017.


%% Check if optional inputs were specified
% (default is to look at all rows of x and y):

if ~exist('x_indrows', 'var')
    x_indrows = 1:size(x, 1);
end

if ~exist('y_indrows', 'var')
    y_indrows = 1:size(y, 1);
end


%% Compute power spectra for several rows:

x_pwspec = spectrarows(x, dt, np, x_indrows);
y_pwspec = spectrarows(y, dt, np, y_indrows);


%% Get index of closest frequency

indf = dsearchn(x_pwspec(1).freq(:), f);


%% Take the cross-spectra and assign output:

% Number of rows to take the spectra of:
ny = length(y_indrows);
nx = length(x_indrows);

% Pre-allocate space for main output:
xyCross.Coh = NaN(ny, nx);
xyCross.Pha = NaN(ny, nx);

% Loop over rows of y, then rows of x, and take cross-spectra:
for i1 = 1:ny
    
    for i2 = 1:nx
    
        auxCrossSpec = crossSpecFromStruct(x_pwspec(i2), ...
                                           y_pwspec(i1), ...
                                           np, dt);
    
        xyCross.Coh(i1, i2) = auxCrossSpec.Coh(indf);
        xyCross.Pha(i1, i2) = auxCrossSpec.Pha(indf);
        
        
    end 
    
end



