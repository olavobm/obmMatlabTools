function symCaxis(haxs)
% SYMCAXIS(haxs)
%
%   inputs
%       - haxs: axes handle(s) OR a figure handle(s).
%
%
%
% TO DO:
%       - Add option to set limits of multiple axes to the same range.
%       - Add option to give figure handle and set limits in all axes in it
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


