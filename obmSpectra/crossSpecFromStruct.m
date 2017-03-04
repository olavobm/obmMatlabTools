function crossSpec = crossSpecFromStruct(pwspec1, pwspec2, np, dt)
% crossSpec = CROSSSPECFROMSTRUCT(pwspec1, pwspec2)
%
%   inputs:
%       - pwspec1: power spectrum structure (output of obmPSpec).
%       - pwspec2: variable with same format as above.
%       - np: np used when creating pwspec1 and pwspec2.
%       - dt: dt  "     "      "      "      "     "
%
%   outputs:
%       - crossSpec: structure with the following fields:
%           * freq: frequency vector of the cross-spectrum.
%           * Coh: coherence (NOT squared), magnitude of
%                  the cross-spectrum.
%           * Pha: phase, argument of the cross-spectrum.
%           * coSpec: co-spectrum (real part of the cross-spectrum).
%           * quadSpec: quadrature-spectrum (imaginary
%                       part of the cross-spectrum).
%           * dof: degrees of freedom (same as for each
%                  of the spectra given as input).
%
% Compute cross-spectral estimate from 2 power spectra structures,
% of the format output by the function obmPSpec.m
%
% np and dt should not be inputs because you can not choose them.
% Technically, you could compute one from the other, but the best
% thing would be to include them in the obmPSpec function output.
% np and dt could be computed if we have the rotary spectrum, but
% if we only have the positive frequencies, I don't think we can
% differentiate between positive and negative np.
%
% Olavo Badaro Marques, 03/Mar/2017.


%% Check inputs:

fields1 = fieldnames(pwspec1);
fields2 = fieldnames(pwspec2);

if ~isequal(fields1, fields2)
    
    error('...')
    
else
    
    if ~isequal(pwspec1.freq, pwspec2.freq)
        error('....')
    end
        
    if pwspec1.dof ~= pwspec2.dof
        error('....')
    end
    
end


%% Cross-spectrum:

% Product of Fourier coefficients:
allCross = conj(pwspec1.fcoef) .* pwspec2.fcoef;

% Ensemble averaged cross-spectrum:
cross_spec = 2.*  mean(allCross, 2) ./ (np/dt);
    
% Co-spectrum and Quadrature spectrum:
co_spec = real(cross_spec);
qd_spec = imag(cross_spec);


%% Assign results to output variable:

crossSpec.freq = pwspec1.freq;

crossSpec.Coh  = abs(cross_spec) ./ sqrt(pwspec1.psd .* pwspec2.psd);
crossSpec.Pha  = atan2(qd_spec, co_spec);

crossSpec.coSpec = co_spec;
crossSpec.quadSpec = qd_spec;

% Degrees of freedom:
dof = pwspec1.dof;
crossSpec.dof = dof;