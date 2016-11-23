function [dnew, xnew] = sliding_harmonicfit(x, d, wnd, slidestep, imf, lpartfit)
% [dnew, xnew] = SLIDING_HARMONICFIT(x, d, wnd, slidestep, imf)
%
%   inputs:
%       - x: vector OR matrix with independent variable (i.e. where d is
%            specified). Usually x is a vector, read below what this
%            function does when x is a matrix.
%       - d: data vector or matrix (dependent variable). The fits are done
%            independently for each row of d.
%       - wnd: number that sets the window length, in the SAME UNITS as x.
%       - slidestep: number of points by which the window is shifted
%                    over the data. Note this is NOT in units of x.
%       - imf: input-model-fit structure variable (see myleastsqrs.m for
%              what this input really means and how to create it).
%       - lpartfit (optional): logical array indicating a partial component
%                              of the fit (input for partialFit funtion).
%                              Default behavior is to keep the entire model
%                              fit. CELL ARRAY OPTION NOT IMPLEMENTED YET!
%                              in this other case, dnew would extend to
%                              the third dimension (EVEN IF IT IT WAS A
%                              VECTOR FOR EACH FIELD OF THE CELL ARRAY. IN
%                              WHICH CASE WE WOULD HAVE A MATRIX ACROSS THE
%                              THIRD DIMENSION).
%
%   outputs:
%       - dnew: data 
%       - xnew:
%
% This function computes a least squares fit using only a segment (window)
% of the dataset. The window is shifted (slid) along the record in order
% to make estimates for the entire record (except at the edges).
%
% IMPORTANT NOTE: for each windowed segment, we only retrieve the fitted
% value for the midpoint of the window. It would be much more
% computationally expensive to fit for a certain region, because of the
% need to do some averaging over overlapping windows.
%
% Olavo Badaro Marques:
%    Log -- 26/Aug/2016: created on this day
%           14/Nov/2016: major update, implementing matrix x case.

% -------------------------------------------------------------------------
%                    CAN wnd BE EVEN OR ODD ????????????????
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% SHOULD I GO FOR TIMES OR POINTS ?????????????????????????????????????????

% IF slidestep IS IN DAYS, THAT IS USEFUL FOR INTERPOLATION. BUT IF I DO
% NOT WANT THAT, IT IS MUCH MORE USEFUL IF THIS IS IN DATA POINTS.

% THERE IS AN OPTION OF KEEPING XNEW THE SAME AS X (WHICH MAY NOT BE EVENLY
% SPACE IN TIME!!!!!!!), AND THERE IS ALSO THE OPTION FOR SUBSET (which is
% useful if you are doing a "long-period filtering").
% -------------------------------------------------------------------------


%% Take the window half length (which is the variable
% that is used below) and :

halfwnd = wnd/2;

if isvector(x)
    
    xn = 1;
    dn = size(d, 1);
    
    if iscolumn(x)
        x = x';
    end
    
else
    
    xn = size(x, 1);
    dn = 1;
    
end


%% 

% Pre-allocate (DEPENDS ON THE INTERPOLATION OR NON-OPTION.....):
dnew = NaN(size(d));

% Loop through the levels with different x vectors
% (greater than 1, only if x is a mtrix):
for i1 = 1:xn
    
    % Get the i1th row of x:
    xaux = x(i1, :);

    % Get indices of the first and last data points
    % that are at the center of the window:
    indfirstx = find(xaux-xaux(1) >= halfwnd, 1, 'first');
    indlastx = find((xaux(end)-xaux(1))-(xaux-xaux(1)) >= halfwnd, ...
                                                                1, 'last');
    xwndcfirst = xaux(indfirstx);
    xwndclast = xaux(indlastx);

    % Central date of the window for the while loop below:
    indwndcenteraux = indfirstx;
    xwndcenteraux = xwndcfirst;

    % Look at first and last indices in order to include a timer
    % inside the loop (to print on the screeen message of how long
    % it is going to take):
    nindstots = indlastx - indfirstx + 1;
    
    % Loop through xaux (i.e. slides the window by slidestep):
    while xwndcenteraux <= xwndclast

        linwindow = xaux >= (xwndcenteraux - halfwnd) & ...
                    xaux <= (xwndcenteraux + halfwnd);
        
        xwndedaux = xaux(linwindow);

        % Loop through the rows of d that have same x, which is all of
        % them if x is a vector or only one row if x is a matrix:
        
        imf.domain = xwndcenteraux;
        
        for i2 = 1:dn
            
            dwndaux = d(i2 + i1-1, linwindow);

            [fit_aux, m_aux, G_aux] = myleastsqrs(xwndedaux, dwndaux, imf);

            if exist('lpartfit', 'var')
                fit_aux = partialFit(lpartfit, m_aux, G_aux);
            end

            % Assign fitted value to output in the appropriate location:
            dnew(i2 + i1-1, indwndcenteraux) = fit_aux;
        end
        
        % Update window center indice and the associated date:
        indwndcenteraux = indwndcenteraux + slidestep;
        xwndcenteraux = xaux(indwndcenteraux);      % sliding based on points - good for keeping the raw data timing
                
% ----------------------------------------------------------------
        % Sliding based on time - good for interpolation (WHICH IS NOT
        % IMPLEMENTED YET!!!)... should I ever implement it???
%         xwndcenteraux = xwndcfirst + slidestep;   
% ----------------------------------------------------------------


    disp(['On window center ' num2str(xwndcenteraux) ', last is ' num2str(xwndclast) ''])
    
%         % Print message to the screen of how long it is going to take:
% %         if rem(i1, round(0.2*xn)) == 0
% %             if rem(indwndcenteraux - indfirstx, round(0.25 * nindstots))==0
% %                 disp(['At row ' num2str(i1) ' of ' num2str(xn) ', ' ...
% %                       'doing window ' ...
% %                       num2str(indwndcenteraux - indfirstx) ' of ' ...
% %                       num2str(nindstots) ''])
% %             end
% %         end

    end

end


%%

xnew = x;

