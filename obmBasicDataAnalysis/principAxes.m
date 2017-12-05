function [theta] = principAxes(v)
%% [theta] = PRINCIPAXES(v)
%
%   inputs
%       - v: a matrix with 2 columns. The first (second) column is the
%            x (y) component of a vector (2D, mathematical vector).
%            NaNs may be present are disregarded in this function.
%
%   outputs
%       - theta: angle between the x axis and the semimajor axis of the
%                principal axes (measured in the usual counterclockwise
%                sense).   (varies in which range???????????????)
%  
% Principal axes are computed from the covariance between vector
% components, assuming a linear model y' = a * x', where a is a
% constant and primes denote subtraction of the mean of each
% component.
%
% The formula is obtained by first writing all the pairs (x, y) as
% a complex variable z = x + i*y. One can then rotate this variable
% z (hence x and y) by an angle theta. Writing the covariance for
% x and y, one can then solve for which angle theta gives 0 covariance.
% This is the angle of the semimajor axis.
%
% Principal axes are more generally computed with EOFs.
%
% Olavo Badaro Marques, 07/Sep/2015.


%% Sequence of commands:
%
%     - Get number of line;
%     - Remove the means;
%     - Compute covariance matrix (lines with NaNs are discarded);
%     - Compute angle of the principal axis.

[rv, ~] = size(v);

v = v - repmat(nanmean(v,1), rv, 1);

covmat = nancov(v);

theta = 0.5 * atan2( 2*covmat(1, 2), covmat(1, 1) - covmat(2, 2));   

