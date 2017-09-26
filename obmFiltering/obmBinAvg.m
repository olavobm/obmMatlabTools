function [xout, xstd, xn, tout] = obmBinAvg(t, x, binlen, tbin, wndhandle, lreg)
% [xout, xstd, xn, tout] = OBMBINAVG(t, x, binlen, tbin, wndhandle, lreg)
%
%   input
%       - t: independent variable
%       - x: vector or matrix. In the second case, bin averaging is
%            done for each row independently.
%       - binlen: window length in units of t.
%       - tbin (optional): t values for the center of the bins to take
%                          the average of (default is to use t).
%       - wndhandle (optional): default is @hann. 
%       - lreg (optional): logical variable to specifiy whether t is
%                          regularly spaced and result is to reduce
%                          the number of data points (default is false).
%
%   output
%       - xout: x averaged at tbin.
%       - xstd: standard deviation of the values used to compute xout.
%       - xn: number of values used to compute xout and xstd.
%       - tout:
%
% OBMBINAVG bin-averages the variable x, which is specified at t. The
% length of each bin, in units of t, is given by binlen and the center
% of each bin is specified by tbin (i.e. the points used in each average
% are taken half-window to the left and half to the right of tbin).
%
% If tbin is not given as an input, then it is set to t. Another optional
% input is wndhandle, which is a window handle, which specified a window
% to multiply each bin of x.
%
% lreg ...
% 
%
% TO DO:
%	- t regularlt spaced included. Code needs to be improved and to allow
%     x to be a matrix for this case.
% 	- allow t to be a matrix?
%   - include minimum number of points per window?
%
% Olavo Badaro Marques, 20/Mar/2017.


%% If no window is specified, choose a default window:

if ~exist('wndhandle', 'var') || isempty(wndhandle)
    wndhandle = @hann;
end

if ~exist('lreg', 'var')
    lreg = false;
end


%%

if ~exist('tbin', 'var') || isempty(tbin)
    tbin = t;
end

tbin = tbin(:);

%
if iscolumn(x)
    x = reshape(x, 1, length(x));
end


%%

% Pre-allocate space for outputs:
nr = size(x, 1);
nc = length(tbin);

xout = NaN(nr, nc);
xstd = NaN(size(xout));
xn = zeros(nr, nc);

%
tbinlims = [tbin - (binlen/2), tbin + (binlen/2)];

%
for i1 = 1:nr
    
    if lreg
        
        %
        indtstep = dsearchn(t(:), t(1) + binlen);
% %         indtstep = indtstep - 1;    % -1 to not include both ends

        indlast = length(t) - mod(length(t), indtstep);

        % Should be outisde of the loop
        ti = reshape(t(1:indlast), indtstep, indlast./indtstep);
        
        %
        xi = reshape(x(i1, 1:indlast), indtstep, indlast./indtstep);
        
        xout = nanmean(xi, 1);
        xstd = nanstd(xi, 0, 1);
        tout = mean(ti, 1);

    else
    
        for i2 = 1:length(tbin)

            linbin = (t >= tbinlims(i2, 1)) & ...
                     (t <= tbinlims(i2, 2));

            %
            if any(linbin)

                % Call function to compute weights for the weighted mean
                % (for boxcar window, the weights are simply 1):
                if isequal(wndhandle, @rectwin)
                    avgWeights = ones(1, length(t(linbin)));
                else
                    avgWeights = windowatt(wndhandle, tbinlims(i2, :), t(linbin), 15*length(t(linbin)));
                    avgWeights = avgWeights(:)';    % make it a row vector
                end
                
                %
                x_aux = x(i1, linbin);
                l_aux_ok = ~isnan(x_aux);
                
                if any(l_aux_ok)
                    
                    %
                    xout(i1, i2) = nansum( x_aux .* avgWeights ) ./ sum(avgWeights(l_aux_ok));

                    %
                    xstd(i1, i2) = nanstd(x(i1, linbin));

                    xn(i1, i2) = sum(linbin);
                end

            end

        end
    
    end
end


