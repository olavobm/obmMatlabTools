function yinterp = interp1overnans(x, y, xgrid)
%% [yinterp] = INTERP1OVERNANS(x, y, xgrid)
%
%  inputs:
%    - x: location of data points of y along the interpolation dimension.
%    - y: vector or matrix.
%    - xgrid (optional): locations where we want to interpolate data.
%
% THINK ABOUT THE XGRID INPUT!!! XGRID OR ROW INDICES????? OR BOTH????
%
%  outputs:
%    - yinterp: 
%
%  This function uses Matlab's interp1 function to interpolate
%  a vector, or each column of a matrix, when NaNs are present.
%  The default behavior is to don't extrapolate (the extrapolation
%  option is commented below for "backwards compatibility"). 
%
%  Olavo Badaro Marques -- 07/Oct/2015, created.
%                          25/Oct/2016, updated, implemented different grid 
%                                       recheck old scripts that call older
%                                       version. I also removed an extra
%                                       useless output

%% Get size of the variable to be interpolated:
[ry, cy] = size(y);

% If y was specified as a row vector, then
% transpose it and update the size of it:
if ry == 1 && cy > 1
    y = y(:);
%     ry = cy;
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
    lycol1NaNrows = isnan(y(:, indycolsOK(1)));
    lNaNblock = isnan(y(lycol1NaNrows, indycolsOK));

    if all(lNaNblock(:))
        lregularNaN = true;
    else
        lregularNaN = false;
    end

    if lregularNaN

        allNaNinycolsOK = length(find(isnan(y(:, indycolsOK))));
        allNaNinyNaNblock = (length(indycolsOK) * length(lycol1NaNrows));

        if allNaNinycolsOK == allNaNinyNaNblock
        else
            lregularNaN = false;
        end
    end

else
    
    
end



%% Interpolate each column of y:

% Create yinterp for filling it:
yinterp = NaN(length(xgrid), cy);  % MAKE SURE THIS WORKS!

% Loop through columns:
for i = 1:cy
    
    % Get positions where we do NOT have NaNs:
    idat = find(~isnan(y(:, i)));
    
    % Proceed with interpolation only if there is more than one
    % data point (this is particularly necessary if the input
    % is a matrix and has columns with NaN only):
    if length(idat)>1
            
        % Now do the interpolation:
        yinterp(:, i) = interp1(x(idat), y(idat, i), xgrid);
    
    end
    
end

