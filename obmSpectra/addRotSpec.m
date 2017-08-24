function [pwspecout] = addRotSpec(pwspec)
% [pwspecout] = ADDROTSPEC(pwspec)
%
%   inputs
%       - pwspec: power spectrum structure (output of obmPSpec.m).
%
%   outputs
%       - pwspecout: same format as input, adding negative and
%                    positive parts of the spectrum, as a function
%                    of positive frequencies.
%
% ADDROTSPEC calls sumRotSpec.m to add the spectrum at negative
% and positive frequencies. This is a high-level function to
% deal with the structure that I use for power spectra, while
% the called function does the addition.
% 
% TO DO:
%       - Add each spectrum that goes into the averaging
%       - What is the error of the sum?
%       - Should probably use addMirror.m rather than sumRotSpec.m.
%
% Olavo Badaro Marques, 09/Jun/2017.


%%

freq = pwspec.freq;

if ~(any(freq < 0) && any(freq > 0))
    error(['The power spectrum structure has ' ...
           'either only positive or negative frequencies'])
end


%%

[a1, b1] = sumRotSpec(freq, pwspec.psd);


%%

pwspecout = pwspec;
pwspecout.freq = a1;
pwspecout.psd = b1;

