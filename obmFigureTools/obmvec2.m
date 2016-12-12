function [hp, ht] = obmvec2(s, x, y, u, v, varargin)
%
%      VARARGIN can consist of any of the following:
%        U,V   U,V,C   Z,U,V,C
%      followed by optional arrow parameters,
%      followed by optional patch parameters.
%        U,V are vectors containing the east and north components
%                 of the arrows.
%        C is an optional colorspec for all arrows, or an
%                 array of CData, one value per arrow.
%                 Defaults to black.
%
%      optional arrow parameters: keyword-value pairs, shown
%                 here with default values:
%
%           etc ...............


%% Demo:
if nargin==0,  % demo
    
%     obmvec2(100, [-133 -133], [49 49], [0 50], [100 0.0],...
%           [0.7 0.8 0.9],'centered','yes', ...
%           'shaftwidth', 5, 'headlength', 0,...
%           'EdgeColor','k');
      
	obmvec2(100, [-133 -133], [49 49], [0 50], [100 0.0]);
    
    % Terminate function (does not got beyond this if block):
    return
end


%%

% Default arrow parameters:
centered = 0;
headlength = 5/72;
headwidth  = NaN;
headangle = 40;
shaftwidth = 1/72;
c = 'k';
key = '';

clip = 'on';       % except for the key
edgeclip = 'off';  % for arrows at the edge


if nargin < 5,   % Minimum: s,x,y,u,v
    error('not enough input arguments');
end

UVperIn = s;     % THIS IS WHERE THE INPUT SCALE COMES INTO PLAY.

% Make sure the variables are column vectors:
x = x(:);
y = y(:);

u = u(:);
v = v(:);

%% Begin the slightly complicated parsing of arguments.
% One cause of complexity is that the optional argument c
% could be either character or numeric.

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
headwidth = max([headwidth; shaftwidth]);




%% Replicate x/y if there is lots of u/v specified at only one x/y:
if (length(x) == 1 && length(y) == 1 && length(u) > 1)
    x = x(ones(size(u)));
    y = y(ones(size(u)));
end


%% Take care of the data scaling according to the axes aspect ratio:


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

Width = shaftwidth*sc;
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
nvec = length(arrowpltlen);
zerovec = zeros(nvec, 1);

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


% Just a change of variable names for historical reasons:
Y = ys;
X = xs;
% It is not clear whether non-zero elevations will be useful;
% that depends on whether the entire m_map system will work
% with 3-D views, as in making a surface plot of topography.
% Then one might want to have a current profile represented
% as a stack of vectors at appropriate heights above the topog.
Z = z(:);

keyboard

Xzero = zerovec;
if centered,
   Xzero = -arrowpltlen/2;
end


nV = 7*nvec;  % number of Vertices: 7 per arrow.
Vert = zeros(nvec,3);

Vert(1:7:nV,:) =  [Xzero,  W/2, Z ];       % back corner of shaft
Vert(2:7:nV,:) = Vert(1:7:nV,:) + ...
                 [(arrowpltlen-HL), zerovec,  zerovec];    % shaft-head junction
Vert(3:7:nV,:) = Vert(2:7:nV,:) + ...
                 [zerovec, (HW-W)/2,  zerovec];  % point of barb
Vert(4:7:nV,:) = [Xzero + arrowpltlen, zerovec, Z];     % tip of arrow



%% This could be done more efficiently with fancier indexing, but
% it is probably not a bottleneck, hence not worth the trouble:

% Reflect the top half to get the bottom half.
% First replicate:
Vert(5:7:nV,:) = Vert(3:7:nV,:);
Vert(6:7:nV,:) = Vert(2:7:nV,:);
Vert(7:7:nV,:) = Vert(1:7:nV,:);
% Then negate y to reflect:
Vert(5:7:nV,2) = -Vert(5:7:nV,2);
Vert(6:7:nV,2) = -Vert(6:7:nV,2);
Vert(7:7:nV,2) = -Vert(7:7:nV,2);

% Make an index array for operating on all vertices of each vector:
ii = (1:nvec);
ii = ii(ones(7,1),:);
ii = ii(:);


%% Rotate:
Vxy = exp(1i*Ang(ii)).*(Vert(:,1) + 1i*Vert(:,2));


%% Translate:
Vxy = Vxy + X(ii) + 1i*Y(ii);


%%
Vert(:,1) = real(Vxy);
Vert(:,2) = imag(Vxy);


Faces = [1:nV].';            %Top
Faces = reshape(Faces, 7, nvec).';

% Extremely narrow patches don't show up on the screen (although they seem
% to be printed OK) when EdgeColor is 'none', so when the arrows are all
% the same color, set the EdgeColor to be the same as FaceColor.
% Set clip off here so arrows are complete - RP 7/Jun/06

% Request to clip arrows at the plot edge.

% m_vec as an input below. It pairs with tag, such that
% you can do findobj('tag', 'm_vec'):


if strcmp(edgeclip,'off')
    % This is the "default" case:
%     hp = patch('Faces', Faces, 'Vertices', Vert, 'tag', 'm_vec','clipping','off');
    hp = patch('Faces', Faces, 'Vertices', Vert, 'tag', 'm_vec');
else
% %   [LG,LN]=m_xy2ll(reshape(Vert(:,1),7,nvec),reshape(Vert(:,2),7,nvec)); % Converts vertices in 7 point lines (i.e. columns) in lat/long
% %   [X,Y]=m_ll2xy(LG,LN  ,'clip','patch');                                % Converts back to x/y, but does clipping on for each column
    hp = patch('Faces', Faces, 'Vertices', [X(:) Y(:)], 'tag', 'm_vec','clipping','off');
end;


if ischar(c) || (size(c,1) == 1 && size(c,2) == 3),
    % This is the "default" case:
    set(hp, 'EdgeColor', c, 'FaceColor', c, 'LineWidth', 0.1);
else
    set(hp, 'EdgeColor', 'none', 'FaceColor','Flat', ...
                                        'FaceVertexCdata', c);
end

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

if nargout==0
    clear hp ht
end


%%  -----------------------------------------------------------------------
% I HAVE TO MAKE SURE THE SCALING OF THE PLOT IS RIGHT! -------------------
%  ------------------------------------------------------------------------

% Call the following to fix the plot box aspect ratio. The only thing is
% that I have to figure out what is a good aspect ratio, based on
% "standard scales" (that I have to choose, based on aesthetics I like)
% for the axes
%
% What has to be set is the data aspect ratio, not really the plotbox
% pbaspect([1 1 1])

% daspect([1 1 1])

% 1 - I have to create the axes before patching so the scaling is fixed.
% Make it possible to input up to 3D axes limits/vectors, or get the
% locations from the data.

% 2 - But I also want to make it possible to plot more arrows in a
% different call, changing the domain. Can I do that or should I give up on
% this?

% 3 - Then I'll have to fix the magnitude scale.

% 4 - Why it seems the patching has a hold on?
