function [errAmp] = errMagPhase(A, da, B, db)
% [errAmp] = ERRMAGPHASE(A, da, B, db)
%
%   inputs:
%       - A:
%       - da:
%       - B:
%       - db:
%
%   outputs:
%       - errAmp
%       - phase?????
%
% Olavo Badaro Marques, 31/May/2017.

% Amplitude:
errAmp = sqrt((1/(A.^2 + B.^2)) .* ((A.*da).^2 + (B.*db).^2));

% Phase:
% errPhase = 