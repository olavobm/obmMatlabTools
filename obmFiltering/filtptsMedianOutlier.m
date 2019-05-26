function [xfilt] = filtptsMedianOutlier(nlen, thrh, x)
% [xfilt] = FILTPTSMEDIANOUTLIER(nlen, thrh, x)
%
%   inputs
%       - nlen:
%       - thrh:
%       - x: a vector.
%
%   outputs
%       - xfilt:
%
%
% TO DO:
%	- Make nlen in terms of a dependent variable???
%   - Add recursive option???
%   - Do something about edges.
%
% Olavo Badaro Marques, 26/May/2019.


%%

%
if mod(nlen, 2)==0
    %
    error('Length of number of points is even and it must be odd.')
end

%
[nr, nc] = size(x);

%
if nr~=1 && nc~=1
	%
    error('Input data is not a vector.')
end

%
N = nr*nc;

%
xfilt = x;


%% Calculate the medians ove nlen segments for the interior of x
%
% It is Create 

%
midptlen = ceil(nlen/2);
wdtptlen = floor(nlen/2);

%
xrep = NaN(N, nlen);

%
for i = 1:nlen
   
    %
    xrep(midptlen:(N-wdtptlen), i) = x(i:(N - nlen + i));
end

%
allmed = nanmedian(xrep, 2);
allmed = reshape(allmed, [nr, nc]);


% ------------------------------------------------
% % % Bad loop (though it works) -- actually, not so bad
% % for i = midptlen : (N-wdtptlen)    
% % 	xrep(i, :) = x((i-wdtptlen):(i+wdtptlen));
% % end

% ------------------------------------------------
% % % % A less efficient alternative
% % %
% % allmed = NaN([nr, nc]);
% % 
% % %
% % for i = midptlen : (N-wdtptlen)
% % 	%
% %     allmed(i) = nanmedian(x((i-wdtptlen):(i+wdtptlen)));
% % end




%% Calculate the median deviation

%
dev_from_median = abs(x - allmed);

%
median_dev = nanmedian(dev_from_median);


%%

lisoutlier = dev_from_median > (thrh*median_dev);


%% Substitute outliers by median value around that segment

xfilt(lisoutlier) = allmed(lisoutlier);

