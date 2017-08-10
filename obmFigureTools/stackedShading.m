function stackedShading(y, x, lnorm)
% STACKEDSHADING(y, x, lnorm)
%
%	inputs
%       - y: matrix.
%       - x (optional): independent variable vector associated
%                        with the columns of y.
%       - lnorm (optional): normalize such that it shows the
%                           relative contribution of each row of y.
%                           Default is false.
%
% STACKEDSHADING creates stacked shading plot where each row of y is shaded
% behind the former tow of y. This plot is particularly useful when all
% entries of y have the same sign (if different signs occur, weird behavior
% will occur).
%
% If lnorm is true, the shadings add up to 1 for all columns of y, except
% for the columns in which all elements are zero, in which case the
% associated shadings are all zero.
%
% Use the standard Matlab colors as long as your version is at least
% 2014b. For additional colors, STACKEDSHADING calls brewermap.m. If
% you want to specify your colors, you have to edit this function (for
% example, by defining a colorsets.set0).
%
% No NaNs are allowed in y! Would be awesome to leave gap on the plot
% (but kind of time consuming to implement that).
% 
% Olavo Badaro Marques, 29/Nov/2016.


%% Check inputs and define default options

if ~exist('x', 'var') || isempty(x)
    x = 1:size(y, 2);
end

if ~exist('lnorm', 'var')
    lnorm = false;
end

if find(isnan(y), 1)
    error('Input y has NaNs. This is not allowed!')
end


%% All the possible colors

% If you have your colors, add them here.
% colorsets.set0

try
    % groot was implemented in Matlab2014b
    colorsets.set1 = get(groot,'DefaultAxesColorOrder');
catch
    warning(['Your Matlab version is probably older than 2014b. ' ...
             'Default colors of the plot may be different than '  ...
             'what you expect.'])
end

try
    colorsets.set2 = brewermap(9, 'Set1');
    colorsets.set3 = brewermap(8, 'Set2');
    colorsets.set4 = brewermap(12, 'Set3');
catch
    warning('You don''t have the function brewermap.m in your path.')
end


%% Subset the color that will be used

colorfields = fieldnames(colorsets);

neachset = structfun(@(x) size(x, 1), colorsets);
nallcolors = sum(neachset);

allcolors = NaN(nallcolors, 3);

indrow = 0;

for i1 = 1:length(colorfields)
    for i2 = 1:neachset(i1)
        indrow = indrow + 1;
        allcolors(indrow, :) = colorsets.(colorfields{i1})(i2, :);
    end
end


%% Subset the colors that we want

n = size(y, 1);

if n > nallcolors
    error(['Number of rows of y is greater than the ' ...
           '' num2str(nallcolors) ' colors we have available.'])
end

ncolors = allcolors(1:n, :);
ncolors = flipud(ncolors);


%% Rearrange RGB colors in a 3-D array because that
% is the requirement of fill/patch function

ncolorsfill = reshape(ncolors, n, 1, 3);


%% Normalize if required and do cumulative sum for plotting

yplt = y;

if lnorm
    ysum = sum(y, 1);
    ysum(ysum==0) = 1;
    yplt = y./repmat(ysum, n, 1);
end

yplt = cumsum(yplt, 1);


%% Add corners to create the shading

xpts = [x(1), x, x(end)];
xpts = xpts';
xpts = repmat(xpts, 1, n);  % according to Matlab's fill function 
                            % documentation  this should not be necessary

ypts = [zeros(n, 1), yplt, zeros(n, 1)];
ypts = ypts';

ypts = fliplr(ypts);   % flip such that the first row of y is plotted on
                       % top of all the other


%% Plot the shaded regions

patch(xpts, ypts, ncolorsfill)
set(gca, 'FontSize', 14)   % my taste
xlim([min(x) max(x)])
    