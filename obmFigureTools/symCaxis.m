function symCaxis(haxs)
% SYMCAXIS(haxs)
%
%   inputs
%       - haxs:
%
%
%
% TO DO:
%       - Add option to set limits of multiple axes to the same range.
%
% Olavo Badaro Marques, 11/Aug/2017.


%%

if ~exist('haxs', 'var')
    haxs = gca;
end


%%

for i = 1:length(haxs)
    
    valmax = max(abs(haxs(i).CLim));

    haxs(i).CLim = valmax .* [-1, 1];
end


