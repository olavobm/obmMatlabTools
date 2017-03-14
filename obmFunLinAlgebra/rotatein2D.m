function [uout, vout] = rotatein2D(uin, vin, theta)
% [uout, vout] = ROTATEIN2D(uin, vin, theta)
%
%   inputs:
%       - uin
%       - vin
%       - theta
%
%   outputs:
%       - uout
%       - vout
%
%
% Olavo Badaro Marques, 13/Mar/2017.


origsize = size(uin);

uin = uin(:);
uin = uin';

vin = vin(:);
vin = vin';

uv = [uin; vin];


rotOptor = [cos(theta), -sin(theta); ...
            sin(theta),  cos(theta)];  

uvaux = rotOptor * uv;

uout = reshape(uvaux(1, :), origsize);
vout = reshape(uvaux(2, :), origsize);

    
