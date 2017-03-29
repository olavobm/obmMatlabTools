function axshndls = makeSubPlots(mlx, mrx, mix, mty, mby, miy, nx, ny, lmake)
% axhndls = MAKESUBPLOTS(mlx, mrx, mix, mty, mby, miy, nx, ny)
%
%   inputs:
%       - mlx:
%       - mrx:
%       - mix:
%       - mty:
%       - mby:
%       - miy:
%       - nx:
%       - ny:
%       - lmake (optional): logical vector with false for the subplots
%                           you do not want to create (such that you
%                           can make an irregular grid of sublots).
%                           Default is true for all.
%
%   outputs:
%       - axshndls:
%
% Open a new figure and populate it with subplots.
%
%
% The subplots are created with the function axes. If you use the
% function subplot, it does not let you to make overlapping subplots.
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


%% Basics:

% Number of subplots:
N = nx*ny;

% Define default lmake it not given:
if ~exist('lmake', 'var')
	lmake = true(1, N);
end


%% Subplots size:

% Width:
sx = (1 - mlx - mrx - (nx-1)*mix) / nx;

% Height:
sy = (1 - mty - mby - (ny-1)*miy) / ny;


%% Now make the subplots, starting at top and
% moving across to right, line by line:

% Pre-allocate for output:
axshndls = NaN(1, N);

% Loop over the subplots:
for i = 1 : nx*ny
    
    if lmake(i)
        
        pthisx = rem(i, nx);
    
        if pthisx == 0
            pthisx = nx;
        end

        pthisy = (ny+1) - ceil(i/nx);

        % X position:
        xpos = mlx + ((pthisx-1) * (sx+mix));
        ypos = mby + ((pthisy-1) * (sy+miy));

        % Now create the axes:
        axshndls(i) = axes('Position', [xpos ypos sx sy]);      
    end
	   
end


% Remove NaNs from output (which exist if not all subplots are used):
axshndls = axshndls(~isnan(axshndls));
