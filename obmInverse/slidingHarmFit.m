function [dfit, mfit, errfit] = slidingHarmFit(x, d, xfit, wnd, imf, lpartfit, minptsfit, lprogmsg)
% [dfit, mfit] = SLIDINGHARMFIT(x, d, xfit, wnd, imf, lpartfit, minptsfit, lprogmsg)
%
%   inputs
%       - x: vector or matrix consistent with
%            the number of columns of d.
%       - d: data array for calculating least-squares fit.
%       - xfit: vector of x-points on which to
%               make a least-squares estimate.
%       - wnd: window length (in units of x).
%       - imf: input-model-fit structure with info for the
%              fit to be computed (see myleastsqrs.m).
%       - lpartfit (optional):
%       - minptsfit (optional): default is 0, but you may have problems
%                               (such as little data to make a fit).
%       - lprogmsg (optional): logical variable to display partial progress
%                              of this function, which may be useful since
%                              this calculation may take a long time
%                              (default is false).
%
%   outputs
%       - dfit:
%       - mfit:
%       - errfit: cell array with error on the model parameters.
%
% This function computes a least squares fit using only a segment (window)
% of the dataset. Fits are estimated for each point in xfit.
%
% IMPORTANT NOTE: for each windowed segment, we only retrieve the fitted
% value for the midpoint of the window. It would be much more
% computationally expensive to fit for a certain region, because of the
% need to do some averaging over overlapping windows.
%
% TO REPLACE sliding_harmonicfit.m
%
% Olavo Badaro Marques, 18/Apr/2017.


%% If not given as inputs, choose default values for parameters

%
if ~exist('lprogmsg', 'var')
    lprogmsg = false;
end

%
if ~exist('minptsfit', 'var') || isempty(minptsfit)
    minptsfit = 0;
end


%%

minptsSide = 0.4;
minptsSide = minptsSide * minptsfit;


%% Now look at the sizes of x and d to determine the numbers
% "xn" and "dn" to loop over:

if isvector(x)
    
    xn = 1;
    dn = size(d, 1);
    
    % Make sure x is a row vector:
    if iscolumn(x)
        x = x';
    end
    
else
    
    xn = size(x, 1);
    dn = 1;
    
end


%% Pre-allocate:

%
if iscell(lpartfit)
    Nkeeps = length(lpartfit);
else
    Nkeeps = 1;
end

% Pre-allocate:
dfit = NaN(size(d, 1), length(xfit), Nkeeps);

mfit = cell(size(d, 1), length(xfit), Nkeeps);

errfit = cell(size(d, 1), length(xfit), Nkeeps);


%% Now go for the windowed harmonic fit:

% Take the window half length:
halfwnd = wnd/2;

% Loop through the levels with different x vectors
% (greater than 1, only if x is a matrix):
for i1 = 1:xn
    
    % Get the i1th row of x:
    xaux = x(i1, :);
    
    % Loop through the points where we estimate fits (points of xfit):
    for i2 = 1:length(xfit)
        
        linWindow = (xaux >= (xfit(i2) - halfwnd)) & ...    % this selection already
                    (xaux <= (xfit(i2) + halfwnd));         % excludes NaN in xaux! Cool!
                                                                          
        
        imf.domain = xfit(i2);
        
        % Loop through the rows of d that have same x, which is all of
        % them if x is a vector or only one row if x is a matrix:
        for i3 = 1:dn

            %
            dwndaux = d(i3 + i1-1, linWindow);

            if length(find(~isnan(dwndaux))) >= minptsfit
            
                xaux_2 = xaux(linWindow);
                xaux_2 = xaux_2(~isnan(dwndaux));
                
                dist_aux = xaux_2 - imf.domain;

                % First try
                lmost = (sum(abs(dist_aux) < (0.7*halfwnd))./length(dist_aux)) >= 0.5;

                % Only do the calculation if there are enough points
                % to the right and to the left of center point
                if length(dist_aux(dist_aux > 0)) > minptsSide && ...
                   length(dist_aux(dist_aux < 0)) > minptsSide && lmost
               
                    % Should test this first (it tried to create a huge
                    % error covariance matrix). Now it should work:
    %                 [fit_aux, m_aux, G_aux, err_aux] = myleastsqrs(xaux(linWindow), dwndaux, imf);
                    [fit_aux, m_aux, G_aux] = myleastsqrs(xaux(linWindow), dwndaux, imf);

                    if exist('lpartfit', 'var')
                        [fit_aux, m_aux] = partialFit(lpartfit, m_aux, G_aux);
    %                     err_aux.mErr = err_aux.mErr(lpartfit);
                    end

                    %
                    for i4 = 1:Nkeeps

                        % Assign fitted value to output in the appropriate location:
                        dfit(i3 + i1-1, i2, i4) = fit_aux(:, i4);
                        mfit{i3 + i1-1, i2, i4} = m_aux(:, i4);

        %                 errfit{i3 + i1-1, i2, i4} = err_aux.mErr;

                    end   
               
                end
                
             
                
            end
        end
        
        % If true, prints progress message (correspondent to 20%):
        if lprogmsg
            dispforProgress(i2, [1, length(xfit)], round(length(xfit)*0.2), 1)
        end
        
    end

    % If true, prints progress message (correspondent to 20%):
    if lprogmsg
        dispforProgress(i1, [1, xn], round(xn*0.2), 1)
    end
    
end

