function ldiff = significDiff(data_prec, data_diff, n_prec)
% ldiff = SIGNIFICDIFF(data_prec, data_diff, n_prec)
%
%   inputs
%       - data_prec: data precision.
%       - data_diff: array with the difference between two datasets.
%       - n_prec (optional): number of precision (default is 1).
%
%   outputs
%       - ldiff: logical array indicating whether the difference is
%                statistically significant (when ldiff is true).
%
% SIGNIFICDIFF returns a logical array, with the same size
% as data_diff, where true (false) are for the data_diff's
% that are (not) statiscally significant.
% 
% The threshold is defined by 2 * data_prec * n_prec.
%
% n_prec is an optional input and its default value
% is 1. This is meant to represent how many errors
% away from the measurement you want to consider
% (a larger n_prec is qualitatively related to a higher
% confidence interval for a significant difference).
%
% Olavo Badaro Marques, 30/Apr/2018


%% If optional input was not given, set to default value

if ~exist('n_prec', 'var')
	n_prec = 1;
end


%% Make differences positive definite

data_diff = abs(data_diff);


%% Determine which differences are above the threshold

%
cte_factor = 2 * n_prec;

%
l_signifDiff = data_diff > (cte_factor * data_prec);


%% Create output variable and set true to the
% indices where the difference is significant

%
ldiff = false(size(data_diff));

%
ldiff(l_signifDiff) = true;

