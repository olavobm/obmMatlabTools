function [hp, arrPar] = plotArrows(s, x, y, u, v, varargin)
% [hp, arrPar] = PLOTARROWS(s, x, y, u, v, varargin)
%
%   inputs
%       - s: scale (should it be the same as m_map? arrows per inch?)
%       - x: MxN position of the vector tails.
%       - y: x position of the vector tails.
%       - u: x-component of the vectors.
%       - v: y-    "     "   "     "
%       - varargin (optional): Parameters to control the
%                              appearance of the arrows
%
%   outputs
%       - hp: arrows handle.
%       - arrPar: parameters of the plotted arrows.
%
% Function PLOTARROWS plots a two-dimensional vector field (u, v) given
% at (x, y). The input s sets the scale of the arrows: larger values make
% smaller arrows (relative to the axes).
% 
% When plotting a vector field, we often plot the vectors on a (x, y)
% coordinate system, which is different than the (u, v) coordinate system.
% Because of that, we need to specify make the plot for a particular aspect
% ratio (before calling this function, call initAxesFreezeAspectRatio.m).
% Function PLOTARROWS, only deals with cartesian coordinate systems, so
% the planes (x, y) and (u, v) differ only by a translation/stretching.
% 
%
%   Optional arrow parameters:
%         'headangle',60     degrees: angle of arrow tip
%         'HeadWidth',NaN    points: direct specification of
%                                width, instead of headangle
%         'HeadLength',5     points: length of tip; set to 0
%                                to omit arrowhead entirely
%         'ShaftWidth',1     points: width of arrow shaft
%         'centered', 'no'   'yes' to make x,y the arrow
%                                center instead of its tail
%         'key', ''          make a labelled horizontal arrow
%                                if the string is not empty;
%                                then the string labels the
%                                arrow, and the second argument
%                                returned, ht, is the handle of
%                                the string.
%          'edgeclip', 'off'  If 'on' then arrows IN the axes
%                             are clipped if their heads are
%                             OUT of the axes.
%
%      optional patch parameters: any valid patch properties
%         may be specified here; they are passed directly
%         to the patch function.
%
%        U,V are vectors containing the east and north components
%                 of the arrows.
%        C is an optional colorspec for all arrows, or an
%                 array of CData, one value per arrow.
%                 Defaults to black.
%
%      optional arrow parameters: keyword-value pairs, shown
%                 here with default values:
%
% - It would be nice to make the scale input more intuitive, but I can
%   still try a few values for a specfic plot to look good.
% - zooming in the figure is a problem (that I may not want to tackle)!
%
% PLOTARROWS.m is a modified version of m_quiver.m, from the
% toolbox m_map by Rich Pawlowicz (https://www.eoas.ubc.ca/~rich/map.html),
% allowing it to be used outside of m_map plots.
%
% See also: makeArrowPlot.m.
%
% Olavo Badaro Marques, 12/Dec/2016.


%% Demo:
if nargin==0,  % demo
    
	plotArrows(100, [-133 -133], [49 49], [0 50], [100 0.0]);
    
    % Terminate function execution:
    return
end


%% Parse varargin

% % Other options t
% centered = 0;
% headwidth  = NaN;
% headangle = 40;
% key = '';

%
p = inputParser;

%
defltHeadLength = 200;   % have to find what is a good default
defltShaftWidth = 1/70;  % relative to the plot dimensions
defltColor = 'k';
defltAxes = [];
defltStep = 1;

%
addParameter(p, 'HeadLength', defltHeadLength)
addParameter(p, 'ShaftWidth', defltShaftWidth)
addParameter(p, 'Color', defltColor)
addParameter(p, 'Axes', defltAxes)
addParameter(p, 'Xstep', defltStep)
addParameter(p, 'Ystep', defltStep)

% Fill variable p with default values or input specifications:
if ~isempty(varargin) && iscell(varargin{1})
    parse(p, varargin{1}{:})
else
    parse(p, varargin{:})
end


%% If plotting on Axes specified, make those current

if ~isempty(p.Results.Axes)
    axes(p.Results.Axes)
end


%%

% % % Default arrow parameters:
% % centered = 0;
% % headlength = 5/72;
% % headwidth  = NaN;
% % headangle = 40;
% % shaftwidth = 1/72;
% % c = 'k';
% % key = '';


% Mooring T7:
centered = 0;
headlength = p.Results.HeadLength;
headwidth  = NaN;
headangle = 40;
shaftwidth = 1/150;
c = p.Results.Color;
key = '';

clip = 'on';       % except for the key
edgeclip = 'off';  % for arrows at the edge


if nargin < 5,   % Minimum: s,x,y,u,v
    error('not enough input arguments');
end

% Here is where the scale input comes into play. UVperInc is the
% magnitude of vector (u, v) per inch (the bigger the value, the
% smaller the vector):
UVperIn = s;     


%% If x/y are vectors of a regular grid, then create all (x, y)
% points of the grid to have arrays the same size as (u, v)

if isvector(x) && isvector(y) && ~isvector(u)
    
    [xg, yg] = meshgrid(x, y);
    
    x = xg;
    y = yg;
    
    %
    x = x(1:p.Results.Ystep:end, 1:p.Results.Xstep:end);
    y = y(1:p.Results.Ystep:end, 1:p.Results.Xstep:end);
    
    u = u(1:p.Results.Ystep:end, 1:p.Results.Xstep:end);
    v = v(1:p.Results.Ystep:end, 1:p.Results.Xstep:end);
    
    lstepped = true;
    
else
    
    lstepped = false;
    
end


%% Make sure the variables are column vectors:

x = x(:);
y = y(:);

u = u(:);
v = v(:);


%% In case variables have not been subsetted
% (i.e. in the case where x/y are vectors of a
% regular grid), then subset them now

if ~lstepped
    
    x = x(1:p.Results.Xstep:end);
    y = y(1:p.Results.Xstep:end);
    u = u(1:p.Results.Xstep:end);
    v = v(1:p.Results.Xstep:end);
    
end


%% Begin the slightly complicated parsing of arguments.
% One cause of complexity is that the optional argument c
% could be either character or numeric.

% I SHOULD DO THIS RIGOROUSLY!!!!!

keyvars = {};  % This will hold keyword/value pairs.
nvarargin = length(varargin);

% Find the index of the first string argument in varargin.
istr0 = 0;
% % for ii = 1:nvarargin
% %     if ischar(varargin{ii})
% %         istr0 = ii;
% %         break
% %     end
% % end

%
if istr0 > 0     % There are strings.
    if rem(nvarargin - istr0, 2) == 0,  % an odd number
      c = varargin{istr0};             % should be a colorspec string
      istr0 = istr0 + 1;
    end

    % istr0: start of keyword/value pairs.
    n_numeric = istr0 - 1;  % Actually, numeric or colorspec.
    keyvars = varargin(istr0:nvarargin);
    finished = 0;

    while ~isempty(keyvars) && ~finished,
        kv = lower(keyvars{1});
        value = keyvars{2};
        if     strcmp(kv, 'headlength')
            headlength = value/72;
            
        elseif strcmp(kv, 'headwidth')
            headwidth = value/72;
            
        elseif strcmp(kv, 'headangle')   % WTF IS THIS??????
            headangle = value;

        elseif strcmp(kv, 'shaftwidth')
            shaftwidth = value/72;
            
        elseif strcmp(kv, 'centered') && lower(value(1)) == 'y',
            centered = 1;
            
        elseif strcmp(kv, 'key')
            key = value;
            clip = 'off'; % Can put key outside the map.
            
        elseif strcmp(kv, 'edgeclip')
            edgeclip = value;
        else
            finished = 1;  % no match; break out
        end
        
        if ~finished,
            keyvars(1:2) = [];
        end
    end
else
    n_numeric = nvarargin;
end


%%
z = zeros(size(u));


%%
[nr,nc] = size(c);
if nr == 1 && nc == length(u) && (nc ~= 3 || (any(c<=1) || any(c>=0))),
    c = c(:);
end
% c could be a 1x3 colorspec


%% Calculate the headwidth if it is not given explicitly:

if isnan(headwidth) && headangle < 170 && headangle > 0
    headwidth = headlength * tan(headangle*pi/180);
end
headwidth = max([headwidth; p.Results.ShaftWidth]);


%% Replicate x/y if there is lots of u/v specified at only one x/y:
if (length(x) == 1 && length(y) == 1 && length(u) > 1)
    x = x(ones(size(u)));
    y = y(ones(size(u)));
end


%% Take care of the data scaling
% according to the axes aspect ratio (I DON'T THINK SO ANYMORE):


OrigAxUnits = get(gca,'Units');  % THIS IS WHERE THE FIGURE IS CREATED (IF
                                 % THERE IS NO FIGURE ALREADY). Kind of
                                 % sketchy...
        
% ??????????????? This is for scaling the data appropriately,
% but I still don't really understand it ???????????????????????????
% Obtain width and length (which form the aspect ratio) in real units
% (inches) to scale the arrows appropriately:
if strcmp(OrigAxUnits, 'normalized')
    
    OrigPaUnits = get(gcf, 'PaperUnits');       
    set(gcf, 'PaperUnits', 'inches');
    figposInches = get(gcf, 'PaperPosition');
    set(gcf, 'PaperUnits', OrigPaUnits);
    axposNor = get(gca, 'Position');
    axWidLenInches = axposNor(3:4) .* figposInches(3:4);
else
    
    set(gca, 'Units', 'inches');
    axposInches = get(gca, 'Position');
    set(gca, 'Units', OrigAxUnits);
    axWidLenInches = axposInches(3:4);
end
% ??????????????????????????????????????????????????????????????????


% Multiply inches by the following to get data units:
scX = diff(get(gca, 'XLim')) / axWidLenInches(1);
scY = diff(get(gca, 'YLim')) / axWidLenInches(2);
sc = max([scX; scY]);  % max selects the dimension limited by
                       % the plot box.

Width = sc * p.Results.ShaftWidth;
HeadWidth = headwidth*sc;
HeadLength = headlength*sc;

uvmag = abs(u + 1i*v);

% Arrow lengths in plot data units:
arrowpltlen = uvmag*sc / UVperIn;

% Base of arrows.
% Don't plot if base of the arrows is outside boundaries
% (except for keys for which clip is off)
% [xs, ys] = m_ll2xy(x, y, 'clip', clip);
xs = x;
ys = y;


% Vector angles (angle(w) is the same as atan2(sin(w), cos(w)) ):
% As far as I understand the cos on ysp calculation should take
% the latitude into account, but I do not understand, because at
% the poles the velocity should be southward only: 
xsp = [x, x + 0.00001*u./uvmag]';
ysp = [y, y + 0.00001*v.*cos(y*pi/180)./uvmag]';

Ang = angle( diff(xsp)' + 1i*diff(ysp)' );

% AS FAR AS I GUESS, THIS Ang VARIABLE IT THE PLOTTING ANGLE
% IN A CARTESIAN COORDINATE SYSTEM, Ang SHOULD BE THE SAME AS:
%   angle(u + 1i*v)


% If there is a key (labeled arrow), then we create
% a horizontal arrow, which has Ang==0:
if ~isempty(key)
    Ang = 0;
end

% Create zero vector (such that we can create a constant vector
% by simply adding a constant to the zero vector):
narrows = length(arrowpltlen);
zerovec = zeros(narrows, 1);

% Normal arrow dimensions:
HL = zerovec + HeadLength;
HW = zerovec + HeadWidth;
W =  zerovec + Width;


%% Distinguish zero-length vectors from non-zero:

mm = (arrowpltlen < 100*eps);   % eps is Matlab's floating point number "resolution"
i_zero = find(mm);
i_nonzero = find(~mm);

% Don't plot if length is zero.
if ~isempty(i_zero)
   HL(i_zero) = NaN;
   HW(i_zero) = NaN;
   W(i_zero) = NaN;
end


%% Take into account arrows that (1) do not have arrow heads
% or (2) are too small such that it is better to not include a shaft:

if ~isempty(i_nonzero)
    ii = i_nonzero;
    if HeadLength == 0,   % no arrowhead; square end
        W(ii)  = Width;
        HW(ii) = Width;
        HL(ii) = zerovec(ii);  % Thanks for Pierre Jaccard for this fix
    else
        % If the arrow length is less than the headlength,
        % omit the arrow shaft and just plot a head scaled
        % to the length.
        i_short = ii( arrowpltlen(ii) < HeadLength );
        W(i_short)  = 0;
        HL(i_short) = arrowpltlen(i_short);
        HW(i_short) = HL(i_short) * (HeadWidth/HeadLength);
    end
end


%%
% Just a change of variable names for historical reasons:
Y = ys;
X = xs;
% It is not clear whether non-zero elevations will be useful;
% that depends on whether the entire m_map system will work
% with 3-D views, as in making a surface plot of topography.
% Then one might want to have a current profile represented
% as a stack of vectors at appropriate heights above the topog.
Z = z(:);


%% Create the matrix (Vert) that contains the coordinates of the arrows
% vertices. Vert is a (7*narrows by 3) array, where columns 1, 2 and 3
% are for the x, y and z coordinates, respectively, and each set of 7
% subsequent rows gives the 7 vertices of an arrow. Vert is first created
% for arrows with 0 angle and starting from the origin (translation and
% rotation are applied later). Since an arrow is a symmetric object, the
% "bottom" of the (horizontal) arrow (i.e. the last 3 rows of each 7-row
% set) are the symmetric counterpart of the first 3 rows (the arrow "top"):

% An option I'm not particularly interested...
Xzero = zerovec;
if centered
   Xzero = -arrowpltlen/2;
end

% Pre-allocate space for the vertices matrix:
nV = 7*narrows;  % 7 vertices per arrow
Vert = zeros(narrows, 3);

% Back corner of shaft (arrow tail's corner):
Vert(1:7:nV, :) = [Xzero,  W/2, Z];

% Shaft-head junction:
Vert(2:7:nV, :) = Vert(1:7:nV, :) + ...
                  [(arrowpltlen-HL), zerovec,  zerovec];
              
% "Shoulder" point of the arrow head:
Vert(3:7:nV, :) = Vert(2:7:nV,:) + ...
                  [zerovec, (HW-W)/2,  zerovec];
              
% Tip of arrow:
Vert(4:7:nV, :) = [Xzero + arrowpltlen, zerovec, Z];


% Now create the symmetric vertices of the arrow:
%
% First replicate all coordinates:
Vert(5:7:nV, :) = Vert(3:7:nV, :);
Vert(6:7:nV, :) = Vert(2:7:nV, :);
Vert(7:7:nV, :) = Vert(1:7:nV, :);
%
% Take the negative of the y coordinate to reflect about the x axis:
Vert(5:7:nV, 2) = -Vert(5:7:nV, 2);
Vert(6:7:nV, 2) = -Vert(6:7:nV, 2);
Vert(7:7:nV, 2) = -Vert(7:7:nV, 2);


%% Calls arrowPlotTransform, which rotates and translates the
% arrows according to the current axes limits and aspect ratio:

% Aspect ratio:
asprtoaux = pbaspect;  % maybe it must be normalized (???)
lenhei = asprtoaux(1:2);

% Must transform Vert to 2xN array:
%
% % uv is a 2xN array, first (second) row is u (v):
% uv = [u'; v'];
uv = Vert(:, 1:2);
uv = uv';

% Axes limits:
xylims = axis;
xyran = [xylims(2)-xylims(1), xylims(4)-xylims(3)];

% Vector tail position:
xaux = x';
yaux = y';

xaux2 = xaux(ones(7, 1), :);  % same as repmat(xaux, 7, 1)
yaux2 = yaux(ones(7, 1), :);

xy0 = [xaux2(:), yaux2(:)];
xy0 = xy0';

%
uvdir = atan2(v', u');
uvdirvert = uvdir(ones(7, 1), :);
uvdirvert = uvdirvert(:);
uvdirvert = uvdirvert';

%
[uvtrans] = arrowPlotTransform(uv, lenhei, xyran, xy0, uvdirvert);


%% Assign trasnformed vertices to the Vert array:

Vert(:, 1) = uvtrans(1, :)';
Vert(:, 2) = uvtrans(2, :)';



%% Create an array that goes as the "Faces" input of the patch
% function. It is a (narrows by 7) array, with numbers 1:nV:

Faces = 1:nV;
Faces = Faces';

Faces = reshape(Faces, 7, narrows);
Faces = Faces';


%% Finally plot the arrows:

% Extremely narrow patches don't show up on the screen (although they seem
% to be printed OK) when EdgeColor is 'none', so when the arrows are all
% the same color, set the EdgeColor to be the same as FaceColor.
% Set clip off here so arrows are complete - RP 7/Jun/06

% Request to clip arrows at the plot edge.

if strcmp(edgeclip, 'off')

    % If axes was specified, make it current. Note that in newer (>2015)
    % Matlab versions, the axes handle can be specified as the first
    % input of the plotting function (patch in this case).
    %
    % This would be more appropriate because changing current axes
    % inside a loop can be problematic.
    if ~isempty(p.Results.Axes)
        axes(p.Results.Axes)
    end
    
    %
    hp = patch('Faces', Faces, 'Vertices', Vert, 'clipping', 'off');
	
else
% %   [LG,LN]=m_xy2ll(reshape(Vert(:,1),7,nvec),reshape(Vert(:,2),7,nvec)); % Converts vertices in 7 point lines (i.e. columns) in lat/long
% %   [X,Y]=m_ll2xy(LG,LN  ,'clip','patch');                                % Converts back to x/y, but does clipping on for each column
%     hp = patch('Faces', Faces, 'Vertices', [X(:) Y(:)], ...
%                                         'tag', 'm_vec');
                                    
	% m_vec has a clipping/off in the else case, but it
    % seems unnecessary to me.
end;


% Set color of the arrows:
if ischar(c) || (size(c,1) == 1 && size(c,2) == 3),
    set(hp, 'EdgeColor', c, 'FaceColor', c, 'LineWidth', 0.1);
else
    set(hp, 'EdgeColor', 'none', 'FaceColor','Flat', ...
                                        'FaceVertexCdata', c);
end

% Set other properties of the arrow:
if ~isempty(keyvars)
    set(hp, keyvars{:});
end


if ~isempty(key)
    ht = text(X(1), Y(1)-0.5*HW, Z(1), key, ...
            'color', c, 'horiz','left','vert','top', 'tag','m_vec', ...
                                                    'clipping','off');
    set(hp,'clipping','off')
else
    ht = [];
end



%% Clear outputs (basically, this is only useful because it does not
% print to screen when you call this function without ;
if nargout==0
    clear hp ht
end

