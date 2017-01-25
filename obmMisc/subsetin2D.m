function [zpts, xygpts] = subsetin2D(xypts, x, y, z, rlim)
% [zpts, xygpts] = subsetin2D(xypts, x, y, z, rlim)
%
%   inputs:
%       - xypts: Nx2 array.
%       - x:
%       - y:
%       - z:
%       - rlim (optional): radius 
%
%   outputs:
%       - zpts: subsetted values of input z.
%       - xygpts: values of (x, y) associated with zpts,
%                 i.e. the closest (x, y) to xypts.
%
% For a matrix z, whose values are speficied at (x, y), SUBSETIN2D
% z at the points xypts. The subsetting is done by a Matlab function
% called dsearchn.
% 
% If you have a plot of z, you may as well call the function
% subsetfrom2Dplot.m which uses ginput to get the point xypts.
%
% I SHOULD ADD ANOTHER OPTION: ALLOWING XYPTS TO BE A 1X4 VECTOR, SUCH THAT
% I SUBSET A RECTANGLE FROM Z AND NO DSEARCHN IS USED.
%
% Olavo Badaro Marques, 04/Jan/2017.

% SUGGESTIONS of things to do:
%           - rlim could be a vector.
%           - x and y matrices or vectors that
%             already contain all grid points.
%           - I could also include interpolation to get
%             values right on top ox xypts


%% Check whether optional input rlim was specified:

if ~exist('rlim', 'var')
    rlim = NaN;    
end


%% If x and y are vectors, assume the grid is regular
% and we create it so we can subset z on it:

if isvector(x) && isvector(y)
    [xg, yg] = meshgrid(x, y);
    xyall = [xg(:), yg(:)];
end


%% Subset z at the closest (x, y) to xypts:

[indpts, distpts] = dsearchn(xyall, xypts);

zpts = z(indpts);
xygpts = xyall(indpts, :);


%% If rlim was specified, then NaN z values that
% are outside the circle of radius rlim:

if ~isnan(rlim)
	ltoofar = distpts > rlim;
    zpts(ltoofar) = NaN;
end

