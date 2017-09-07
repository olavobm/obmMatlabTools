function inds = click4nearest(x, y, npts)
% inds = CLICK4NEAREST(x, y, npts)
%
%   inputs
%       - x: x coordinates (matrix or vector).
%       - y: y      ".
%       - npts: number of points to select.
%
%   outputs
%       - inds: indices of the (x, y) coordinate closest
%               to points selected with the mouse.
%
% 
%
% Note that the closest points are defined in terms of euclidean distance.
%
% Olavo Badaro Marques, 07/Sep/2017.


%% Select points with the mouse

[xaux, yaux] = ginput(npts);


%% Find the closest points

inds = dsearchn([x(:), y(:)], [xaux, yaux]);

