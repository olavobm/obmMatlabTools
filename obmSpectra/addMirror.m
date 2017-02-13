function [xout, yout] = addMirror(x, y)
% [xout, yout] = ADDMIRROR(x, y)
%
%   inputs:
%       - x: vector twith negative and positive
%            values of same magnitude.
%       - y: variable specified given at x.
%
%   outputs:
%       - xout: only the positive values (that have the negative
%               counterpart).
%       - yout: sum of the y values at the x points of same magnitude.
%
% ADDMIRROR is a simple little function. Originally created to add
% spectral densities of positive and negative frequencies.
%
% Olavo Badaro Marques, 13/Feb/2017.


xout = x(x>0);

N = length(xout);

yout = NaN(1, N);


% Loop over the values in xout:
for i = 1:N
    
    yaux = y(abs(x)==xout(i));
    
    yout(i) = yaux(1) + yaux(2);
    
end