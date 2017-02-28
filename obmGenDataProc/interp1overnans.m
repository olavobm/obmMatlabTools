function yinterp = interp1overnans(x, y, xgrid, maxgap)
%% [yinterp] = INTERP1OVERNANS(x, y, xgrid, maxgap)
%
%   inputs:
%       - x: location of data points of y along the
%            interpolation dimension.
%       - y: vector or matrix.
%       - xgrid (optional): locations where we want to interpolate data.
%       - maxgap (optional): the maximum distance between data points that
%                            will be interpolated through. If you give this
%                            input, then xgrid input must be specified.
%
%   outputs:
%       - yinterp: y interpolated on x/xgrid.
%
% This function uses Matlab's interp1 function to interpolate a
% vector, or each column of a matrix, when NaNs are present. No
% extrapolation is done.
%
% The interpolation for a maximum gap is achieved thanks to my other
% function findwithinbound.m, which identifies whether a grid point
% is within a bound (maxgap) from the closest data points.
%
% Olavo Badaro Marques, 07/Oct/2015, created.
%                       25/Oct/2016, updated, implemented different grid 
%                                    recheck old scripts that call older
%                                    version. I also removed an extra
%                                    useless output


%% Get size of the variable to be interpolated:

[ry, cy] = size(y);

% If y was specified as a row vector, then
% transpose it and update the size of it:
if ry == 1 && cy > 1
    y = y(:);
%     ry = cy;   % ry is not used anymore, so it does not matter
    cy = 1;
end


%% 1D grid where data will be interpolated onto:

if ~exist('xgrid', 'var')
    xgrid = x;
end


%% If input for interpolating up to a maximum gap was specified,
% then check whether all NaNs (in columns that are not NaN-only)
% are on the same rows. If they are, then we can run findwithinbound
% only once rather than every time inside the loop:

if exist('maxgap', 'var')
    
    indycolsOK = find(~isnan(nanmean(y, 1)));
    lyNaNrowsoncol1 = isnan(y(:, indycolsOK(1)));
    lNaNblock = isnan(y(lyNaNrowsoncol1, indycolsOK));

    if all(lNaNblock(:))
        lregularNaN = true;
    else
        lregularNaN = false;
    end

    if lregularNaN

        allNaNinycolsOK = length(find(isnan(y(:, indycolsOK))));
        allNaNinyNaNblock = (length(indycolsOK) * length(find(lyNaNrowsoncol1)));

        if allNaNinycolsOK == allNaNinyNaNblock
        else
            lregularNaN = false;
        end
    end

else
    
    % I could create a indycolsOK = 1:cy BEFORE THIS if block,
    % such that the interpolation for loop does not have to
    % go over NaN-only columns
    
end


%% If there is a maxgap and the NaNs are distributed on the
% same rows for every column (except for NaN-only columns),
% then define which indices of xgrid are between and close
% enough to the good data locations:


if exist('maxgap', 'var') && lregularNaN
        
    lyOK = ~lyNaNrowsoncol1;

    ind2interp = findwithinbound(x(lyOK), xgrid, maxgap);
    
end



%% Interpolate each column of y:

% Create yinterp for filling it:
yinterp = NaN(length(xgrid), cy);

% Loop through columns:
for i = 1:cy
    
    % Get positions where we do NOT have NaNs:
    idat = find(~isnan(y(:, i)));
    
    % Proceed with interpolation only if there is more than one
    % data point (this is particularly necessary if the input
    % is a matrix and has columns with NaN only):
    if length(idat)>1
        
        if ~exist('maxgap', 'var')
            ind2interp = 1:length(xgrid);
        elseif exist('maxgap', 'var') && ~lregularNaN
            ind2interp = findwithinbound(x(idat), xgrid, maxgap);
        else
            % in this case, ind2interp is defined before the loop.
            % The other case, ~exist('maxgap', 'var') & lregularNaN
            % never exists.
        end
        
        % Now do the interpolation:
        yinterp(ind2interp, i) = interp1(x(idat), y(idat, i), xgrid(ind2interp));
    
    end
    
end

