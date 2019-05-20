function yinterp = extrap1overnans(x, y, exmethod, xgrid)
%% [yinterp] = EXTRAP1OVERNANS(x, y, exmethod, xgrid)
%
%   inputs
%       - x: location of data points of y along the
%            interpolation dimension.
%       - y: vector or matrix.
%       - exmethod:
%       - xgrid (optional): locations where we want to interpolate data.
%
%   outputs
%       - yinterp: y interpolated on x/xgrid.
%
% See also: interp1overnans.m
%
%
% TO DO:
%   - Clean code
%   - Make sure it works for vectors.
%   - xgrid different than x probably doesn't work yet.
%   - Should include to either top, or bottom, or both.
%
% Olavo Badaro Marques, 06/Jul/2018.


%% Get size of the variable to be interpolated:

[ry, cy] = size(y);

% If y was specified as a row vector, then
% transpose it and update the size of it:
if ry == 1 && cy > 1
    y = y(:);
%     ry = cy;   % ry is not used anymore, so it does not matter -- NOT IN
                                            %     THIS FUNCTION ANYMORE!!!
	ry = cy;
    cy = 1;
    
    lyrowvec = true;
else
    lyrowvec = false;
end


%% 1D grid where data will be interpolated onto:

if ~exist('xgrid', 'var') || isempty(xgrid)
    xgrid = x;
end


%%

%
indtop = NaN(1, cy);
indbot = NaN(1, cy);

% 
for i = 1:cy
    if any(~isnan(y(:, 1)))
        
        %
        indtop_aux = find(~isnan(y(:, i)), 1, 'first');
        indbot_aux = find(~isnan(y(:, i)), 1, 'last');
        
        %
        if ~isempty(indtop_aux);    indtop(i) = indtop_aux;    end
        if ~isempty(indbot_aux);    indbot(i) = indbot_aux;    end
        
    end
end

%
indtop(indtop==1) = NaN;
indbot(indbot==ry) = NaN;

%
ltop = ~isnan(indtop);
lbot = ~isnan(indbot);

% ---------------------------------------
% May want to be careful when there is only one non-NaN
% could also do a clever way without having to use a loop


% % % %% If input for interpolating up to a maximum gap was specified,
% % % % then check whether all NaNs (in columns that are not NaN-only)
% % % % are on the same rows. If they are, then we can run findwithinbound
% % % % only once rather than every time inside the loop:
% % % 
% % % if exist('maxgap', 'var')
% % %     
% % %     indycolsOK = find(~isnan(nanmean(y, 1)));
% % %     lyNaNrowsoncol1 = isnan(y(:, indycolsOK(1)));
% % %     lNaNblock = isnan(y(lyNaNrowsoncol1, indycolsOK));
% % % 
% % %     if all(lNaNblock(:))
% % %         lregularNaN = true;
% % %     else
% % %         lregularNaN = false;
% % %     end
% % % 
% % %     if lregularNaN
% % % 
% % %         allNaNinycolsOK = length(find(isnan(y(:, indycolsOK))));
% % %         allNaNinyNaNblock = (length(indycolsOK) * length(find(lyNaNrowsoncol1)));
% % % 
% % %         if allNaNinycolsOK == allNaNinyNaNblock
% % %         else
% % %             lregularNaN = false;
% % %         end
% % %     end
% % % 
% % % else
% % %     
% % %     % I could create a indycolsOK = 1:cy BEFORE THIS if block,
% % %     % such that the interpolation for loop does not have to
% % %     % go over NaN-only columns
% % %     
% % % end


%% Interpolate each column of y:

% Create yinterp for filling it:
% yinterp = NaN(length(xgrid), cy);
yinterp = y;

% Loop through columns:
for i = 1:cy
    
    % Get positions where we do NOT have NaNs:
    idat = find(~isnan(y(:, i)));
    
    % Proceed with interpolation only if there is more than one
    % data point (this is particularly necessary if the input
    % is a matrix and has columns with NaN only):
    if length(idat)>1
        
        %
        if ltop(i) || lbot(i)
            
            %
            if ltop(i)
                indtop_aux = 1:(indtop(i)-1);
            else
                indtop_aux = [];
            end

            if lbot(i)
                indbot_aux = (indbot(i)+1):ry;
            else
                indbot_aux = [];
            end
            
            %
            ind_aux = [indtop_aux, indbot_aux];
            
            % Now do the interpolation:
            yinterp(ind_aux, i) = interp1(x(idat), y(idat, i), ...
                                          x(ind_aux), exmethod, 'extrap');
             
        end
    
    end
    
end


%% If input y is a row vector, transpose yinterp
% such that output is also a row vector:

if lyrowvec
    yinterp = yinterp.';
end