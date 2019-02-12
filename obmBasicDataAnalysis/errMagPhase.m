function [errAmp, errPhase] = errMagPhase(A, B, da, db)
% [errAmp, errPhase] = ERRMAGPHASE(A, B, da, db)
%
%   inputs
%       - A: value of A.
%       - B:   "   "  B.
%       - da: error of A.
%       - db:   "   " B.
%
%   outputs
%       - errAmp: error of the amplitude.
%       - phase:    "    "  " phase.
%
% ERRMAGPHASE uses standard error propagation calculations to
% compute the error of the amplitude and phase (argument) of
% a 2D vector (A, B), based on the errors of A and B (da and db,
% respectively). These are the dimensional errors (NOT fractional).
%
% The errors da and db are assumed to be uncorrelated.
%
% Note the phase is a non-linear function of A and B with
% singularities. The calculated error is not real under
% certain conditions.
%
%
% Olavo Badaro Marques, 31/May/2017.

% Amplitude:
errAmp = sqrt((1./(A.^2 + B.^2)) .* ((A.*da).^2 + (B.*db).^2));

% Phase/direction:
errPhase = sqrt(((da .* B).^2 + (db .* A).^2) ./ ((A.^2 + B.^2).^2));