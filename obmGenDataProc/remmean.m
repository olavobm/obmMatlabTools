function xout = remmean(xin, dim)
% xout = REMMEAN(xin, dim)
%
%   inputs
%       - xin:
%       - dim:
%
%   outputs
%       - xout:
%
%
% Olavo Badaro Marques, 21/Mar/2019.

%
Nrep = size(xin, dim);

%
vec_rep = ones(1, ndims(xin));

%
vec_rep(dim) = Nrep;

%
x_mean = mean(xin, dim);

%
xout = xin - repmat(x_mean, vec_rep);