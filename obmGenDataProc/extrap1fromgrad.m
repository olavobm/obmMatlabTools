function [x_extrap, zextrap_grid, deltax_gridded, bc] = extrap1fromgrad(z, x, zgrad, dxdz, dzgrid, zextrplims)
% [x_extrap, zextrap_grid, deltax_gridded, bc] = EXTRAP1FROMGRAD(z, x, zgrad, dxdz, dzgrid, zextrplims)
%
%   inputs
%       - zx: a vector
%       - x:
%       - zd: vector with the coordinate of dxdz.
%       - dxdz: vector or matrix.
%       - dzgrid:
%       - zextrplims:
%
%   outputs
%       - x_extrap
%       - zextrap_grid
%       - deltax_gridded
%       - bc: structure variable with three fields:
%               * indz: the indice of the boundary value of x.
%               * z: the value of z corresponding to the boundary.
%               * x: the boundary value.
%
%
%
% NaNs at both top and bottom are a huge problem...
% Perhaps I can add a threshold so that I restrict
% values are searched for
%
%
% Olavo Badaro Marques, 31/May/2019.


%% Check if there are NaNs in x

% % nNaNs_inx = find(isnan(x(:)));

%
if isempty(find(isnan(x), 1))
    
    lnoNaNs = true;
    
else
    
    lnoNaNs = false;
end

%%

Ncols = size(x, 2);


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


%% replicate deltaz if dxdz is scalar or vector... and x is a matrix
% ??????????


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
deltax = [NaN(1, Ncols); deltax];

%
for i = 1:Ncols
    
    %
% % %     indlast_zd = find(zgrad <= zdindz_lastx(i), 1, 'last');
% %     indlast_no_extrap = find(zextrap_grid <= zx_lastx(i), 1, 'last');

    %
    indbound_extrap = find(zextrap_grid > z_lastx(i), 1, 'first');
    
	%
% % %     dxdz_gridded(1:indbound_extrap, i) = NaN;
    
    % 
% % %     deltax(1:(indbound_extrap-1), i) = NaN;
    % This above works fine even when indbound_extrap is 1
    %
    % no it doesn't!!!!!! or it is, but then I need to another
    % row at the top later
    
    %
    deltax(1:indbound_extrap, i) = NaN;
    
    %
    indfirst_zgrad(i) = indbound_extrap;
    
    %
    zgrad_first4dxdz(i) = zgrad(indfirst_zgrad(i));
    
end


%% Find the mid point between the data boundary and the
% first level of the gradient and get the correspondent
% delta z


%
zmid_first = (z_lastx + zgrad_first4dxdz)./2;

%
dxdz_bound = NaN(1, Ncols);

% There is something wrong here......???
for i = 1:Ncols
    
    if zmid_first(i) < zmid_grid(1)
        
        dxdz_bound(i) = dxdz_gridded(1, i);
        
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
    
	% I guess this is just wrong
% %     deltax(indfirst_zgrad(i) - 1, i) = deltax_bound(i);
    
    %
    deltax(indfirst_zgrad(i), i) = deltax_bound(i);
    
end


%% Now integrate to calculate extrapolation change
% and put in the gridded interpolation matrix

deltax_gridded = NaN(length(zextrap_grid), Ncols);

%
for i = 1:Ncols
    
    %
    indcalc_aux = indfirst_zgrad(i):length(zextrap_grid);
    
	%
    deltax_gridded(indcalc_aux, i) = cumsum(deltax(indcalc_aux, i));
end


% STILL NEED TO ADD THE BOUNDARY VALUE!!!


%%

%
xbcvec = NaN(1, Ncols);

%
for i = 1:Ncols
    
	%
    xbcvec(i) = x(indz_lastx(i), i);
end


%%

x_extrap = repmat(xbcvec, length(zextrap_grid), 1) + deltax_gridded;


%% Organize output structure variable

% % %
% % zextrap_grid
% % x_extrap
% % 
% % %
% % deltax_gridded
% % 

%
bc.indz = indz_lastx;
bc.z = z_lastx;
bc.x = xbcvec;




