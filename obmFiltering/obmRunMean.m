function [xnew] = obmRunMean(x, npt, fracwndw, wndwtype)
% [xnew] = OBMRUNMEAN(x, npt, wndwtype)
%
%   input:
%       - x: vector or matrix, regularly spaced across the rows (the
%            dimension where the running mean is applied).
%       - npt: length of window in number of points.
%       - fracwndw: fractional quantity of points inside a window required
%                   to compute mean. Default is 0.5.
%       - wndwtype:
% 
% input wndwtype is (?) OPTIONAL!
%
%   output:
%       - xnew:
%
% npt must be odd!!!!!!!!
%
% Function to filter in one dimension using a running mean in the
% physical/time domain. Input x can also be a matrix, but in this
% case, each column is filtered separately. If you want to filter
% every row, then transpose the input AND the output.
%
% There is a cumsum "trick" I could copy from "nanmoving_average.m".
% could also look at oldstuff folder.s
%
% Olavo Badaro Marques, 02/May/2016, created
%                       25/Oct/2016, implemented fracwndw

% CHECK THE PHASE OF THE EDGES.
%
% depends whether x is even or odd.... 
%
% How do we deal with NaNs???? ALLOW INTERPOLATION OR NOT OVER NANs
%
% Add option to cut or not the edges.


%% Check input, check fracwndw and set type of window to use:

if ~exist('fracwndw', 'var')
    fracwndw = 0.5;
end

%  If optional input not specified, set to hanning (default):
if nargin <= 3
    wndwtype = 'hann';
end
   
% Transform string to function handle using
% a standard Matlab function:
wndwtype = str2func(wndwtype);
    

%% Create window with length number of points equal to "npt".
%  Matlab returns a column vector:

filterwindow = window(wndwtype, npt);


%% Check size of input x. If x is row vector, transpose it.
%  Remember that if x is a matrix, filtering is done for
%  every column:

% [rx, cx] = size(x);

% Transpose if input x is a row vector. Create
% a logical to transpose it back if necessary:
if isrow(x)
%     filterwindow = filterwindow';
    x = x';
    lisrow = true;
else
    lisrow = false;
end

% % Check if x is a matrix -- because if it is,
% % we will loop through its columns:
% if rx>1 && cx>1
%     lismat = true;    % logical saying it is a matrix
% end

[~, cx] = size(x);


%% Now do the running mean, looping through all elements
%  of x. Inside the loop the mean is computed in one of
%  three ways: (1) the regular way or (2)/(3) using only
%  part of the window for beginning/end edge of the data:

% Pre-allocate space for the result:
xnew = NaN(size(x));

% At this point x is either a column vector or a matrix.
% We loop through all of its columns:
for i1 = 1:cx
    
    xaux = x(:, i1);

    % Loop through all data points. Inside each if case, window
    % weights and indices for subsetting the data are determined.
    % The actual mean is computed after this if block:
    for i2 = 1:length(xaux)

        % Beginning of the record:
        if     i2<ceil(npt/2)

            window_weights = filterwindow( ceil(npt/2) - (i2-1) : end );
            ind_xinwindow = 1:i2+floor(npt/2);

        % At the end of the record:
        elseif length(xaux)-i2<floor(npt/2)

            window_weights = filterwindow( 1:end-(i2-(length(xaux)-floor(npt/2))));
            ind_xinwindow = i2-(floor(npt/2)):length(xaux);

        % In the interior of the record:
        else
            
            window_weights = filterwindow;
            ind_xinwindow = i2-floor(npt/2) : i2+floor(npt/2);
        end

        % Get the indices of the numbers in the windowed chunk
        % xaux(ind_xinwindow), that are NOT NaN to see what is
        % the percentage in the chunk of good data:
        indgoodpts = find(~isnan(xaux(ind_xinwindow)));
        ngoodpts = length(indgoodpts);
        nwdnwpts = length(ind_xinwindow);
        
        % Only compute a weighted mean if the fraction
        % of good data satisfy the criterion fracwndw:
        if (ngoodpts/nwdnwpts) >= fracwndw
%         if any(~isnan(xaux(ind_xinwindow)))

            % xnew(i2, i1) = nansum( xaux(ind_xinwindow) .* window_weights) ./...
            %                                          sum(window_weights);
            % DO NOT USE ALL THE WEIGHTS NECESSARILY!!!!
            
            xnew(i2, i1) = sum( xaux(ind_xinwindow(indgoodpts)) .* ...
                                 window_weights(indgoodpts))     ./...
                                           sum(window_weights(indgoodpts));
        end

    end
    
    % Include a message to let user know
    % how far along we've gone:
    if cx > 1
        messstep = round(0.1*cx);
        if mod(i1, messstep)==0
            disp(['Filtering column ' num2str(i1) ' out of ' num2str(cx) ''])
        end
    end
    
end


%% If x was originally a row vector, transpose it back to that:

if lisrow
    xnew = xnew';
end