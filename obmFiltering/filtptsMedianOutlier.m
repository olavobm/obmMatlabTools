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


%%
%
% % % if nr==1
% % % 	x = x(:);
% % % %     lxinrow = true;
% % %     N = nc;
% % % else
% % % %     lxinrow = false;
% % %     N = nr;
% % % end


%%
%
% Does it matter whether it is copied or a loop is used?
% For large nlen that would make a huge differentce.

% % xrep = NaN(, );

%
midptlen = ceil(nlen/2);
wdtptlen = floor(nlen/2);

%
allmed = NaN([nr, nc]);

%
for i = midptlen : (N-wdtptlen)
    
	%
    allmed(i) = nanmedian(x((i-wdtptlen):(i+wdtptlen)));
    
end


%% Calculate the median deviation

%
dev_from_median = abs(x - allmed);

%
median_dev = nanmedian(dev_from_median);


%%

lisoutlier = dev_from_median > (thrh*median_dev);


%% Substitute outliers by median value around that segment

xfilt(lisoutlier) = allmed(lisoutlier);

