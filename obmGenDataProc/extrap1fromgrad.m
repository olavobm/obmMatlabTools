function [x_extrap, zextrap_grid, deltax_gridded, bcstrct] = extrap1fromgrad(z, x, zgrad, dxdz, dzgrid, zextrplims)
% [x_extrap, zextrap_grid, deltax_gridded, bcstrct] = EXTRAP1FROMGRAD(z, x, zgrad, dxdz, dzgrid, zextrplims)
%
%   inputs
%       - z: a vector
%       - x:
%       - zgrad: vector with the coordinate of dxdz.
%       - dxdz: vector or matrix.
%       - dzgrid:
%       - zextrplims:
%
%   outputs
%       - x_extrap
%       - zextrap_grid
%       - deltax_gridded
%       - bcstrct: structure variable with three fields:
%               * indz: the indice of the boundary value of x.
%               * z: the value of z corresponding to the boundary.
%               * x: the boundary value.
%
%
%
% TO DO:
%   - Create additional input for a threshold so that I restrict
%     values are searched for.
%   - This function currently ONLY works for extrapolation at
%     large z. I probably want to eliminate that restriction.
%
% Olavo Badaro Marques, 31/May/2019.


%% Check if there are NaNs in x

%
if isempty(find(isnan(x), 1))
    
    lnoNaNs = true;
    
else
    
    lnoNaNs = false;
end


%% Check inputs z and x

%
if isrow(x)
	x = x(:);
end

%
if isvector(z)
    
    %
    if z(end)<z(1)
        error(['Input z is not sorted (i.e. increasing with ' ...
               'increasing indices). It must be.'])
    end
    
    %
    if length(z)~=size(x, 1)
        error('Dimensions of the variable and its grid are not consistent.')
    end
else
    error('Grid of the data (i.e. first input) is not a vector. It must be.')
end

% Make sure it is a column vector
z = z(:);


%% Check inputs zgrad and dxdz

%
if isrow(dxdz)
	dxdz = dxdz(:);
end

%
if isvector(zgrad)
    
    if ~isscalar(dxdz)
        if length(zgrad)~=size(dxdz, 1)
            error('Dimensions of the variable and its grid are not consistent.')
        end
    end
    
else
    error('Grid of the gradient (i.e. third input) is not a vector. It must be.')
end


%% Check consistency between the dimensions of x and dxdz

%
Ncols = size(x, 2);

%
if ~isscalar(dxdz)
    if Ncols~=size(dxdz, 2)
        error(['The ``second dimension" (i.e. in practice, the ' ...
               'number of columns) of x and dxdz are not consistent.'])
    end
end

% THIS DOESN'T TAKE IT ACCOUNT THE POSSIBILITY THAT dxdz COULD
% BE A VECTOR (TIME-INDEPENDENT PROFILE). May or may not adapt
% for that case.


%% Now compare z with zextrplims to identify
% the direction of extrapolation
%
%


%
zxlims = [min(z), max(z)];

%
if max(zextrplims) >= zxlims(2)
	% Extrapolation at the end
    if min(zextrplims) < zxlims(1)
        error(['Extrapolation extending from the large end of z has ' ...
               'been identified, but the extrapolation grid extends ' ...
               'past the small end of z'])
    end
    
    %
    lextrap_end = true;
    
else
    % Extrapolation at the beginning
    if max(zextrplims) > zxlims(2)
        error(['Extrapolation extending below the small end of z has ' ...
               'been identified, but the extrapolation grid extends ' ...
               'past the large end of z'])
    end
    
    %
    lextrap_end = false;
    
    % Flip z and x so that extrapolation at the beginning is
    % calculated just like in the other case. The output
    % will then be flipped back at the end
    
    %
    z = flipud(z);
    x = flipud(x);
    
end


%%
% -------------------------------------------------------------------------
% ---------- DONE WIH CHECKING INPUTS, NOW START THE CALCULATIONS ---------
% -------------------------------------------------------------------------


%%

zextrap_grid = zextrplims(1) : dzgrid : zextrplims(2);
zextrap_grid = zextrap_grid(:);

%
zmid_grid = (zextrap_grid(1:end-1) + zextrap_grid(2:end))/2;


%% Calculate/interpolate gradient at the grid
% of the midpoints between the poits of the
% grid of extrapolation estimates

%
if isscalar(dxdz)
    
	%
    dxdz_gridded = dxdz .* ones(length(zmid_grid), Ncols);
    
else
    
    %
    dxdz_gridded = NaN(length(zmid_grid), Ncols);

    %
    for i = 1:Ncols

        %
        dxdz_gridded(:, i) = interp1overnans(zgrad, dxdz(:, i), zmid_grid);

    end
    
end

%
deltax = dzgrid * dxdz_gridded;

% If the extrapolation is towards small z, then
% dz for the integration should be negative
if ~lextrap_end
	deltax = - deltax;
end


%% Find the last row with non-NaN x, get its row indice,
% and the correspondent values of z and x there (i.e. the
% x value there is the boundary condition for the
% extrapolation)

% This 
if lnoNaNs
    
    % Repeat the last value of z and make it a vector
    % of length Ncols (the loop below would give the
    % same result)
    z_lastx = z(end) .* ones(1, Ncols);
    
else
    
	%
    indz_lastx = NaN(1, Ncols);

    %
    for i = 1:Ncols

        %
        indz_lastx(i) = find(~isnan(x(:, i)), 1, 'last');

    end

    %
    z_lastx = z(indz_lastx);
    z_lastx = z_lastx(:).'; % make it a row vector
    
end


%% Now remove the gradients at levels where we
% don't need to extrapolate and get the first
% level (i.e. boundary) where we do need to
% extrapolate

%
zgrad_first4dxdz = NaN(1, Ncols);
indfirst_zgrad = NaN(1, Ncols);

%
if lextrap_end
	deltax = [NaN(1, Ncols); deltax];
else
    deltax = [deltax; NaN(1, Ncols)];
end

%
for i = 1:Ncols
    
    %
    if lextrap_end
        %
        indbound_extrap = find(zextrap_grid > z_lastx(i), 1, 'first');
        
    else
        %
        indbound_extrap = find(zextrap_grid < z_lastx(i), 1, 'last');
        
    end
    
    %
    if lextrap_end
        deltax(1:indbound_extrap, i) = NaN;
    else
        deltax(indbound_extrap:end, i) = NaN;
    end
    
    %
    indfirst_zgrad(i) = indbound_extrap;
    
    %
% % %     I had this, but I think it was just wrong (though coincidentally
% working)
% %     zgrad_first4dxdz(i) = zgrad(indfirst_zgrad(i));
    zgrad_first4dxdz(i) = zextrap_grid(indfirst_zgrad(i));
    
end


%% Find the mid point between the data boundary and the
% first level of the gradient and get the correspondent
% delta z

%
zmid_first = (z_lastx + zgrad_first4dxdz)./2;

%
dxdz_bound = NaN(1, Ncols);

%
if lextrap_end
    %
    indbound_comp = 1;
    lzcomp_bound = zmid_first < zmid_grid(indbound_comp);
    
else
    %
    indbound_comp = length(zmid_grid);
    lzcomp_bound = zmid_first > zmid_grid(indbound_comp);
end

%
% % lzcomp_bound = zmid_first < zmid_grid(1);   % this is the original one

% 
for i = 1:Ncols
    
%     if zmid_first(i) < zmid_grid(1)
    if lzcomp_bound(i)
        
        dxdz_bound(i) = dxdz_gridded(indbound_comp, i);
        
    else
        dxdz_bound(i) = interp1(zmid_grid, dxdz_gridded(:, i), ...
                                zmid_first(i));
    end
    
end

%
dzfirst = zgrad_first4dxdz - z_lastx;


%%

deltax_bound = dxdz_bound .* dzfirst;


%% Put together the boundary with the interior extrapolation

%
for i = 1:Ncols

    %
    deltax(indfirst_zgrad(i), i) = deltax_bound(i);
    
end


%% Now integrate (i.e. calculate the extrapolation
% change) and get the boundary value

%
deltax_gridded = NaN(length(zextrap_grid), Ncols);

%
xbcvec = NaN(1, Ncols);

%
for i = 1:Ncols
    
    %
    if lextrap_end
        indcalc_aux = indfirst_zgrad(i):length(zextrap_grid);
    else
        indcalc_aux = 1:indfirst_zgrad(i);
        indcalc_aux = fliplr(indcalc_aux);
    end
    
	%
    deltax_gridded(indcalc_aux, i) = cumsum(deltax(indcalc_aux, i));
    
    %
    xbcvec(i) = x(indz_lastx(i), i);
    
end


%% Add boundary value to the change
% to get the extrapolated variable

x_extrap = repmat(xbcvec, length(zextrap_grid), 1) + deltax_gridded;


%% Organize output structure variable

%
bcstrct.indz = indz_lastx;
bcstrct.z = z_lastx;
bcstrct.x = xbcvec;




