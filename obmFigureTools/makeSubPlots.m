function axshndls = makeSubPlots(mlx, mrx, mix, mty, mby, miy, nx, ny, lmake)
% axhndls = MAKESUBPLOTS(mlx, mrx, mix, mty, mby, miy, nx, ny, lmake)
%
%   inputs
%       - mlx: left margin (in normalized units).
%       - mrx: right margin (in normalized units).
%       - mix: x spacing between subplots.
%       - mty: top margin.
%       - mby: bottom margin.
%       - miy: y spacing between subplots.
%       - nx: number of subplot columns.
%       - ny: number of subplot rows.
%       - lmake (optional): logical vector with false for the subplots
%                           you do not want to create (such that you
%                           can make an irregular grid of sublots).
%                           Default is true for all.
%
%   outputs
%       - axshndls: axes handles of the created subplots.
%
% Create subplot array on the current figure and return the
% correspondent axes handles (ordered from the top and moving
% to the right).
%
% The subplots are created with the function axes. If you use the
% function subplot, it does not let you to make overlapping subplots.
%
% Based on MySubplot.m by Matthew H. Alford.
%
% See also: SYMSUBARRAY.m
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
% % axshndls = NaN(1, N);
axshndls = gobjects(1, N);

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

% Remove empty graphic objects (which return false for isgraphics)
axshndls = axshndls(isgraphics(axshndls));
