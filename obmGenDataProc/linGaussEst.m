function y = linGaussEst(tx, x, decorScale, xnoise, ty)
%
%
%   inputs:
%       - tx:
%       - x:
%       - decorScale:
%       - ty:
%
%   outputs:
%       - y:
%
%
% Olavo Badaro Marques, 23/Mar/2017.


%%


%%

x = x(:);

% Generalizing cov:
n = length(x);

tx = tx(:);    % make sure it is a column vector
txGrid = tx * ones(1, n);
txGridaux = txGrid';

% Data-data covariance matrix:
ddCov = exp(-( (txGrid - txGridaux)./decorScale).^2 );
ddCov = ddCov + diag(repmat(xnoise, n, 1));

% Data-grid covariance matrix:
ty = ty(:);
tyGrid = ty * ones(1, n);
% tyGrid = tyGrid';
txRep = ones(length(ty), 1) * tx';

dgCov = exp(-((txRep - tyGrid)/decorScale).^2);

% skill(:, n) = diag(ct/cov*ct');

% Estimate values at the grid points ty:
y = dgCov / ddCov * x;


%% Plot:

figure
    subplot(2,1,1)
        plot(ty, y)
        xlabel('t')
        ylabel('x');
%     subplot(2,1,2)
%     plot(t,skill),xlabel('t'),ylabel('skill')

