function customErrorbar(haxs, t, errlims, dirstr, varargin)
% CUSTOMERRORBAR(haxs, t, errlims, dirstr, varargin)
%
%   inputs
%       - haxs: axes handle to plot on.
%       - t: independent variable of where to plot errorbars.
%       - errlims: 2xlength(t) array with limits of the error bar.
%       - dirstr (optional): 'v' (vertical) or 'h' (horizontal) for
%                            the orientation of the errorbar (default
%                            is vertical).
%       - varargin: set appearance of the colorbar with following options
%                       * BarLen
%                       * LineWidth
%                       * Color
%
% Olavo Badaro Marques, 08/Dec/2017.


%% Parse optional inputs controlling the errorbar appearance

p = inputParser;

defaultColor = 'k';
defaultWidth = 1;
defaultLen = NaN;

addParameter(p, 'BarLen', defaultLen)
addParameter(p, 'LineWidth', defaultWidth)
addParameter(p, 'Color', defaultColor)

parse(p, varargin{:})


%% Check errorbar orientation

if ~exist('dirstr', 'var')
    
    dirstr = 'v';
    
else

    if ~(strcmp(dirstr, 'v') || strcmp(dirstr, 'h'))
        error('Error!')
    end

end

% Logical variable associated with the orientation
if strcmp(dirstr, 'v')
    lvert = true;
else
    lvert = false;
end


%% If BarLen is not given, use axis limits
% to determine what an appropriate length

if isnan(p.Results.BarLen)
    lenVal = 0.1;

    if strcmp(dirstr, 'v');
        lenEB = haxs.XLim;
    else
        lenEB = haxs.YLim;
    end
    lenEB = lenVal .* (lenEB(2)-lenEB(1));
else
    lenEB = p.Results.barLen;
end


%% Create three line (6 coordinates) segments
% that constitue each errorbar

% Bottom bar
x_aux_1_a = t - 0.5.*lenEB;
x_aux_1_b = t + 0.5.*lenEB;

% Upper bar
x_aux_2_a = t - 0.5.*lenEB;
x_aux_2_b = t + 0.5.*lenEB;

% Center line
x_aux_3_a = t;
x_aux_3_b = t;

%
y_aux_1_a = errlims(1, :);
y_aux_1_b = errlims(1, :);

y_aux_2_a = errlims(2, :);
y_aux_2_b = errlims(2, :);

y_aux_3_a = errlims(1, :);
y_aux_3_b = errlims(2, :);

%
x_aux = [x_aux_1_a, x_aux_2_a, x_aux_3_a ; ...
         x_aux_1_b, x_aux_2_b, x_aux_3_b];

y_aux = [y_aux_1_a, y_aux_2_a, y_aux_3_a ; ...
         y_aux_1_b, y_aux_2_b, y_aux_3_b];

     
%% Assign vertices to the appropriate plotting
% variables according to the orientation

if lvert
    xplt = x_aux;
    yplt = y_aux;
else
    xplt = y_aux;
    yplt = x_aux;   
end


%% Plot the errorbars

plot(haxs, xplt, yplt, 'Color', p.Results.Color, ...
                       'LineWidth', p.Results.LineWidth)
