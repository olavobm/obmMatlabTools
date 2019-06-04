function zg = basicgridding(xd, yd, z, xg, yg)
% zg = BASICGRIDDING(xd, yd, z, xg, yg)
%
%   inputs
%       - xd:
%       - yd:
%       - z:
%       - xg:
%       - yg:
%
%   outputs
%       - zg:
%
%
%
% TO DO:
%   - Could allow xd OR yd to be matrices (not both).
%
% Olavo Badaro Marques, 04/Jun/2019.


%%

[nyd, ~] = size(z);


%%

%
z_onxg = NaN(length(yd), length(xg));

%
for i = 1:nyd
    
	%
    z_onxg(i, :) = interp1overnans(xd, z(i, :), xg);
    
end


%%

%
zg = NaN(length(yg), length(xg));

%
for i = 1:length(xg)
    
	%
    zg(:, i) = interp1overnans(yd, z_onxg(:, i), yg);
    
    
end



