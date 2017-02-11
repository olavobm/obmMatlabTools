function axshndls = makeSubPlots(mlx, mrx, mix, mty, mby, miy, nx, ny)
% axhndls = MAKESUBPLOTS(mlx, mrx, mix, mty, mby, miy, nx, ny)
%
%   inputs:
%       - mlx
%       - mrx
%       - mix
%       - mty
%       - mby
%       - miy
%       - nx
%       - ny
%
%   outputs:
%       - axshndls:
%
% Open a new figure and 
%
% Return handles to axes of equal size.  Specify the offsets at left,
% right, top and bottom, as well as between panes.  Also specify the
% number of panes in x and y direction. The routine will compute the
% correct size for each pane, and  create the axes for them in the
% current figure. They are ordered starting at top, and moving across
% to the right (same as MATLAB's Subplot).
%
% Based on MySubplot.m by Matthew H. Alford.
%
% Olavo Badaro Marques, 10/Feb/2017.


%% Pane sizes:

% Width:
sx = (1 - mlx - mrx - (nx-1)*mix) / nx;

% Height:
sy = (1 - mty - mby - (ny-1)*miy) / ny;


%% Now make the panes, starting at top and moving across to right

N = nx*ny;

axshndls = NaN(1, N);

% Loop over the subplots:
for pthis = 1 : nx*ny
    
	pthisx = rem(pthis, nx);
    
    if pthisx == 0
		pthisx = nx;
    end
    
	pthisy = (ny+1) - ceil(pthis/nx);

    % X position:
    xpos = mlx+(pthisx-1)*(sx+mix);
    ypos = mby+(pthisy-1)*(sy+miy);
    
	% Now create the axes:
	axshndls(pthis) = axes('Position', [xpos ypos sx sy]);
    
end	