function outcoef = csprodcoef(ab, cd)
% outcoef = CSPRODCOEF(ab, cd)
%
%   inputs
%       - ab: complex variable with sinusoidal coefficients.
%       - cd: array with same size as ab.
%
%   outputs
%       - outcoef: 1x3 cell array with the coefficients.
%
% For two sinusoidals with zero mean and same frequency,
% defined by
%   real(ab)*cos(t) + imag(ab)*sin(t) and
%   real(cd)*cos(t) + imag(cd)*sin(t) ,
%
% CSCOEFSQR computes the coefficients of the product of the
% two sinusoidals. Note the product has twice the frequency
% and may have a non-zero mean (that is why I decided
% to output a cell array). The product is then a sinusoidal
% defined by
%  outcoef{1} + outcoef{2}*cos(2t) + outcoef{3}*sin(2t)
%
% Olavo Badaro Marques, 01/Aug/2017.


%% Split the real and imaginary parts

a = real(ab);
b = imag(ab);

c = real(cd);
d = imag(cd);


%% Compute coefficients (this is derived by carrying out
% the product and use a few trigonometric identities)

c1 = (a.*c + b.*d) / 2;

c2 = (a.*c - b.*d) / 2;

c3 = (a.*d + b.*c) / 2;


%% Assign output variable

outcoef = {c1, c2, c3};