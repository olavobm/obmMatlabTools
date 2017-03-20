function [xout, xstd, xn] = obmBinAvg(t, x, binlen, tbin)
% [xout, xstd, xn] = OBMBINAVG(t, x, binlen, tbin)
%
%   input:
%       - t:
%       - x: vector or matrix, regularly spaced across the rows (the
%            dimension where the running mean is applied).
%       - binlen: window length in units of t.
%       - tbin (optional): t values for the center of the bins to take the
%                          average of.
%
%   output:
%       - xout:
%       - xstd:
%       - xn:
%
% Olavo Badaro Marques, 20/Mar/2017.