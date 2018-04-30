function ldiff = significDiff(data_prec, data_diff, n_prec)
% ldiff = SIGNIFICDIFF(data_prec, data_diff, n_prec)
%
%   inputs
%       - data_prec:
%       - data_diff:
%       - n_prec:
%
%   outputs
%       - ldiff:
%
%
%
%
% Olavo Badaro Marques, 30/Apr/2018


%%

if ~exist('n_prec', 'var')
	n_prec = 1;
end


%%

data_diff = abs(data_diff);


%%

%
cte_factor = 2 * n_prec;

%
l_insigDiff = data_diff<=(cte_factor * data_prec);

l_realDiff = data_diff>(cte_factor * data_prec);


%%

%
ldiff = NaN(size(data_diff));

%
ldiff(l_realDiff) = true;
ldiff(l_insigDiff) = false;
