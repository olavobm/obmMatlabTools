function hplt = plotFill(x, y, yerror, varargin)
% hplt = PLOTFILL(x, y, yerror, varargin)
%
%   inputs
%       - x: vector of x coordinates.
%       - y:   "    "  y      ".
%       - yerror: scalar or vector of the error around y.
%       - varargin: property name-value pairs
%                   that set the a fill object.
%
%
%   outputs
%       - hplt: plot handle (output of function fill.m).
%
%
% As it is, PLOTFILL.m only plots a symmetric error yerror around y.
%
% Olavo Badaro Marques, 08/Jan/2019.


%% Allow for the first input to be instead
% the axes handle where the plot is overlain

if isgraphics(x)

    haxsplt = x;
    x = y;
    y = yerror;
    yerror = varargin{1};
    
    if length(varargin)>1
        varargin = varargin(2:end);
    else
        varargin = {};
    end
    
else
    
    haxsplt = gca;
       
end


%% Turn variables into column vectors to arrange them afterwards

xvec = x(:);
yvec = y(:);
yerror = yerror(:);


%% I should sort the variables to avoid messing up with the fill

% % xplt = sort(xvec);


%% Stack the upper and lower curves and join
% them to create the coordinates of the polygon

%
xplt = [xvec; flipud(xvec)];
yplt = [(yvec + yerror); flipud(yvec - yerror)];

%
xplt = [xplt; xplt(1)];
yplt = [yplt; yplt(1)];


%% Now overlain the plot

% My old Matlab version does not allow haxsplt
% to be the first input of fill.m. So here I
% make haxsplt the current axes handle.
axes(haxsplt);

% Finally overlain the plot
hplt = fill(xplt, yplt, 'k');

% Loop over properties and set their values
nproperties = length(varargin) / 2;
for i = 1:nproperties
    hplt.(varargin{2.*i - 1}) = varargin{2.*i};
end
