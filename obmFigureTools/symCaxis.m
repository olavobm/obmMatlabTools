function symCaxis(haxs)
%
%
%   inputs
%       -
%
%   outputs
%       -
%
%
%
% Olavo Badaro Marques, 11/Aug/2017.


if ~exist('haxs', 'var')
    haxs = gca;
end

valmax = max(abs(haxs.CLim));

haxs.CLim = valmax .* [-1, 1];