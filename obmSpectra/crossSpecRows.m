function [xyCoh, xyPha, x_pwspec, y_pwspec] = crossSpecRows(f, x, y, dt, np, x_indrows, y_indrows)
% [crossSpec, x_pwspec, y_pwspec] = CROSSSPECROWS(f, x, y, dt, np, indrows)
%
%   inputs:
%       - f:
%       - x:
%       - y:
%       - dt:
%       - np:
%       - x_indrows (optional):
%       - y_indrows (optional):
%       - ovrlap (optional):
%
%   outputs:
%       - crossSpec:
%       - x_pwspec:
%       - y_pwspec:
%
%
%
% Olavo Badaro Marques, 03/Mar/2017.


%%

if ~exist('x_indrows', 'var')
    x_indrows = 1:size(x, 1);
end

if ~exist('y_indrows', 'var')
    y_indrows = 1:size(y, 1);
end


%% Compute power spectra:

x_pwspec = spectrarows(x, dt, np, x_indrows);
y_pwspec = spectrarows(y, dt, np, y_indrows);


%%

indf = dsearchn(x_pwspec.freq(:), f);


%%

ny = length(y_indrows);
nx = length(x_indrows);

xyCoh = NaN(ny, nx);
xyPha = NaN(ny, nx);


for i1 = 1:ny
    
    for i2 = 1:nx
    
        auxCrossSpec = crossSpecFromStruct(x_pwspec(i2), ...
                                           y_pwspec(i1), ...
                                           np, dt);
    
        xyCoh(i1, i2) = auxCrossSpec.Coh(indf);
        
        
    end 
    
end


