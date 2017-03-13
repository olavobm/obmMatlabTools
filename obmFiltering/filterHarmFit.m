function [dfit, xnew] = filterHarmFit(x, d, wnd, freq)
% [dfit, xnew] = FILTERHARMFIT(x, d, wnd, freq)
%
%   inputs:
%       - x: vector OR matrix with independent variable.
%       - d: vector or matrix. Each row of d is filtered independently.
%       - wnd: window length, in the SAME UNITS as x.
%       - freq: frequency of the signal to filter, in units of x.
%
%   outputs:
%       - dfit: d filtered around the frequency freq.
%       - xnew:
%
% Function FILTERHARMFIT simply calls sliding_harmonic to band-pass
% the data on the freq frequency. Mean and trend are removed from
% each data chunk.
%
% Olavo Badaro Marques, 03/Feb/2017.


% SOMEHOW MY FILTERING WORKED WHEN THE NUMBER OF COLUMNS
% OF X IS DIFFERENT THAN FOR VARIABLE D. THIS SHOULD NEVER
% EVER POSSIBLY HAPPEN!!!!!!


%% Define input-model-fit structure and call sliding_harmonicfit.m:

imf.power = [0 1];
imf.sine = freq;

lpartfit = [false, false, true, true];

slidestep = 1; % I could try to estimate a coarse but nice interval


%% Call sliding_harmonicfit:

dfit = sliding_harmonicfit(x, d, wnd, slidestep, imf, lpartfit);


if slidestep>1
   
else
    xnew = x;
end
