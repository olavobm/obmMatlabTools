function [crossSpec, x_pwspec, y_pwspec] = obmCrossSpec(x, y, dt, np, ovrlap)
% [crossSpec, x_pwspec, y_pwspec] = OBMCROSSSPEC(x, y, dt, np, ovrlap)
%
%   inputs:
%       - x: vector with evenly spaced data.
%       - y: vector with same length as x, givent on the same grid.
%       - dt: sampling period.
%       - np: number of data points per chunk.
%       - ovrlap (optional): overlap between chunks (number
%                            between 0-1, default is 0.5).
%
%   outputs:
%       - crossSpec: structure variable with the fields:
%           * freq: frequency of the spectrum.
%           * Coh: coherence.
%           * Pha: phase
%           * coSpec: co-spectrum (the real part of the cross-spectrum).
%           * quadSpec: quadrature spectrum (the imaginary part).
%           * dof: degrees of freedom
%
%       - x_pwspec: power spectrum structure of x (see obmPSpec.m).
%       - y_pwspec: power spectrum structure of y.
%
% OBMCROSSSPEC takes the cross spectrum of x with y. The spectral
% estimates for each of x and y are done by obmPSpec.
%
% Olavo Badaro Marques, 28/Feb/2017.


%% Check x and y are vectors, with same length:

if ~isvector(x) || ~isvector(y)
    error(['Either input ' inputname(1) ' or ' inputname(2) ' is ' ...
           'not a vector. They must be.'])
else
    if ~iscolumn(x)
        x = x(:);
    end
    if ~iscolumn(y)
        y = y(:);
    end
end


%% If ovrlap is not given, choose default value:

if ~exist('ovrlap', 'var')
    ovrlap = 0.5;
end


%% If x and y have different NaNs, then put NaN in both
% of them at every index where NaN appears in any of them:

if ~isequal(isnan(x), isnan(y))
    
    lunionNaN = (isnan(x) | isnan(y));
    
    x(lunionNaN) = NaN;
    y(lunionNaN) = NaN;

end


%% Compute power spectra for x and y with obmPSpec:

x_pwspec = obmPSpec(x, dt, np, ovrlap);
y_pwspec = obmPSpec(y, dt, np, ovrlap);


% --------------------------------------------------------
% WHATEVER IS BELOW, COULD BE IN A SEPARATE
% FUNCTION THAT TAKES THE STRUCTURES AS INPUTS
% AND RETURNS THE CROSS-SPECTRUM. I WOULD THEN
% BE ABLE TO DO crossSpecRows BY CALLING SPECTRA ROWS.

%% Cross-spectrum:

% Product of Fourier coefficients:
allCross = conj(x_pwspec.fcoef) .* y_pwspec.fcoef;

% Ensemble averaged cross-spectrum:
cross_spec = 2.*  mean(allCross, 2) ./ (np/dt);
    
% Co-spectrum and Quadrature spectrum:
co_spec = real(cross_spec);
qd_spec = imag(cross_spec);


%% Assign results to output variable:

lenspec = length(cross_spec);

crossSpec.freq = ( 1:lenspec ) ./ (np*dt);
crossSpec.Coh  = abs(cross_spec) ./ sqrt(x_pwspec.psd .* y_pwspec.psd);
crossSpec.Pha  = atan2(qd_spec, co_spec);
crossSpec.coSpec = co_spec;
crossSpec.quadSpec = qd_spec;


% Degrees of freedom:
dof = x_pwspec.dof;
crossSpec.dof = dof;