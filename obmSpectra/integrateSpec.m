function [intSpec] = integrateSpec(pwspec, df, lsumrot)
% [intSpec] = INTEGRATESPEC(pwspec)
%
%   inputs:
%       - pwspec: structure with (at least) 2 fields -- psd
%                 (power spectral density) and freq
%                 (frequency vector).
%       - df: Nx2 matrix with N bandwidths to
%             integrate the spectrum.
%
%   outputs:
%       - intSpec: N integrals of the spectrum
%                  on the bandwidth df.
%
%
% I might want to create/use my own integration function.
%
% Olavo Badaro Marques, 23/Feb/2017.
