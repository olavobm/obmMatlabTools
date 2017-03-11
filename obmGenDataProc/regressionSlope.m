function a = regressionSlope(x, y)
% a = REGRESSIONSLOPE(x, y)
%
%   inputs:
%       - x:
%       - y:
%
%   outputs:
%       - a:
%
% REGRESSIONSLOPE computes the regression slope a of the linear
% model y* = a x. This constant is determined by minimizing the
% mean square error between the model y* and the variable y.
%
% If inputs x and y are complex vectors....
% 
%
%
% Olavo Badaro Marques, 10/Mar/2017.

ble2 = (aaux' * baux) / (aaux' * aaux)

% aaux = T7sgrid - mean(T7sgrid);
% baux = C2sUmean - mean(C2sUmean);
% ble2 = (aaux' * baux) / (aaux' * aaux)