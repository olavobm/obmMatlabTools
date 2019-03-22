function xout = remmean(xin, dim)
% xout = REMMEAN(xin, dim)
%
%   inputs
%       - xin: a double array (1D, 2D, N-D).
%       - dim: dimension along which to calculate the mean.
%
%   outputs
%       - xout: double array the same size as xin.
%
% REMMEAN.m is a simple function to remove the mean
% of xin along the dimension dim. The purpose of this
% function is to use repmat consistently without having
% to write it over and over again.
%
% Olavo Badaro Marques, 21/Mar/2019.


%%

% Get length in the appropriate direction
Nrep = size(xin, dim);

% Use the above to create the vector
% for repeating the "mean array"
vec_rep = ones(1, ndims(xin));
vec_rep(dim) = Nrep;

% Calculate the mean along the dimension "dim"
x_mean = mean(xin, dim);

% Remove x_mean from the array xin
xout = xin - repmat(x_mean, vec_rep);