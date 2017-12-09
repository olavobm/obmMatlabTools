function customErrorbar(haxs, t, errlims, dirstr, varargin)
% CUSTOMERRORBAR(haxs, t, errlims, dirstr, varargin)
%
%   inputs
%       - 
%       -
%       -
%
%
%
%
%
% Olavo Badaro Marques, 08/Dec/2017.


%%

p = inputParser;

defaultColor = 'k';
defaultWidth = 1;
defaultLen = NaN;

addParameter(p, 'BarLen', defaultLen)
addParameter(p, 'LineWidth', defaultWidth)
addParameter(p, 'Color', defaultColor)

parse(p, varargin{:})


%%

if ~exist('dirstr', 'var')
    
    dirstr = 'v';
    
else

    if ~(strcmp(dirstr, 'v') || strcmp(dirstr, 'h'))
        error('Error!')
    end

end

%
if strcmp(dirstr, 'v')
    lvert = true;
else
    lvert = false;
end


%%

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


%% Create three line (6 coordinates) segments that constitue
% each errorbar

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

     
%%

if lvert
    xplt = x_aux;
    yplt = y_aux;
else
    xplt = y_aux;
    yplt = x_aux;   
end


%%

plot(haxs, xplt, yplt, 'Color', p.Results.Color, 'LineWidth', p.Results.LineWidth)
