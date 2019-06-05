function zg = basicgridding(xd, yd, z, xg, yg, xymaxgaps)
% zg = BASICGRIDDING(xd, yd, z, xg, yg, xymaxgaps)
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
% See also: addnonan.m.
%
% Olavo Badaro Marques, 04/Jun/2019.


%%

if ~exist('xymaxgaps', 'var')
	xymaxgaps = 2 .* [ (max(xd) - min(xd)), (max(yd) - min(yd))];
end


%%

[nyd, nxd] = size(z);


%% First interpolate each column over all rows

%
z_onyg = NaN(length(yg), length(xd));

%
for i = 1:nxd
    
	%
    if any(~isnan(z(:, i)))
        z_onyg(:, i) = interp1overnans(yd, z(:, i), yg, xymaxgaps(2));
    end
end


%% Then interpolate each row over all columns

%
zg = NaN(length(yg), length(xg));

%
for i = 1:length(yg)
    
	%
    if any(~isnan(z_onyg(i, :)))
        
        zg(i, :) = interp1overnans(xd, z_onyg(i, :), xg, xymaxgaps(1));
        
    end

end

% % % % This is the opposite of above
% % % 
% % % %% First interpolate each row over all columns
% % % 
% % % %
% % % z_onxg = NaN(length(yd), length(xg));
% % % 
% % % %
% % % for i = 1:nyd
% % %     
% % % 	%
% % %     if any(~isnan(z(i, :)))
% % %         z_onxg(i, :) = interp1overnans(xd, z(i, :), xg, xymaxgaps(1));
% % %     end
% % % end
% % % 
% % % 
% % % %% Then interpolate each column over all rows
% % % 
% % % %
% % % zg = NaN(length(yg), length(xg));
% % % 
% % % %
% % % for i = 1:length(xg)
% % %     
% % % 	%
% % %     if any(~isnan(z_onxg(:, i)))
% % %         zg(:, i) = interp1overnans(yd, z_onxg(:, i), yg, xymaxgaps(2));
% % %     end
% % % 
% % % end



