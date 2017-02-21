function y = sortHoop(x)
% y = SORTHOOP(x)
%
%   inputs:
%       - x: Nx2 array.
%
%   outputs:
%       - y: Nx2 array with values of x sorted.
%
%
% SORT in the CCW sense.
%
% BIG PROBLEMS IF "TIVER UMA PENINSULA", INSTEAD OF A PROPER HOOP.
%
% Olavo Badaro Marques, 21/Feb/2017.


ymax = max(x(:, 2));

lymax = (x(:, 2) == ymax);

nept = find(x(lymax, 1) == max(x(lymax, 1)));




